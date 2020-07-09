import 'package:code/src/models/plain_model/entity.dart';
import 'package:code/src/models/provider/code_controller.dart';
import 'package:code/src/models/provider/theme.dart';
import 'package:code/src/models/view_model/editor_controller.dart';
import 'package:code/src/ui/components/acrylic.dart';
import 'package:code/src/ui/components/buttons/action_tabs_button.dart';
import 'package:code/src/ui/components/buttons/popup_menu.dart';
import 'package:code/src/ui/components/drawer/editor_drawer.dart';
import 'package:code/src/ui/components/popup_menu_tile.dart';
import 'package:creamy_field/creamy_field.dart';
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
  ScrollController _scrollController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final key1 = GlobalKey();
  final key2 = GlobalKey();
  final key3 = GlobalKey();
  final key4 = GlobalKey();
  final key5 = GlobalKey();
  final key6 = GlobalKey();
  EditorController _mainScreenController;
  ThemeProvider _themeProvider;
  FocusNode _focusNode;
  final SyntaxHighlighter _syntaxHighlighter = CreamySyntaxHighlighter(
    language: LanguageType.dart,
    theme: HighlightedThemeType.vsTheme,
  );

  @override
  void initState() {
    _scrollController = ScrollController();
    Provider.of<CodeController>(context, listen: false).addController(
      CreamyEditingController(
        syntaxHighlighter: _syntaxHighlighter,
      ),
    );
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    Provider.of<CodeController>(context, listen: false).disposeController();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _mainScreenController = Provider.of<EditorController>(context);
    if (Provider.of<CodeController>(context).path !=
        _mainScreenController?.currentFile?.absolutePath) {
      Provider.of<CodeController>(context, listen: false)
          .updateController(CreamyEditingController(
        syntaxHighlighter: _syntaxHighlighter,
      ));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CodeController>(context, listen: false)
          .updatePath(_mainScreenController?.currentFile?.absolutePath);
    });

    _themeProvider = Provider.of<ThemeProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final bool _isDarkMode = _themeProvider.isDarkThemeEnabled;
    final popupIconButtonColor = Color.lerp(_theme.accentColor,
        _isDarkMode ? Colors.white : Colors.black, _isDarkMode ? 0.10 : 0.25);
    final darkOnDark = _isDarkMode ? Colors.black : Colors.white;
    final whiteOnDark = _isDarkMode ? Colors.white : Colors.black;

    final Widget _popupActionsButton = Theme(
      data: _theme.copyWith(
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
          color: darkOnDark,
        ),
      ),
    );
    final Widget _endDrawer = Theme(
      key: key1,
      data: _theme.copyWith(
        canvasColor: _isDarkMode
            ? Colors.black.withAlpha(0x44)
            : _theme.canvasColor.withAlpha(0x44),
        iconTheme: _theme.iconTheme.copyWith(
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
    );
    return Scaffold(
      key: _scaffoldKey,
      // !1 Did to make notification panel area be in primaryColor on scroll
      backgroundColor: _theme.primaryColor,
      body: SafeArea(
        child: Container(
          // Refer !1
          color: _isDarkMode
              ? Color.lerp(Colors.black, Colors.white, 0.25)
              : _theme.scaffoldBackgroundColor,
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
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        print(
                            Provider.of<CodeController>(context, listen: false)
                                .textController
                                .textDescriptionToMap);
                      },
                    ),
                    ActionsTabButton(),
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
                return CreamyField(
                  key: key3,
                  controller:
                      Provider.of<CodeController>(context).textController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.none,
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                  obscureText: false,
                  focusNode: _focusNode,
                  style: ThemeProvider.monospaceTextStyle
                      .copyWith(color: whiteOnDark),
                  autocorrect: true,
                  enableSuggestions: true,
                  maxLines: null,
                  scrollPadding: const EdgeInsets.all(20.0),
                  smartDashesType: SmartDashesType.enabled,
                  smartQuotesType: SmartQuotesType.enabled,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Start writing..',
                    hintStyle: ThemeProvider.monospaceTextStyle.copyWith(
                      color: whiteOnDark.withOpacity(0.5),
                    ),
                  ),
                  showLineIndicator: true,
                  horizontallyScrollable: true,
                );
              },
            ),
          ),
        ),
      ),
      endDrawer: _endDrawer,
      drawer: EditorDrawer(),
    );
  }
}
