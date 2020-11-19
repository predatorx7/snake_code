import 'package:code/src/ui/components/acrylic.dart';
import 'package:code/src/ui/components/buttons/action_tabs_button.dart';
import 'package:code/src/ui/components/buttons/popup_menu.dart';
import 'package:code/src/ui/components/drawer/editor_drawer.dart';
import 'package:code/src/ui/components/popup_menu_tile.dart';
import 'package:creamy_field/creamy_field.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/plain_model/entity.dart';
import 'controller.dart';

class EditorScreen extends StatefulWidget {
  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  EditorController controller;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _nestedScrollViewController;

  @override
  void initState() {
    super.initState();
    _nestedScrollViewController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _nestedScrollViewController.dispose();
  }

  @override
  void didChangeDependencies() {
    controller = Provider.of<EditorController>(context);

    super.didChangeDependencies();
  }

  EditorTabPage get activePage => controller.activePage;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final bool _isDarkMode = _theme.brightness == Brightness.dark;
    final popupIconButtonColor = Color.lerp(_theme.accentColor,
        _isDarkMode ? Colors.white : Colors.black, _isDarkMode ? 0.10 : 0.25);
    final backgroundInDark = _isDarkMode ? Colors.black : Colors.white;
    final foregroundInDark = _isDarkMode ? Colors.white : Colors.black;

    final Widget _popupActionsButton = Theme(
      data: _theme.copyWith(
        iconTheme: IconTheme.of(context).copyWith(
          color: foregroundInDark,
        ),
        popupMenuTheme: PopupMenuTheme.of(context).copyWith(
          textStyle: TextStyle(
            fontSize: 16,
            color: foregroundInDark,
          ),
        ),
      ),
      child: CustomPopupMenuButton<dynamic>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
          ),
        ),
        color: _isDarkMode ? Colors.grey[700] : null,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<dynamic>>[
          PopupMenuTile(
            value: 'New file',
            leading: EvaIcons.fileAddOutline,
            title: Text('New file'),
          ),
          PopupMenuTile(
            value: 'Change workspace',
            leading: EvaIcons.folder,
            title: Text('Change workspace'),
          ),
          PopupMenuTile(
            value: 'Goto line',
            leading: EvaIcons.cornerDownRightOutline,
            title: Text('Goto line'),
          ),
          PopupMenuTile(
            value: 'Syntax',
            leading: EvaIcons.colorPalette,
            title: Text('Syntax'),
          ),
          PopupMenuTile(
            value: 'Auto save',
            leading: EvaIcons.cloudUploadOutline,
            title: Text('Auto save'),
          ),
          PopupMenuTile(
            value: 'Find or Replace',
            leading: Icons.find_replace,
            title: Text('Find or Replace'),
          ),
          PopupMenuTile(
            value: 'Share',
            leading: EvaIcons.shareOutline,
            title: Text('Share'),
          ),
        ],
        iconColor: popupIconButtonColor,
        padding: const EdgeInsets.all(10),
        icon: Icon(
          EvaIcons.moreHorizotnalOutline,
          color: backgroundInDark,
        ),
      ),
    );

    final Widget _endDrawer = Theme(
      data: _theme.copyWith(
        canvasColor: _isDarkMode
            ? Colors.black.withAlpha(0x44)
            : _theme.canvasColor.withAlpha(0x44),
        iconTheme: _theme.iconTheme.copyWith(
          color: foregroundInDark,
        ),
      ),
      child: Drawer(
        child: Acrylic(
          enabled: true,
          isDark: _isDarkMode,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 30, left: 30),
                      child: Text(
                        'Tabs',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: foregroundInDark,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                      textColor: foregroundInDark,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('Add new'),
                          SizedBox(width: 5),
                          Icon(
                            EvaIcons.plus,
                            color: foregroundInDark,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: controller.tabs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final page = controller.tabs[index];
                      final Entity entity = page.entity;
                      return ListTile(
                        // leading: <icon relative to extension type>
                        title: Text(
                          entity.basename,
                          style: TextStyle(
                            color: foregroundInDark,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(EvaIcons.closeOutline),
                          splashColor: Colors.red,
                          onPressed: () {
                            controller.removePage(page);
                            // TODO(predatorx7): Set last  edited as current else last else start page
                            setState(() {});
                            Navigator.maybePop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Widget body;
    String _title;

    if (controller.showStartPage) {
      _title = 'Start';
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    "You have no files open\n\nYou can open a file from workspace using 'Explorer'",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: foregroundInDark),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: OutlineButton(
              onPressed: () {},
              child: Text('Select a file from workspace'),
              highlightedBorderColor: foregroundInDark,
              textColor: foregroundInDark,
            ),
          ),
        ],
      );
    } else {
      _title = activePage?.basename ?? 'untitled';
      final CreamyEditingController _textController =
          activePage.textEditingController;
      final ScrollController _scrollController = activePage.scrollController;
      body = CreamyField(
        controller: _textController,
        scrollController: _scrollController,
      );
    }

    return Scaffold(
      //  backgroundColor: _theme.primaryColor,
      // appBar: AppBar(
      //   title: Text(_title),
      //   actions: [_popupActionsButton],
      // ),
      key: _scaffoldKey,
      drawer: EditorDrawer(),
      endDrawer: _endDrawer,
      body: SafeArea(
        child: Container(
          // Refer !1
          color: _isDarkMode
              ? Color.lerp(Colors.black, Colors.white, 0.25)
              : _theme.scaffoldBackgroundColor,
          child: NestedScrollView(
            controller: _nestedScrollViewController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  leading: IconButton(
                    tooltip: "Menu button",
                    icon: Icon(
                      EvaIcons.menu2,
                      color: backgroundInDark,
                    ),
                    onPressed: () {
                      print('open menu');
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                  title: Text(
                    _title,
                    style: TextStyle(color: backgroundInDark),
                  ),
                  actions: <Widget>[
                    ActionsTabButton(),
                    _popupActionsButton,
                    const SizedBox(width: 10),
                  ],
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                ),
              ];
            },
            body: body,
          ),
        ),
      ),
    );
  }
}
