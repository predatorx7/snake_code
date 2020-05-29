import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: const Color(0xff1f655d),
    accentColor: const Color(0xff40bf7a),
    textTheme: const TextTheme(
      title: const TextStyle(color: Color(0xff40bf7a)),
      subtitle: const TextStyle(color: Colors.white),
      subhead: const TextStyle(
        color: const Color(0xff40bf7a),
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: const Color(0xff1f655d),
    ),
  );

  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: const Color(0xfff5f5f5),
    accentColor: const Color(0xff40bf7a),
    textTheme: const TextTheme(
        title: const TextStyle(color: Colors.black54),
        subtitle: const TextStyle(color: Colors.grey),
        subhead: const TextStyle(color: Colors.white)),
    appBarTheme: const AppBarTheme(
      color: const Color(0xff1f655d),
      actionsIconTheme: const IconThemeData(color: Colors.white),
    ),
  );
}
