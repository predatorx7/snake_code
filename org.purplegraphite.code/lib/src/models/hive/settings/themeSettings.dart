import 'package:flutter/material.dart' show ThemeMode;
import 'package:hive/hive.dart';

part 'themeSettings.g.dart';

/// Hive Model which has application theme related information
@HiveType(typeId: 2)
class ThemeSettings extends HiveObject {
  /// User's choice of theme. defaults to 0. Updated later with User's preference.
  @HiveField(1)
  int themeChoice;

  /// String representation of [ThemeMode].
  @HiveField(2)
  String themeModeS;

  /// Returns ThemeMode.
  ThemeMode get themeMode {
    return _from(themeModeS);
  }

  /// Set Application ThemeMode.
  void set themeMode(ThemeMode themeMode) {
    themeModeS = themeMode.toString();
  }

  /// TO BE USED WITH GENERATOR. Use [ThemeSettings.manual] instead.
  ThemeSettings(this.themeChoice, this.themeModeS);

  ThemeSettings.manual(this.themeChoice, ThemeMode mode) {
    themeMode = mode;
  }

  ThemeMode _from(String mode) {
    switch (mode) {
      case "ThemeMode.system":
        return ThemeMode.system;
      case "ThemeMode.light":
        return ThemeMode.light;
      case "ThemeMode.dark":
        return ThemeMode.dark;
      default:
        throw Exception();
    }
  }
}
