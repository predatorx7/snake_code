import 'dart:io';

import 'package:code/src/common/routing_const.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class ColoredListTile extends StatelessWidget {
  final bool isDark;
  final MaterialColor color;
  final void Function() onPressed;
  final Widget title;
  final Widget leading;

  const ColoredListTile(
      this.isDark, this.color, this.onPressed, this.title, this.leading,
      {Key key})
      : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      color: isDark ? color[700] : color[500],
      child: OutlineButton(
        padding: EdgeInsets.zero,
        borderSide: BorderSide.none,
        splashColor: color[600],
        onPressed: onPressed,
        child: ListTile(
          title: title,
          leading: IconTheme(
            data: Theme.of(context)
                .iconTheme
                .copyWith(color: isDark ? Colors.white : Colors.black),
            child: leading,
          ),
        ),
      ),
    );
  }
}

class EditorDrawer extends StatelessWidget {
  final Directory folder;

  const EditorDrawer({Key key, this.folder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    bool isDark = _theme.brightness == Brightness.dark;
    Color objectColor = isDark ? Colors.white : Colors.black;
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: isDark ? Colors.black87 : null,
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: objectColor,
            ),
        textTheme: Theme.of(context).textTheme.copyWith(
              bodyText1: TextStyle(color: objectColor),
            ),
      ),
      child: Drawer(
        child: ListView(
          children: <Widget>[
            // ListTile(
            //   title: const Text("Finder"),
            //   leading: Icon(Icons.find_in_page),
            // ),
            Tooltip(
              message: 'Browse workspace',
              child: ListTile(
                title: const Text("Explorer"),
                leading: Icon(
                  FluentIcons.compass_northwest_20_regular,
                ),
                onTap: () async {
                  await Navigator.of(context).pushNamed(
                    WorkspaceExplorerScreenRoute,
                    arguments: folder,
                  );
                  await Navigator.of(context).pop();
                },
              ),
            ),
            // ListTile(
            //   title: const Text("Search"),
            //   leading: Icon(
            //     FluentIcons.search_20_regular,
            //   ),
            // ),
            // ListTile(
            //   title: const Text("Source control"),
            //   leading: Icon(Icons.timeline),
            // ),
            // ListTile(
            //   title: const Text("Run"),
            //   leading: Icon(
            //     FluentIcons.arrow_right_circle_24_regular,
            //   ),
            // ),
            ListTile(
              title: const Text("Terminal"),
              leading: Icon(
                FluentIcons.code_20_regular,
              ),
              onTap: () {
                Navigator.pushNamed(context, TerminalScreenRoute);
              },
            ),
            ColoredListTile(
              isDark,
              Colors.grey,
              () {
                Navigator.of(context).popAndPushNamed(SettingsScreenRoute);
              },
              const Text("Settings"),
              Icon(
                FluentIcons.settings_20_regular,
              ),
            ),
            ColoredListTile(
              isDark,
              Colors.red,
              () {
                Navigator.of(context).pushReplacementNamed(StartScreenRoute);
              },
              const Text("Close"),
              Icon(
                FluentIcons.dismiss_circle_20_regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
