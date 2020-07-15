import 'package:code/src/models/view_model/editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionsTabButton extends StatelessWidget {
  /// Return proper tab button label based on number of tabs open
  static String changeLabel(Iterable tabsOpen) {
    if (tabsOpen?.isEmpty ?? true) {
      return '0';
    } else if (tabsOpen.length > 99) {
      return ':P';
    } else {
      return tabsOpen.length.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final EditorController editorController =
        Provider.of<EditorController>(context);
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    Color appbarAccent = isDark ? Colors.amber : Colors.white;
    final tabs = editorController.tabs;
    String label = changeLabel(tabs);
    return Tooltip(
      message: 'change tabs',
      child: IconButton(
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
        icon: Center(
          child: Container(
            padding: const EdgeInsets.all(2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6), // To match with chrome
              // borderRadius: BorderRadius.circular(25), // Original
              border: Border.all(
                  width: 2, color: isDark ? appbarAccent : Colors.white),
            ),
            constraints: BoxConstraints.tight(const Size(25.0, 25.0)),
            child: Text(
              '$label',
              style: TextStyle(
                color: appbarAccent,
                fontWeight: isDark ? FontWeight.w800 : FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
