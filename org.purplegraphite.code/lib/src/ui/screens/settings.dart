import 'package:code/src/models/provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final List<Widget> _settingsChildren = <Widget>[];
  @override
  Widget build(BuildContext context) {
    // theme settings

    // editor settings
    // advanced general settings
    // console settings
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.grey[200],
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
        // Adding theme settings
        final Iterable<Widget> themeSettingsListTiles = ListTile.divideTiles(
          context: context,
          tiles: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Theme preferences',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<ThemeMode>(
                value: themeProvider.themeMode,
                items: ThemeMode.values.map((ThemeMode value) {
                  return new DropdownMenuItem<ThemeMode>(
                    value: value,
                    child: new Text(
                      value.toString().substring(10),
                    ),
                  );
                }).toList(),
                onChanged: (_) {
                  themeProvider.setThemeMode(_);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<MaterialColor>(
                value: themeProvider.themeColors[themeProvider.themeChoice],
                items: themeProvider.themeColors.map((MaterialColor value) {
                  return new DropdownMenuItem<MaterialColor>(
                    value: value,
                    child: new Text(
                      value.toString(),
                    ),
                  );
                }).toList(),
                onChanged: (_) {
                  final selectedColor = themeProvider.themeColors.indexOf(_);
                  themeProvider.setThemeChoice(selectedColor);
                },
              ),
            ),
          ],
        );
        _settingsChildren.addAll(themeSettingsListTiles);
        return ListView(
          controller: _scrollController,
          children: _settingsChildren,
        );
      }),
    );
  }
}
