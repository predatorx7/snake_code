import 'package:flutter/material.dart' show ValueKey;

const String StartScreenRoute = '/start';

/// Update settings with `Provider.of<EditorController>(context, listen: false).updateSettings`
/// before pushing this route
const String EditorScreenRoute = '/editor';
const String WorkspaceExplorerScreenRoute =
    '$EditorScreenRoute/workspace_explorer';
const String BrowserScreenRoute = '/browser';
const String HistoryScreenRoute = '/history';
const String TerminalScreenRoute = '$EditorScreenRoute/terminal';
const String SettingsScreenRoute = '/settings';
const String RootRoute = '/';

// Here, the value of this key below is compared when widgets are refreshed. If the value matches
// with an existing key in the widget tree, then the widget updates instead of remounting.
const ValueKey<String> RootRouteKey = const ValueKey<String>('rootScreen');
