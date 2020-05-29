import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final GlobalKey<NavigatorState> _navigatorKey;

  /// The navigator state key which will be used by this theme provider to
  /// obtain current context
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// the monospace font family used in this app
  static const monospaceFontFamily = 'SourceCodePro';

  /// monospace text style used in the CodeEditingField
  static const TextStyle monospaceTextStyle = const TextStyle(
    fontFamily: 'SourceCodePro',
    fontWeight: FontWeight.w400,
  );

  /// [this] internally changes _currentTheme
  ThemeData _currentLightTheme;

  /// [this] internally changes _currentDarkTheme
  ThemeData _currentDarkTheme;

  /// Enum to store [ThemeMode] preference of user
  /// Defaults to system.
  ThemeMode _themeMode = ThemeMode.system;

  /// Enum to store [ThemeMode] preference of user
  /// Defaults to system.
  ThemeMode get themeMode {
    return _themeMode;
  }

  /// Current light theme
  ThemeData get currentLightTheme => _currentLightTheme;

  /// Current dark theme
  ThemeData get currentDarkTheme => _currentDarkTheme;

  Brightness get effectiveBrightness {
    BuildContext _context = navigatorKey.currentContext;
    return Theme.of(_context).brightness ?? Brightness.light;
  }

  /// List of primary [MaterialColors] which will be used in app based on [themeChoice]
  final List<MaterialColor> primaryColors = [Colors.deepPurple];

  int _themeChoice = 0;

  /// User's choice of theme. defaults to 0. Updated later with User's preference.
  int get themeChoice => _themeChoice;

  /// Set theme choice
  void setThemeChoice(int themeChoice) {
    _themeChoice = themeChoice;
    notifyListeners();
  }

  ThemeProvider(GlobalKey<NavigatorState> navigatorKey)
      : this._navigatorKey = navigatorKey {
    updateTheme();
    updateThemeMode();
  }

  /// Set App's ThemeMode to dark, light or system
  void setThemeMode(ThemeMode themeMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String value;
    _themeMode = themeMode ?? ThemeMode.system;
    switch (themeMode) {
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.system:
        value = 'system';
        break;
    }
    await prefs.setString('ThemeMode', value ?? 'system');
  }

  // Gets ThemeMode
  Future<ThemeMode> updateThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String userBrightness = prefs.getString('ThemeMode') ?? 'system';
    switch (userBrightness) {
      case 'system':
        _themeMode = ThemeMode.system;
        break;
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
    }
    notifyListeners();
    return _themeMode;
  }

  /// Updates theme
  void updateTheme() async {
    _currentLightTheme = getTheme().copyWith(
      brightness: Brightness.light,
    );
    _currentDarkTheme = getTheme().copyWith(
      brightness: Brightness.dark,
    );
    notifyListeners();
  }

  // Creates ThemeData based on themeChoice
  ThemeData getTheme() {
    return ThemeData(
      splashFactory: InkRipple.splashFactory,
      primarySwatch: primaryColors[themeChoice],
    );
  }
}
