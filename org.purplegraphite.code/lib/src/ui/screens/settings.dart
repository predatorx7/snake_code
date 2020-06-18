import 'package:code/src/models/plain_model/ThemeColors.dart';
import 'package:code/src/models/provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  String _toUppercaseFirstChar(String from) {
    return '${from[0].toUpperCase()}${from.substring(1)}';
  }

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
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return ListView(
            controller: _scrollController,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Theme preferences',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey[800],
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  'Theme mode',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey[800],
                    fontWeight: FontWeight.w700,
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
                        _toUppercaseFirstChar(value.toString().substring(10)),
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (_) {
                    themeProvider.setThemeMode(_);
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  'Color',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey[800],
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<ThemeStyle>(
                  value: themeProvider.currentThemeStyle,
                  items: themeProvider.themeStyles.map((ThemeStyle style) {
                    return new DropdownMenuItem<ThemeStyle>(
                      value: style,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Container(
                            decoration: BoxDecoration(
                              color: style.color,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            height: 30,
                            width: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(style.name),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (_) {
                    final selectedStyle = themeProvider.themeStyles.indexOf(_);
                    themeProvider.setThemeChoice(selectedStyle);
                  },
                ),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
