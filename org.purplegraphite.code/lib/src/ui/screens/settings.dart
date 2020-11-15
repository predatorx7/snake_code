import 'package:code/src/models/plain_model/ThemeColors.dart';
import 'package:code/src/models/provider/theme.dart';
import 'package:code/src/utils/theme.dart';
import 'package:flutter/foundation.dart';
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
          final _isDarkTheme = isDarkTheme(context);
          final _textColorOnBackground =
              _isDarkTheme ? Colors.white : Colors.black;
          final _labelColorOnBackground =
              _isDarkTheme ? Colors.white : Colors.grey[800];
          return ListView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Theme preferences',
                  style: TextStyle(
                    color: _labelColorOnBackground,
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
                    color: _labelColorOnBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: DropdownButton<ThemeMode>(
                  value: themeProvider.themeMode,
                  icon: Icon(Icons.arrow_drop_down_circle),
                  underline: SizedBox(),
                  items: ThemeMode.values.map((ThemeMode value) {
                    Color _themeColor;
                    switch (value) {
                      case ThemeMode.system:
                        _themeColor = Colors.grey;
                        break;
                      case ThemeMode.light:
                        _themeColor = Colors.white;
                        break;
                      case ThemeMode.dark:
                        _themeColor = Colors.black;
                        break;
                    }
                    return new DropdownMenuItem<ThemeMode>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            new Container(
                              decoration: BoxDecoration(
                                color: _themeColor,
                                border: Border.all(
                                    color: _labelColorOnBackground, width: 2),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              height: 30,
                              width: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: new Text(
                                _toUppercaseFirstChar(describeEnum(value)),
                                style: TextStyle(
                                  color: _textColorOnBackground,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
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
                    color: _labelColorOnBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: DropdownButton<ThemeStyle>(
                  value: themeProvider.currentThemeStyle,
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down_circle),
                  items: themeProvider.themeStyles.map((ThemeStyle style) {
                    final _decoration = BoxDecoration(
                      color: style.color,
                      border:
                          Border.all(color: _labelColorOnBackground, width: 2),
                      borderRadius: BorderRadius.circular(25),
                    );
                    return new DropdownMenuItem<ThemeStyle>(
                      value: style,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Container(
                              decoration: _decoration,
                              height: 30,
                              width: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                style.name,
                                style: TextStyle(
                                  color: _textColorOnBackground,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
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
