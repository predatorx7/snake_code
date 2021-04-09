import 'package:code/src/common/strings.dart';
import 'package:code/src/models/hive/repository.dart';
import 'package:code/src/models/hive/settings/themeSettings.dart';
import 'package:code/src/models/plain_model/ThemeColors.dart';
import 'package:code/src/utils/logman.dart';
import 'package:creamy_field/creamy_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';

class ThemeProvider with ChangeNotifier {
  final GlobalKey<NavigatorState> _navigatorKey;

  Repository<ThemeSettings> _themeSettingsR;

  /// Enum to store [ThemeMode] preference of user
  /// Defaults to system.
  ThemeMode _themeMode;

  int _themeChoice;

  /// List of primary [ThemeStyles] which will be used in app based on [themeChoice].
  ///
  /// NOTE: CHANGES HERE CAN BE BREAKING
  final List<ThemeStyle> _themeStyles = const <ThemeStyle>[
    ThemeStyle(Colors.deepPurple, 'Purple'),
    ThemeStyle(Colors.indigo, 'Indigo'),
    ThemeStyle(Colors.blueGrey, 'Blue Grey'),
    ThemeStyle(Colors.teal, 'Teal'),
    ThemeStyle(Colors.green, 'Green'), // Needs to be a little dark
  ];

  List<ThemeStyle> get themeStyles => _themeStyles;

  /// Current choice of [ThemeStyle]
  ThemeStyle get currentThemeStyle {
    try {
      return themeStyles[themeChoice];
    } catch (e, r) {
      logger.warning('Falling back to first theme in _themeStyles', e, r);
      return _themeStyles?.first;
    }
  }

  /// The navigator state key which will be used by this theme provider to
  /// obtain current context
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// Current light theme
  ThemeData get currentLightTheme => _theme.copyWith(
        brightness: Brightness.light,
      );

  /// Current dark theme
  ThemeData get currentDarkTheme => _theme.copyWith(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color.lerp(Colors.black, Colors.white, 0.15),
        cardColor: Color.lerp(Colors.black, Colors.white, 0.17),
        canvasColor: Color.lerp(Colors.black, Colors.white, 0.30),
      );

  /// Returns the [Brightness] used by this application
  Brightness get effectiveBrightness {
    BuildContext _context = navigatorKey.currentContext;
    return Theme.of(_context).brightness ?? Brightness.light;
  }

  bool get isDarkThemeEnabled {
    if (themeMode == ThemeMode.system)
      return effectiveBrightness == Brightness.dark;
    return (themeMode == ThemeMode.dark);
  }

  /// the monospace font family used in this app
  static const monospaceFontFamily = 'SourceCodePro';

  /// monospace text style used in the CodeEditingField
  static const TextStyle monospaceTextStyle = const TextStyle(
    fontFamily: 'SourceCodePro',
    fontWeight: FontWeight.w400,
  );

  static LanguageType fromFilePath(String filename) {
    final fileBasename = basename(filename);
    final int indexOfDot = fileBasename.lastIndexOf('.');

    final language = fileBasename.substring(indexOfDot + 1);

    if (language.isEmpty) return LanguageType.all;

    switch (language) {
      case 'py':
        return LanguageType.python;
        break;
      case 'sh':
        return LanguageType.bash;
      case 'js':
        return LanguageType.javascript;
      default:
    }

    for (var languageType in LanguageType.values) {
      final String typeName = describeEnum(languageType);
      if (language == typeName) {
        return languageType;
      }
    }
    // TODO: handle exceptions
    return LanguageType.all;
  }

  CreamySyntaxHighlighter createSyntaxHighlighter(String filename) {
    return CreamySyntaxHighlighter(
      language: fromFilePath(filename),
      theme: HighlightedThemeType.vsTheme,
      themeMode: isDarkThemeEnabled ? ThemeMode.light : ThemeMode.dark,
    );
  }

  /// User's choice of theme. defaults to 0. Updated later with User's preference.
  int get themeChoice => _themeChoice ?? 0;

  /// Enum to store [ThemeMode] preference of user
  /// Defaults to system.
  ThemeMode get themeMode => _themeMode ?? ThemeMode.system;

  ThemeProvider({GlobalKey<NavigatorState> navigatorKey})
      : this._navigatorKey = navigatorKey {
    _setup();
  }

  /// Sets up & Initializes preferences.
  Future _setup() async {
    _themeSettingsR = await Repository.get<ThemeSettings>(
        StorageBoxNames.THEME_SETTINGS, ThemeSettingsAdapter());
    if (_themeSettingsR.isRepositoryEmpty) {
      print("Creating theme settings for the first time");
      await _themeSettingsR.box.add(ThemeSettings.manual(0, ThemeMode.system));
    }
    _themeChoice = _themeSettingsR.first.themeChoice;
    _themeMode = _themeSettingsR.first.themeMode;
    print('ThemeChoice: $_themeChoice, ThemeMode: $_themeMode');
    notifyListeners();
    // _themeSettingsR.listenStream(_onThemeChange); // No current use
  }

  /// Called when theme is changed.
  // void _onThemeChange(BoxEvent onData) {
  //   print("d: ${onData.deleted} k: ${onData.key} v: ${onData.value}");
  //   // notifyListeners();
  // }

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
    if (themeChoice > themeStyles.length || themeChoice < 0) return;
    ThemeSettings settings = _themeSettingsR.first;
    settings.themeChoice = themeChoice;
    await settings.save();
    _themeChoice = themeChoice;
    notifyListeners();
  }

  // Creates ThemeData based on themeChoice
  ThemeData get _theme {
    return ThemeData(
      splashFactory: InkRipple.splashFactory,
      primarySwatch: currentThemeStyle.color,
      textTheme: TextTheme(
        headline1: GoogleFonts.openSans(
            fontSize: 95, fontWeight: FontWeight.w300, letterSpacing: -1.5),
        headline2: GoogleFonts.openSans(
            fontSize: 59, fontWeight: FontWeight.w300, letterSpacing: -0.5),
        headline3:
            GoogleFonts.openSans(fontSize: 48, fontWeight: FontWeight.w400),
        headline4: GoogleFonts.openSans(
            fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        headline5:
            GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.w400),
        headline6: GoogleFonts.openSans(
            fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
        subtitle1: GoogleFonts.openSans(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
        subtitle2: GoogleFonts.openSans(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        bodyText1: GoogleFonts.quicksand(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyText2: GoogleFonts.quicksand(
            fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        button: GoogleFonts.quicksand(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        caption: GoogleFonts.quicksand(
            fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        overline: GoogleFonts.quicksand(
            fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      ),
    );
  }
}
