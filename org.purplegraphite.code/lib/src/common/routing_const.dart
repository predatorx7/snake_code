import 'package:flutter/material.dart' show ValueKey;

const String StartScreenRoute = '/start';
const String EditorScreenRoute = '/editor';
const String BrowserScreenRoute = '/browser';
const String TerminalScreenRoute = '/terminal';
const String SettingsScreenRoute = '/settings';
const String RootRoute = '/';

// Here, the value of this key below is compared when widgets are refreshed. If the value matches
// with an existing key in the widget tree, then the widget updates instead of remounting.
const ValueKey<String> RootRouteKey = const ValueKey<String>('rootScreen');
