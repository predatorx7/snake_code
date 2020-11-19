import 'package:code/src/ui/components/start_tips/tips.dart';
import 'package:code/src/ui/screens/editor/editor.dart';
import 'package:code/src/ui/screens/start/controller.dart';
import 'package:code/src/ui/screens/start/start.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Constant String screen's path address
import '../common/routing_const.dart';

// Screens
import '../../main.dart';
import '../ui/screens/browser.dart';
import '../ui/screens/settings.dart';
import '../ui/screens/terminal.dart';

// Models
import '../models/view_model/browser_controller.dart';
import '../models/view_model/terminal_controller.dart';

/// Wraps [screen] with a [PageRoute]
PageRoute<T> wrapPageRoute<T>(Widget screen,
    [bool useCupertinoPageRoute = true]) {
  if (useCupertinoPageRoute) {
    return CupertinoPageRoute<T>(builder: (context) => screen);
  }
  return MaterialPageRoute<T>(
    builder: (context) => screen,
  );
}

/// Generates Routes which will be used in the application
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case StartScreenRoute:
      return wrapPageRoute<StartScreen>(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<StartTipsController>(
              create: (context) => StartTipsController(),
            ),
            ChangeNotifierProvider<StartScreenController>(
              create: (context) => StartScreenController(),
            ),
          ],
          child: StartScreen(),
        ),
      );
    case EditorScreenRoute:
      return wrapPageRoute<EditorScreen>(EditorScreen());
    case BrowserScreenRoute:
      return wrapPageRoute<BrowserScreen>(
        ChangeNotifierProvider(
          create: (context) => BrowserController(),
          child: BrowserScreen(
            dir: settings.arguments,
          ),
        ),
      );
    case SettingsScreenRoute:
      return wrapPageRoute<SettingsScreen>(SettingsScreen());
    // case WorkspaceExplorerScreenRoute:
    //   return wrapPageRoute<WorkspaceExplorerScreen>(
    //     ChangeNotifierProvider(
    //       create: (context) => BrowserController(),
    //       child: WorkspaceExplorerScreen(),
    //     ),
    //   );
    case TerminalScreenRoute:
      return wrapPageRoute<TerminalScreen>(
        ChangeNotifierProvider(
          create: (context) => TerminalController(),
          child: TerminalScreen(),
        ),
      );
    case RootRoute:
    default:
      // TODO(mushaheedx): Reroute from Root to Start instead of replacing a widget in Root with Start
      return wrapPageRoute<Root>(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<StartTipsController>(
              create: (context) => StartTipsController(),
            ),
            ChangeNotifierProvider<StartScreenController>(
              create: (context) => StartScreenController(),
            ),
          ],
          child: Root(
            key: RootRouteKey,
          ),
        ),
      );
  }
}
