import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../common/routing_const.dart';
import '../../models/plain_model/entity.dart';
import '../../models/view_model/browser_controller.dart';
import '../../utils/fileutils.dart';
import '../components/newfolder_dialog.dart';
import 'editor/controller.dart';

/// Local files & directories browser
class WorkspaceExplorerScreen extends StatefulWidget {
  /// THe directory whose content will be shown in this widget.
  final Directory dir;

  final String title;

  /// THe browser widget which shows files and directories of [dir] directory.
  const WorkspaceExplorerScreen({Key key, @required this.dir, this.title})
      : super(key: key);
  @override
  _WorkspaceExplorerScreenState createState() =>
      _WorkspaceExplorerScreenState();
}

class _WorkspaceExplorerScreenState extends State<WorkspaceExplorerScreen> {
  BrowserController _view;
  final String _createNewHero = 'createNewHero';
  final String _createNewFileHero = 'createNewFileHero';
  EditorController controller;
  @override
  void initState() {
    super.initState();
    var dir = widget.dir ?? FileUtils.primaryRoot;
    var initView = Provider.of<BrowserController>(context, listen: false);
    initView.setCurrent(dir);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _view = Provider.of<BrowserController>(context);
    controller = Provider.of<EditorController>(context);
    super.didChangeDependencies();
  }

  Icon getFileTypeIcon(Entity object, bool isDark) {
    // TODO: Save computation here
    final stat = object?.stat;
    IconData data;
    // In UNIX, hidden files are files whose name starts with `.`
    final isHidden = object?.basename[0] == '.';
    Color color;
    switch (stat?.type) {
      case FileSystemEntityType.directory:
        data = EvaIcons.folder;
        color = isDark
            ? Color.lerp(Theme.of(context).accentColor, Colors.white, 0.25)
            : Theme.of(context).accentColor;
        break;
      case FileSystemEntityType.file:
        data = isHidden ? EvaIcons.fileOutline : EvaIcons.file;
        color = isDark ? Colors.white : Colors.grey;
        break;
      default:
        data = EvaIcons.alertCircleOutline;
    }
    if (isHidden) {
      // File represents a hidden entity
      color = color.withAlpha(0xbb);
    }
    return Icon(data, color: color);
  }

  String _idOfSelectedFile = '';

  bool _isFileSelected(String id) {
    return _idOfSelectedFile == id;
  }

  bool _isAFileSelected() {
    return _idOfSelectedFile?.isNotEmpty ?? false;
  }

  void _selectFileOnTap(String id) {
    assert(id != null);

    _idOfSelectedFile = id;
  }

  void _clearSelection() {
    _idOfSelectedFile = '';
  }

  void _toggleSelection(String id) {
    if (_isFileSelected(id)) {
      _clearSelection();
    } else {
      _selectFileOnTap(id);
    }
    setState(() {
      // update selection state on tap
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final isDark = _theme.brightness == Brightness.dark;
    final foregroundInDarkness = isDark ? Colors.white : Colors.black;
    final _whiterAccentColor =
        Color.lerp(_theme.accentColor, Colors.white, 0.3);
    final _tooltipMessage =
        _isAFileSelected() ? 'Select file' : 'Select this folder';

    final String _title =
        widget?.title ?? path.basename(widget.dir?.path ?? '');
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Visibility(
        visible: _view.currentEntities?.isNotEmpty ?? false,
        child: ListView.builder(
          key: ValueKey(_view.current.path),
          itemCount: _view.currentEntities.length,
          itemBuilder: (context, index) {
            final object = _view.currentEntities[index];
            final bool _isSelected = _isFileSelected(object.id);
            final bool _wasRecentlyCreated =
                _view.recentlyCreatedFolder.contains(object.absolutePath);

            Widget child = ListTile(
              key: ValueKey(object.id),
              onTap: () {
                if (object.entity is Directory) {
                  setState(() {
                    _clearSelection();
                  });

                  /// If the tapped tile is a directory, open it in a new
                  /// browser screen route
                  var x = Directory.fromUri(
                    Uri(path: object.absolutePath),
                  );
                  Navigator.pushNamed(context, BrowserScreenRoute,
                      arguments: x);
                } else if (object.entity is File) {
                  final page = EditorTabPage(object);
                  controller.addPage(page);
                  _toggleSelection(object.id);
                  Navigator.canPop(context);
                }
              },
              leading: getFileTypeIcon(object, isDark),
              title: Text(
                object.basename,
                style: TextStyle(
                  color: foregroundInDarkness,
                ),
              ),
              trailing: Visibility(
                visible: _wasRecentlyCreated,
                child: Icon(
                  Icons.fiber_new,
                  color: Colors.red,
                  size: 28,
                ),
              ),
            );

            if (_wasRecentlyCreated || _isSelected) {
              child = Container(
                color: _theme.primaryColor.withAlpha(_isSelected ? 0x33 : 0x22),
                child: child,
              );
            }

            return child;
          },
        ),
        replacement: Visibility(
          visible: !_view.stopLoading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
          replacement: Builder(
            builder: (context) {
              final _itemColor = _theme.accentColor.withAlpha(0xCC);
              Widget warning = Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    EvaIcons.infoOutline,
                    color: _itemColor,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'There\'s nothing here',
                    style: TextStyle(
                      color: _itemColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              );
              return Center(child: warning);
            },
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              newFolderDialog(context, (textController) {
                _view.createFileAndAddToRecent(context, textController.text);
              }, true);
            },
            heroTag: _createNewHero,
            icon: Icon(
              EvaIcons.fileAddOutline,
            ),
            label: Text('Create file'),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              newFolderDialog(context, (textController) {
                _view.createFolderAndAddToRecent(context, textController.text);
              });
            },
            heroTag: _createNewFileHero,
            icon: Icon(
              EvaIcons.folderAddOutline,
            ),
            label: Text('Create folder'),
          ),
        ],
      ),
    );
  }
}
