import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../common/routing_const.dart';
import '../../models/plain_model/entity.dart';
import '../../models/view_model/browser_controller.dart';
import '../../utils/fileutils.dart';
import '../components/newfolder_dialog.dart';

/// Local files & directories browser
class BrowserScreen extends StatefulWidget {
  /// THe directory whose content will be shown in this widget.
  final Directory dir;
  /// THe browser widget which shows files and directories of [dir] directory.
  const BrowserScreen({Key key, this.dir}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foregroundInDarkness = isDark ? Colors.white : Colors.black;
    Widget _selectFolderButton = Tooltip(
      message: 'Select this folder',
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
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          EditorScreenRoute, (Route<dynamic> route) => false,
                          arguments: widget.dir);
                    },
              borderSide: BorderSide(
                width: 1.6,
                color: Color.lerp(
                    Theme.of(context).accentColor, Colors.white, 0.3),
              ),
              highlightedBorderColor:
                  Color.lerp(Theme.of(context).accentColor, Colors.white, 0.5),
              disabledTextColor:
                  Color.lerp(Theme.of(context).accentColor, Colors.white, 0.3),
              textColor: Colors.white,
              // child: Text('Select'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(EvaIcons.checkmarkOutline),
                  Text(' OK '),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(path.basename(widget.dir?.path ?? '')),
        actions: <Widget>[_selectFolderButton],
      ),
      body: Visibility(
        visible: _view.currentEntities?.isNotEmpty ?? false,
        child: ListView.builder(
          key: ValueKey(_view.current.path),
          itemCount: _view.currentEntities.length,
          itemBuilder: (context, index) {
            final object = _view.currentEntities[index];
            Widget child = ListTile(
              key: ValueKey(object.id),
              onTap: () {
                if (object.entity is Directory) {
                  /// If the tapped tile is a directory, open it in a new
                  /// browser screen route
                  var x = Directory.fromUri(
                    Uri(path: object.absolutePath),
                  );
                  Navigator.pushNamed(context, BrowserScreenRoute,
                      arguments: x);
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
                visible:
                    _view.recentlyCreatedFolder.contains(object.absolutePath),
                child: Icon(
                  Icons.fiber_new,
                  color: Colors.red,
                  size: 28,
                ),
              ),
            );
            if (_view.recentlyCreatedFolder.contains(object.absolutePath)) {
              child = Container(
                color: Theme.of(context).primaryColor.withAlpha(0x22),
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
              final _itemColor = Theme.of(context).accentColor.withAlpha(0xCC);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          newFolderDialog(context, (textController) {
            _view.createFolderAndAddToRecent(context, textController.text);
          });
        },
        heroTag: _createNewHero,
        icon: Icon(
          EvaIcons.folderAddOutline,
        ),
        label: Text('Create folder'),
      ),
    );
  }
}
