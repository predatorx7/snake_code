import 'package:code/src/common/routing_const.dart';
import 'package:code/src/models/provider/history.dart';
import 'package:code/src/ui/screens/editor/controller.dart';
import 'package:code/src/utils/theme.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<RecentHistoryProvider>(context);
    final _histories = _provider.getHistories();

    final _isDarkMode = isDarkTheme(context);
    final _theme = Theme.of(context);

    final backgroundInDark = _isDarkMode ? Colors.black : Colors.white;

    final popupIconButtonColor = Color.lerp(_theme.accentColor,
        _isDarkMode ? Colors.white : Colors.black, _isDarkMode ? 0.10 : 0.25);
    final foregroundColorOnDarkBackground =
        _isDarkMode ? Colors.white.withOpacity(1) : Color(0xEE212121);

    final physics =
        BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView.builder(
        itemCount: _histories?.length == 0 ? 1 : _histories.length,
        physics: physics,
        itemBuilder: (context, index) {
          if (_histories?.isEmpty ?? true) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Text(
                  'You have no work history',
                  style: TextStyle(
                    color: foregroundColorOnDarkBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final _history = _histories[index];
          return ListTile(
            title: Text(
              _history.workspacePath,
              style: TextStyle(
                color: foregroundColorOnDarkBackground,
              ),
              textAlign: TextAlign.center,
            ),
            onTap: () {
              final settings =
                  EditorSettings.fromDirectory(_history.workspacePath);
              Provider.of<EditorController>(context, listen: false)
                  .updateSettings(settings);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  EditorScreenRoute, (Route<dynamic> route) => false);
            },
            // Add a fuzzy timestamp
            // trailing: Text(_history.lastModified.),
          );
        },
      ),
    );
  }
}
