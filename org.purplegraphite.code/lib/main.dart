import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/common/routes.dart';
import 'src/models/provider/theme.dart';
import 'src/ui/screens/start.dart';
import 'src/utils/permissions.dart';

void main() async {
  runApp(App());
}

/// Starting point for our app
class App extends StatelessWidget {
  // Usually, without keys widgets unmounts and then mounts again and rebuilds. 
  // This behaviour may creates performance issues.
  // Thus, using keys below may cause widgets to update instead of remounting.
  // Using keys isn't neccessary as Flutter is fast but we don't want to remount
  // heavy widgets hence the usage
  final _appKey = GlobalKey();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    // The [MultiProvider] builds providers which instances of object throughout
    // the widget tree with a search complexity of O(1)
    return MultiProvider(
      providers: [
        // Provides instance of class initiated at the create parameter
        ChangeNotifierProvider<ThemeProvider>(
          // Provides theme to the descendant widgets. 
          // Use Provider.of<ThemeProvider>(context) to get it's instance.
          create: (_) => ThemeProvider(
            navigatorKey: _navigatorKey,
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, th, child) {
          return MaterialApp(
            key: _appKey,

            /// Will be used to catch intents, and to hanle Routes 
            /// without context
            navigatorKey: _navigatorKey,
            title: 'Snake editor',
            theme: th.currentLightTheme,
            darkTheme: th.currentDarkTheme,
            themeMode: th.themeMode,
            // Don't need to explicitly specify home as [generateRoute] does it.
            onGenerateRoute: generateRoute,
          );
        },
      ),
    );
  }
}

/// The main root widget route which will ask permissions and show notifications
/// on load
class Root extends StatefulWidget {
  /// This root will show notifications and check storage access permissions.
  /// If the permissions have been aapproved, bg widget will replace itself 
  /// with [StartScreen]
  const Root({Key key}) : super(key: key);
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final ValueKey<String> _mainKey = const ValueKey<String>('mainScreen');
  bool perms = false;

  /// Ask permissions & then change [perms] to true
  Future<void> _requestPermissions() async {
    // Show dialog here before requesting permissions.
    await Perms.askOnce();
    setState(() {
      perms = true;
    });
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestPermissions());
  }

  @override
  Widget build(BuildContext context) {
    Widget start = StartScreen(
      key: _mainKey,
    );

    // TODO(predatorx7): Show a dialog to describe why you need permissions.
    return Visibility(
      visible: perms,
      child: start,
      // Shows this widget until [perms] is true
      replacement: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
