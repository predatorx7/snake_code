import 'package:flutter/material.dart' show MaterialColor;

class ThemeStyle {
  /// Primary MaterialColor of this theme
  final MaterialColor color;

  /// Theme name, unique to every theme
  final String name;

  const ThemeStyle(this.color, this.name);

  @override
  String toString() => name;
  @override
  int get hashCode => name.hashCode + color.hashCode;
}
