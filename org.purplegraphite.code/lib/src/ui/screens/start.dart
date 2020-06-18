import 'package:code/src/common/routing_const.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// The main screen displayed when the user opens app
class StartScreen extends StatelessWidget {
  const StartScreen({Key key}) : super(key: key);
  bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    final bool _isDarkMode = isDarkTheme(context);
    final Color _accentColor = _isDarkMode
        ? Color.lerp(Colors.black, Colors.white, 0.80)
        : Theme.of(context).accentColor;
    final darkOnDark = _isDarkMode ? Color(0xEE212121) : Colors.white;
    final whiteOnDark =
        _isDarkMode ? Colors.white.withOpacity(1) : Color(0xEE212121);
    final physics =
        BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
    // TODO: implement build
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: _isDarkMode
            ? Color.lerp(Colors.black, Colors.white, 0.25)
            : Theme.of(context).scaffoldBackgroundColor,
        cardColor: _isDarkMode
            ? Color.lerp(Colors.black, Colors.white, 0.30)
            : Theme.of(context).canvasColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Snake code',
            style: TextStyle(
              color: Colors.grey[200],
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: physics,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 3),
                      child: Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: whiteOnDark,
                        ),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                      ),
                      child: Text(
                        'Snake-code allows you to write code effortlessly.\n\nUpcoming: Extension support to help you rapidly work on your projects.\n\n',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: whiteOnDark),
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: _accentColor,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            'You can open a folder from your phone or select a previously folder you were working on. To create a new project, tap create button.',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: whiteOnDark),
                          ),
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Divider(),
                          OutlineButton(
                            splashColor: _accentColor.withOpacity(0.45),
                            borderSide: BorderSide(
                              width: 1.6,
                              color: _accentColor.withOpacity(0.50),
                            ),
                            highlightedBorderColor:
                                _accentColor.withOpacity(0.75),
                            child: Text(
                              'Open from phone',
                              style: TextStyle(
                                color: _accentColor,
                              ),
                            ),
                            onPressed: () => {
                              Navigator.of(context)
                                  .pushNamed(BrowserScreenRoute),
                            },
                          ),
                          OutlineButton(
                            splashColor: _accentColor.withOpacity(0.45),
                            borderSide: BorderSide(
                              width: 1.6,
                              color: _accentColor.withOpacity(0.50),
                            ),
                            highlightedBorderColor:
                                _accentColor.withOpacity(0.75),
                            child: Text(
                              'Show previous',
                              style: TextStyle(
                                color: _accentColor,
                              ),
                            ),
                            onPressed: () => {
                              Navigator.of(context).pushNamed('/FileShowcase'),
                            },
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Icon(
                                  Icons.help_outline,
                                  color: whiteOnDark,
                                ),
                                Divider(
                                  indent: 5,
                                ),
                                Text(
                                  'Help',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: whiteOnDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              print('open help');
                            },
                            title: Text(
                              'Tips & Tricks',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _accentColor,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Text(
                                'Checkout Snake code\'s usage guide',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: whiteOnDark),
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              print('open about');
                            },
                            title: Text(
                              'About',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _accentColor,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Text(
                                'Check Release notes, changelog & app information',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: whiteOnDark,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: _isDarkMode ? Color(0xff) : Color(0x00),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(EditorScreenRoute);
          },
          icon: Icon(
            EvaIcons.editOutline,
          ),
          backgroundColor: _isDarkMode ? Colors.grey[800] : null,
          label: Text(
            'Create new',
          ),
        ),
      ),
    );
  }
}
