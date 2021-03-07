import 'dart:io';

import 'package:code/src/common/routing_const.dart';
import 'package:code/src/models/plain_model/entity.dart';
import 'package:code/src/models/view_model/browser_controller.dart';
import 'package:code/src/ui/components/newfolder_dialog.dart';
import 'package:code/src/utils/fileutils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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
class BrowserScreen extends StatefulWidget {
  /// THe directory whose content will be shown in this widget.
  final Directory dir;

  final String title;

  /// THe browser widget which shows files and directories of [dir] directory.
  const BrowserScreen({Key key, @required this.dir, this.title})
      : super(key: key);
  @override
  _BrowserScreenState createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  BrowserController _view;
  final String _createNewHero = 'createNewHero';
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
        data = FluentIcons.folder_20_regular;
        color = isDark
            ? Color.lerp(Theme.of(context).accentColor, Colors.white, 0.25)
            : Theme.of(context).accentColor;
        break;
      case FileSystemEntityType.file:
        data = isHidden
            ? FluentIcons.folder_20_regular
            : FluentIcons.document_24_filled;
        color = isDark ? Colors.white : Colors.grey;
        break;
      default:
        data = FluentIcons.error_circle_20_regular;
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

    Widget _selectFolderButton = Tooltip(
      message: _tooltipMessage,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 150,
            ),
            child: OutlineButton(
              onPressed: widget?.dir == null
                  ? null
                  : () {
                      // TODO(mushaheedx): Ask with a dialog before opening editor with a don't ask again tick box.

                      EditorSettings _settings;

                      if (_isAFileSelected()) {
                        _settings = EditorSettings.fromFile(_idOfSelectedFile);
                      } else {
                        _settings = EditorSettings.fromDirectory(widget.dir.absolute.path);
                      }

                      Provider.of<EditorController>(context, listen: false)
                          .updateSettings(_settings);

                      Navigator.of(context).pushNamedAndRemoveUntil(
                          EditorScreenRoute, (Route<dynamic> route) => false);
                    },
              borderSide: BorderSide(
                width: 1.6,
                color: _whiterAccentColor,
              ),
              highlightedBorderColor:
                  Color.lerp(_theme.accentColor, Colors.white, 0.5),
              disabledTextColor: _whiterAccentColor,
              textColor: Colors.white,
              // child: Text('Select'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(FluentIcons.checkmark_20_regular),
                  Text(' OK '),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final String _title =
        widget?.title ?? path.basename(widget.dir?.path ?? '');
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[_selectFolderButton],
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
                  _toggleSelection(object.id);
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
                    FluentIcons.info_20_regular,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          newFolderDialog(context, (textController) {
            _view.createFolderAndAddToRecent(context, textController.text);
          });
        },
        heroTag: _createNewHero,
        icon: Icon(
          FluentIcons.folder_add_20_regular,
        ),
        label: Text('Create folder'),
      ),
    );
  }
}
