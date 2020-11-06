import 'package:flutter/material.dart';

/// Is the current theme brighness is dark?
bool isDarkTheme(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}
