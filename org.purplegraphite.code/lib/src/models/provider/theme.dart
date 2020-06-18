import 'package:code/src/models/hive/repository.dart';
import 'package:code/src/models/hive/settings/themeSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  final GlobalKey<NavigatorState> _navigatorKey;

  Repository<ThemeSettings> _themeSettingsR;

  /// [this] internally changes _currentTheme
  ThemeData _currentLightTheme;

  /// [this] internally changes _currentDarkTheme
  ThemeData _currentDarkTheme;

  /// Enum to store [ThemeMode] preference of user
  /// Defaults to system.
  ThemeMode _themeMode;

  int _themeChoice;

  /// List of primary [MaterialColors] which will be used in app based on [themeChoice]
  final List<MaterialColor> _primaryThemeMaterialColors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.grey
  ];

  /// The navigator state key which will be used by this theme provider to
  /// obtain current context
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// Current light theme
  ThemeData get currentLightTheme => _currentLightTheme;

  /// Current dark theme
  ThemeData get currentDarkTheme => _currentDarkTheme;

  /// Returns the [Brightness] used by this application
  Brightness get effectiveBrightness {
    BuildContext _context = navigatorKey.currentContext;
    return Theme.of(_context).brightness ?? Brightness.light;
  }

  bool get isDarkThemeEnabled => effectiveBrightness == Brightness.dark;

  /// the monospace font family used in this app
  static const monospaceFontFamily = 'SourceCodePro';

  /// monospace text style used in the CodeEditingField
  static const TextStyle monospaceTextStyle = const TextStyle(
    fontFamily: 'SourceCodePro',
    fontWeight: FontWeight.w400,
  );

  /// User's choice of theme. defaults to 0. Updated later with User's preference.
  int get themeChoice => _themeChoice ?? 0;

  /// Enum to store [ThemeMode] preference of user
  /// Defaults to system.
  ThemeMode get themeMode => _themeMode ?? ThemeMode.system;

  ThemeProvider(GlobalKey<NavigatorState> navigatorKey)
      : this._navigatorKey = navigatorKey {
    _setup();
  }

  Future _setup() async {
    _themeSettingsR = await Repository.create<ThemeSettings>(
        'themeSettings', ThemeSettingsAdapter());
    if (_themeSettingsR.isRepositoryEmpty) {
      print("Creating theme settings for the first time");
      _themeSettingsR.box.add(ThemeSettings.manual(0, ThemeMode.system));
    }
    _themeChoice = _themeSettingsR.first.themeChoice;
    _themeMode = _themeSettingsR.first.themeMode;
    _updateTheme();
    _themeSettingsR.listenStream(_onThemeChange);
  }

  void _onThemeChange(BoxEvent onData) {
    print("d: ${onData.deleted} k: ${onData.key} v: ${onData.value}");
  }

  /// Set App's ThemeMode to dark, light or system
  void setThemeMode(ThemeMode themeMode) async {
    ThemeSettings settings = _themeSettingsR.first;
    settings.themeMode = themeMode;
    await settings.save();
    _themeMode = themeMode;
    notifyListeners();
  }

  /// Set theme choice
  void setThemeChoice(int themeChoice) async {
    if (themeChoice > _primaryThemeMaterialColors.length || themeChoice < 0)
      return;
    ThemeSettings settings = _themeSettingsR.first;
    settings.themeChoice = themeChoice;
    await settings.save();
    _themeChoice = themeChoice;
    notifyListeners();
  }

  /// Updates theme
  void _updateTheme() async {
    _currentLightTheme = _theme.copyWith(
      brightness: Brightness.light,
    );
    _currentDarkTheme = _theme.copyWith(
      brightness: Brightness.dark,
    );
    notifyListeners();
  }

  // Creates ThemeData based on themeChoice
  ThemeData get _theme {
    return ThemeData(
      splashFactory: InkRipple.splashFactory,
      primarySwatch: _primaryThemeMaterialColors[themeChoice],
    );
  }
}
