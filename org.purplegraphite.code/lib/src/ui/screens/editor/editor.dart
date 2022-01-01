import 'dart:io';

import 'package:code/src/common/routing_const.dart';
import 'package:code/src/models/provider/theme.dart';
import 'package:code/src/ui/components/acrylic.dart';
import 'package:code/src/ui/components/buttons/action_tabs_button.dart';
import 'package:code/src/ui/components/buttons/popup_menu.dart';
import 'package:code/src/ui/components/drawer/editor_drawer.dart';
import 'package:code/src/ui/components/popup_menu_tile.dart';
import 'package:creamy_field/creamy_field.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

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

  static void addAfterPosition(TextEditingController controller, String toAdd) {
    final int oldOffset = controller.selection.baseOffset;
    controller.text = controller.text.replaceRange(
      oldOffset,
      oldOffset,
      toAdd,
    );
    controller.selection = TextSelection.fromPosition(
      TextPosition(
        offset: oldOffset + 1,
      ),
    );
  }

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
        onSelected: (value) {
          switch (value) {
            case 'Change workspace':
              Navigator.of(context).pushNamed(BrowserScreenRoute);
              break;
            case 'Save':
              if (controller.activePage != null)
                controller.fileSaving.save(controller.activePage);
              break;
            case 'Share':
              if (controller.activePage != null)
                Share.shareFiles(
                  [
                    controller.activePage.absolutePath,
                  ],
                );
              break;
            default:
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<dynamic>>[
          // PopupMenuTile(
          //   value: 'New file',
          //   leading: EvaIcons.fileAddOutline,
          //   title: Text('New file'),
          // ),
          if (controller.activePage != null)
            PopupMenuTile(
              value: 'Save',
              leading: EvaIcons.saveOutline,
              title: Text('Save'),
            ),
          PopupMenuTile(
            value: 'Change workspace',
            leading: EvaIcons.folder,
            title: Text('Change workspace'),
          ),
          // PopupMenuTile(
          //   value: 'Goto line',
          //   leading: EvaIcons.cornerDownRightOutline,
          //   title: Text('Goto line'),
          // ),
          // PopupMenuTile(
          //   value: 'Syntax',
          //   leading: EvaIcons.colorPalette,
          //   title: Text('Syntax'),
          // ),
          // PopupMenuTile(
          //   value: 'Auto save',
          //   leading: EvaIcons.cloudUploadOutline,
          //   title: Text('Auto save'),
          // ),
          // PopupMenuTile(
          //   value: 'Find or Replace',
          //   leading: Icons.find_replace,
          //   title: Text('Find or Replace'),
          // ),
          if (controller.activePage != null)
            PopupMenuTile(
              value: 'Share',
              leading: EvaIcons.shareOutline,
              title: Text('Share'),
            ),
        ],
        iconColor: popupIconButtonColor,
        padding: const EdgeInsets.all(10),
        icon: Icon(
          EvaIcons.moreHorizontalOutline,
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Tabs',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: foregroundInDark,
                    ),
                  ),
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
                        onTap: () {
                          controller.changeActiveTo(page);
                          Navigator.maybePop(context);
                        },
                        trailing: IconButton(
                          icon: Icon(EvaIcons.closeCircleOutline),
                          splashColor: Colors.red,
                          onPressed: () {
                            controller.removePage(page);
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

    if (controller.showStartPage || controller.activePage == null) {
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
              onPressed: () {
                Navigator.of(context).pushNamed(
                  WorkspaceExplorerScreenRoute,
                  arguments: controller.entity.entity as Directory,
                );
              },
              child: Text('Select a file from workspace'),
              highlightedBorderColor: foregroundInDark,
              textColor: foregroundInDark,
            ),
          ),
        ],
      );
    } else {
      final _activePage = controller.activePage;
      _title = _activePage?.basename ?? 'untitled';
      final CreamyEditingController _textController =
          _activePage.textEditingController;
      final ScrollController _scrollController = _activePage.scrollController;

      //   final ThemeData _theme = Theme.of(context);
      // final bool _isDarkMode = _theme.brightness == Brightness.dark;
      // final popupIconButtonColor = Color.lerp(_theme.accentColor,
      //     _isDarkMode ? Colors.white : Colors.black, _isDarkMode ? 0.10 : 0.25);
      // final backgroundInDark = _isDarkMode ? Colors.black : Colors.white;
      // final foregroundInDark = _isDarkMode ? Colors.white : Colors.black;

      final _monoTextStyle = ThemeProvider.monospaceTextStyle.copyWith(
        color: _isDarkMode ? Colors.white : Colors.black,
      );

      final _indicatorAndBarColor = Colors.grey;

      final actionAccentColor = Color.lerp(
        _theme.accentColor,
        _isDarkMode ? Colors.white : Colors.black,
        0.30,
      );

      final buttonStyle = OutlinedButton.styleFrom(
        primary: actionAccentColor,
      );

      body = Column(
        children: [
          Expanded(
            child: Scrollbar(
              key: _activePage.valueKey,
              radius: Radius.circular(15),
              child: LineCountIndicator(
                textControllerOfTextField: _textController,
                scrollControllerOfTextField: _scrollController,
                decoration: LineCountIndicatorDecoration(
                  backgroundColor: _indicatorAndBarColor,
                  textStyle: _monoTextStyle.copyWith(
                    color: _isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
                child: HorizontalScrollable(
                  child: TextField(
                    controller: _textController,
                    scrollController: _scrollController,
                    showCursor: true,
                    decoration:
                        InputDecoration.collapsed(hintText: 'Start writing'),
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: _monoTextStyle,
                  ),
                ),
              ),
            ),
          ),
          new Container(
            color: _isDarkMode ? Colors.black : Colors.white,
            padding: new EdgeInsets.all(6.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 35,
              ),
              child: new ListView(
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      controller.activePage.textEditingController.addTab();
                      setState(() {});
                    },
                    style: buttonStyle,
                    child: Text('TAB'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      final textController =
                          controller.activePage.textEditingController;
                      final int oldOffset = textController.selection.baseOffset;
                      if (oldOffset - 1 < 0) {
                        return;
                      }
                      textController.selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: oldOffset - 1,
                        ),
                      );
                      setState(() {});
                    },
                    child: Icon(
                      EvaIcons.arrowLeft,
                      color: actionAccentColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      final textController =
                          controller.activePage.textEditingController;
                      final int oldOffset = textController.selection.baseOffset;
                      if (oldOffset + 1 >= textController.text.length) {
                        return;
                      }
                      textController.selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: oldOffset + 1,
                        ),
                      );
                      setState(() {});
                    },
                    child: Icon(
                      EvaIcons.arrowRight,
                      color: actionAccentColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      final textController =
                          controller.activePage.textEditingController;
                      addAfterPosition(textController, '{}');
                      setState(() {});
                    },
                    child: Text('{'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      final textController =
                          controller.activePage.textEditingController;
                      addAfterPosition(textController, '}');
                      setState(() {});
                    },
                    child: Text('}'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      final textController =
                          controller.activePage.textEditingController;
                      addAfterPosition(textController, '()');
                      setState(() {});
                    },
                    child: Text('('),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      final textController =
                          controller.activePage.textEditingController;
                      addAfterPosition(textController, ')');
                      setState(() {});
                    },
                    child: Text(')'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      //  backgroundColor: _theme.primaryColor,
      // appBar: AppBar(
      //   title: Text(_title),
      //   actions: [_popupActionsButton],
      // ),
      key: _scaffoldKey,
      drawer: EditorDrawer(folder: controller.entity.entity as Directory),
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
