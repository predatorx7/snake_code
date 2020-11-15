import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/routing_const.dart';
import '../../../utils/theme.dart';
import '../../components/buttons/popup_menu.dart';
import '../../components/popup_menu_tile.dart';

final _borderRadius = BorderRadius.circular(10);

final _startShapeBorder = RoundedRectangleBorder(
  borderRadius: _borderRadius,
);

/// The main screen displayed when the user opens app
class StartScreen extends StatelessWidget {
  /// The start screen displayed when the app is launched.
  /// Shows recent projects, an option to browser files in device, and tips.
  const StartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isDarkMode = isDarkTheme(context);
    final _theme = Theme.of(context);

    final backgroundInDark = _isDarkMode ? Colors.black : Colors.white;

    final popupIconButtonColor = Color.lerp(_theme.accentColor,
        _isDarkMode ? Colors.white : Colors.black, _isDarkMode ? 0.10 : 0.25);
    final foregroundColorOnDarkBackground =
        _isDarkMode ? Colors.white.withOpacity(1) : Color(0xEE212121);

    final physics =
        BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Snake code',
          style: GoogleFonts.openSans(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: _isDarkMode ? Colors.black : Colors.white,
            letterSpacing: 0.15,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomPopupMenuButton<dynamic>(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                ),
              ),
              color: _isDarkMode ? Colors.grey[850] : null,
              iconColor: popupIconButtonColor,
              padding: const EdgeInsets.all(10),
              icon: Icon(
                EvaIcons.moreHorizotnalOutline,
                color: backgroundInDark,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'open settings':
                    Navigator.of(context).pushNamed(SettingsScreenRoute);
                    break;
                  default:
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<dynamic>>[
                PopupMenuTile(
                  value: 'open settings',
                  leading: Icons.settings_outlined,
                  color: foregroundColorOnDarkBackground,
                  title: Text(
                    'Settings',
                    style: TextStyle(color: foregroundColorOnDarkBackground),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(SettingsScreenRoute);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        physics: physics,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Text(
              'Welcome',
              style: _theme.textTheme.headline5.copyWith(
                color: foregroundColorOnDarkBackground,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16),
            child: Text(
              'Modify source-code on effortlessly.\n\nFiles are good for writing code snippets, general programs & short scripts. Opening a directory as a project will allow working with multiple files.',
              style: _theme.textTheme.subtitle1.copyWith(
                color: foregroundColorOnDarkBackground,
              ),
            ),
          ),
          StartCard(
            title: 'Open from',
            description:
                'Open a file or directory from the in-built browser or import from other app.',
            buttons: [
              StartCardButton(
                onPressed: () {},
                iconData: EvaIcons.folderOutline,
                label: 'Browse',
                keepDark: !_isDarkMode,
              ),
              StartCardButton(
                onPressed: () async {
                  final String result =
                      await FilePicker.platform.getDirectoryPath();
                  print('PATH: $result');
                },
                iconData: EvaIcons.download,
                label: 'Import',
                keepDark: _isDarkMode,
                beGrey: true,
              ),
            ],
          ),
          StartCard(
            title: 'Start fresh',
            description: 'Create a new file or project.',
            buttons: [
              StartCardButton(
                iconData: EvaIcons.folderAddOutline,
                label: 'New project',
                onPressed: () {},
                keepDark: _isDarkMode,
                keepOutlines: true,
              ),
              StartCardButton(
                onPressed: () {},
                iconData: EvaIcons.fileAddOutline,
                label: 'New file',
                keepDark: !_isDarkMode,
                keepOutlines: true,
              ),
            ],
          ),
          StartCard(
            title: 'Recent',
            description:
                'Open from a project or file you\'ve been working on previously',
            more: ListView.builder(
              shrinkWrap: true,
              itemCount: 0,
              itemBuilder: (context, index) {
                return SizedBox();
              },
            ),
            buttons: [
              StartCardButton(
                iconData: Icons.access_time,
                label: 'Previous',
                onPressed: () {},
                keepDark: !_isDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StartCardButton extends StatelessWidget {
  final bool keepDark;
  final bool beGrey;
  final bool keepOutlines;
  final String label;
  final IconData iconData;
  final void Function() onPressed;

  const StartCardButton({
    Key key,
    this.keepDark = false,
    this.label = '',
    this.iconData,
    this.onPressed,
    this.beGrey = false,
    this.keepOutlines = false,
  }) : super(key: key);

  Color _backgroundColor(BuildContext context) {
    if (beGrey) return Colors.grey[800];
    return Theme.of(context).accentColor;
  }

  @override
  Widget build(BuildContext context) {
    final foregroundColor = keepDark ? Colors.white : Colors.black;
    final backgroundColor = keepDark ? _backgroundColor(context) : Colors.white;

    final Widget button = FlatButton.icon(
      color: backgroundColor,
      onPressed: onPressed,
      icon: iconData == null
          ? null
          : Icon(
              iconData,
              color: foregroundColor,
            ),
      textColor: foregroundColor,
      shape: (keepOutlines & !keepDark)
          ? _startShapeBorder.copyWith(
              side: BorderSide(color: _backgroundColor(context)),
            )
          : _startShapeBorder,
      padding: EdgeInsets.all(12),
      label: Text(label),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 6.0,
      ),
      child: button,
    );
  }
}

class StartCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget more;
  final List<Widget> buttons;

  const StartCard(
      {Key key, this.title, this.description, this.buttons, this.more})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final foregroundColorOnDarkBackground =
        _isDark ? Colors.white.withOpacity(1) : Color(0xEE212121);
    return Card(
      shape: _startShapeBorder,
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: _theme.textTheme.headline6.copyWith(
                  color: foregroundColorOnDarkBackground,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                description,
                style: _theme.textTheme.subtitle2.copyWith(
                  color: foregroundColorOnDarkBackground,
                ),
              ),
            ),
            if (more != null) more,
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 60),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: buttons,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
