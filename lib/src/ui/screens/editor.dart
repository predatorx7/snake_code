import 'package:code/src/common/routing_const.dart';
import 'package:code/src/models/plain_model/entity.dart';
import 'package:code/src/models/provider/theme.dart';
import 'package:code/src/models/view_model/editor_controller.dart';
import 'package:code/src/ui/components/acrylic.dart';
import 'package:code/src/ui/components/buttons/popup_menu.dart';
import 'package:code/src/ui/components/code_editing_field.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditorScreen extends StatefulWidget {
  final Entity entity;
  const EditorScreen({Key key, this.entity}) : super(key: key);
  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  ScrollController _scrollController, _fieldScrollController;
  TextEditingController _editFieldController;
  GlobalKey<ScaffoldState> _scaffoldKey;
  final key1 = GlobalKey();
  final key2 = GlobalKey();
  final key3 = GlobalKey();
  final key4 = GlobalKey();
  final key5 = GlobalKey();
  final key6 = GlobalKey();
  EditorController _mainScreenController;
  ThemeProvider _themeProvider;
  String _selection;
  Color primaryColorD;
  FocusNode _focusNode;

  bool isDarkTheme() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  void initState() {
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _scrollController = ScrollController();
    _fieldScrollController = ScrollController();
    _editFieldController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _editFieldController.dispose();
    _fieldScrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _mainScreenController = Provider.of<EditorController>(context);
    _themeProvider = Provider.of<ThemeProvider>(context);
    super.didChangeDependencies();
  }

  PopupMenuItem<String> popupMenuTile(
      {String value, IconData leading, Text title}) {
    return PopupMenuItem<String>(
      key: ValueKey(value),
      value: value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8, left: 8),
            child: Icon(
              leading,
            ),
          ),
          title,
        ],
      ),
    );
  }

  Widget ColoredListTile(bool isDark, MaterialColor color,
      void Function() onPressed, Widget title, Widget leading) {
    return Container(
      color: isDark ? color[700] : color[500],
      child: OutlineButton(
        padding: EdgeInsets.zero,
        borderSide: BorderSide.none,
        splashColor: color[600],
        onPressed: onPressed,
        child: ListTile(
          title: title,
          leading: IconTheme(
            data: Theme.of(context)
                .iconTheme
                .copyWith(color: isDark ? Colors.white : Colors.black),
            child: leading,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool _isDarkMode = isDarkTheme();
    final popupIconButtonColor = Color.lerp(Theme.of(context).accentColor,
        _isDarkMode ? Colors.white : Colors.black, _isDarkMode ? 0.10 : 0.25);
    final darkOnDark = _isDarkMode ? Colors.black : Colors.white;
    final whiteOnDark = _isDarkMode ? Colors.white : Colors.black;
    Color appbarAccent = _isDarkMode ? Colors.amber : Colors.white;
    final Widget _actionTabChangeButton = Builder(
      builder: (context) {
        final openFiles = _mainScreenController.openFiles;
        String disp;
        if (openFiles?.isEmpty ?? true) {
          disp = '0';
        } else if (openFiles.length > 99) {
          disp = ':P';
        } else {
          disp = openFiles.length.toString();
        }
        return Tooltip(
          message: 'change tabs',
          child: IconButton(
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
            icon: Center(
              child: Container(
                padding: const EdgeInsets.all(2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(6), // To match with chrome
                  // borderRadius: BorderRadius.circular(25), // Original
                  border: Border.all(
                      width: 2,
                      color: _isDarkMode ? appbarAccent : Colors.white),
                ),
                constraints: BoxConstraints.tight(const Size(25.0, 25.0)),
                child: Text(
                  '$disp',
                  style: TextStyle(
                    color: appbarAccent,
                    fontWeight: _isDarkMode ? FontWeight.w800 : FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    final Widget _popupActionsButton = Theme(
      data: Theme.of(context).copyWith(
        iconTheme: IconTheme.of(context).copyWith(
          color: whiteOnDark,
        ),
        popupMenuTheme: PopupMenuTheme.of(context).copyWith(
          textStyle: TextStyle(
            fontSize: 16,
            color: whiteOnDark,
          ),
        ),
      ),
      child: CustomPopupMenuButton<String>(
        onSelected: (String value) {
          setState(() {
            _selection = value;
          });
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
          ),
        ),
        color: _isDarkMode ? Colors.grey[700] : null,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          popupMenuTile(
            value: 'New file',
            leading: EvaIcons.fileAddOutline,
            title: Text('New file'),
          ),
          popupMenuTile(
            value: 'Change workspace',
            leading: EvaIcons.folder,
            title: Text('Change workspace'),
          ),
          popupMenuTile(
            value: 'Goto line',
            leading: EvaIcons.cornerDownRightOutline,
            title: Text('Goto line'),
          ),
          popupMenuTile(
            value: 'Syntax',
            leading: EvaIcons.colorPalette,
            title: Text('Syntax'),
          ),
          popupMenuTile(
            value: 'Auto save',
            leading: EvaIcons.cloudUploadOutline,
            title: Text('Auto save'),
          ),
          popupMenuTile(
            value: 'Find or Replace',
            leading: Icons.find_replace,
            title: Text('Find or Replace'),
          ),
          popupMenuTile(
            value: 'Share',
            leading: EvaIcons.shareOutline,
            title: Text('Share'),
          ),
        ],
        iconColor: popupIconButtonColor,
        padding: const EdgeInsets.all(10),
        icon: Icon(
          EvaIcons.moreHorizotnalOutline,
          color: darkOnDark,
        ),
      ),
    );
    return Scaffold(
      key: _scaffoldKey,
      // !1 Did to make notification panel area be in primaryColor on scroll
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          // Refer !1
          color: _isDarkMode
              ? Color.lerp(Colors.black, Colors.white, 0.25)
              : Theme.of(context).scaffoldBackgroundColor,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  leading: IconButton(
                    tooltip: "Menu button",
                    icon: Icon(
                      EvaIcons.menu2,
                      color: darkOnDark,
                    ),
                    onPressed: () {
                      print('open menu');
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                  title: Text(
                    _mainScreenController.currentTitle ?? "Start",
                    style: TextStyle(color: darkOnDark),
                  ),
                  actions: <Widget>[
                    _actionTabChangeButton,
                    _popupActionsButton,
                    const SizedBox(width: 10),
                  ],
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                ),
              ];
            },
            body: Consumer<EditorController>(
              builder: (context, _mainController, _) {
                return CodeEditingField(
                  key: key3,
                  controller: _editFieldController,
                  focusNode: _focusNode,
                  verticalAxisScrollController: _fieldScrollController,
                  style: ThemeProvider.monospaceTextStyle
                      .copyWith(color: whiteOnDark),
                );
              },
            ),
          ),
        ),
      ),
      endDrawer: Theme(
        key: key1,
        data: Theme.of(context).copyWith(
          canvasColor: _isDarkMode
              ? Colors.black.withAlpha(0x44)
              : Theme.of(context).canvasColor.withAlpha(0x44),
          iconTheme: Theme.of(context).iconTheme.copyWith(
                color: whiteOnDark,
              ),
        ),
        child: Drawer(
          key: key4,
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
                            color: whiteOnDark,
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          final Entity _blankFile = Entity.blank();
                          _mainScreenController.addToOpenFiles(_blankFile);
                          _mainScreenController.setCurrentTab(_blankFile);
                          Navigator.maybePop(context);
                        },
                        textColor: whiteOnDark,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('Add new'),
                            SizedBox(width: 5),
                            Icon(
                              EvaIcons.plus,
                              color: whiteOnDark,
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
                      itemCount: _mainScreenController.openFiles.length,
                      itemBuilder: (BuildContext context, int index) {
                        final current = _mainScreenController.openFiles.values
                            .toList()[index];
                        return ListTile(
                          // leading: <icon relative to extension type>
                          title: Text(
                            current.basename,
                            style: TextStyle(
                              color: whiteOnDark,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(EvaIcons.closeOutline),
                            splashColor: Colors.red,
                            onPressed: () {
                              _mainScreenController
                                  .removeFromOpenFiles(current.absolutePath);
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
      ),
      drawer: Theme(
        key: key2,
        data: Theme.of(context).copyWith(
          canvasColor: _isDarkMode ? Colors.black87 : null,
          iconTheme: Theme.of(context).iconTheme.copyWith(
                color: whiteOnDark,
              ),
          textTheme: Theme.of(context).textTheme.copyWith(
                body2: TextStyle(color: whiteOnDark),
              ),
        ),
        child: Drawer(
          key: key5,
          child: ListView(
            key: key6,
            children: <Widget>[
              ListTile(
                title: const Text("Finder"),
                leading: Icon(Icons.find_in_page),
              ),
              Tooltip(
                message: 'Browse workspace',
                child: ListTile(
                  title: const Text("Explorer"),
                  leading: Icon(EvaIcons.compassOutline),
                ),
              ),
              ListTile(
                title: const Text("Search"),
                leading: Icon(EvaIcons.searchOutline),
              ),
              ListTile(
                title: const Text("Source control"),
                leading: Icon(Icons.timeline),
              ),
              ListTile(
                title: const Text("Run"),
                leading: Icon(EvaIcons.arrowheadRightOutline),
              ),
              ListTile(
                title: const Text("Terminal"),
                leading: Icon(EvaIcons.code),
                onTap: () {
                  Navigator.pushNamed(context, TerminalScreenRoute);
                },
              ),
              ColoredListTile(
                _isDarkMode,
                Colors.grey,
                () {
                  Navigator.of(context).popAndPushNamed(StartScreenRoute);
                },
                const Text("Settings"),
                Icon(
                  EvaIcons.settings2Outline,
                ),
              ),
              ColoredListTile(
                _isDarkMode,
                Colors.red,
                () {
                  Navigator.of(context).pushReplacementNamed(StartScreenRoute);
                },
                const Text("Close"),
                Icon(
                  EvaIcons.closeCircleOutline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
