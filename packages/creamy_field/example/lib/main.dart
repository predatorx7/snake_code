import 'package:flutter/material.dart';
import 'package:creamy_field/creamy_field.dart'; // imported the package

void main() {
  final ThemeData _theme = ThemeData(primarySwatch: Colors.blue);
  runApp(MaterialApp(
    home: MyEditorApp(),
    // Change theme mode to try syntax highlighting colors in dark mode & light mode
    themeMode: ThemeMode.light,
    theme: ThemeData(primarySwatch: Colors.blue),
    darkTheme: _theme.copyWith(brightness: Brightness.dark),
  ));
}

class MyEditorApp extends StatefulWidget {
  @override
  _MyEditorAppState createState() => _MyEditorAppState();
}

class _MyEditorAppState extends State<MyEditorApp> {
  // Declared a regular syntax controller.
  late CreamyEditingController controller;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    // The below example shows [CreamyEditingController], a text editing controller with RichText highlighting support
    controller = CreamyEditingController(
      // This is the CreamySyntaxHighlighter which will be used by the controller
      // to generate list of RichText for syntax highlighting
      syntaxHighlighter: CreamySyntaxHighlighter(
        language: LanguageType.dart,
        theme: HighlightedThemeType.defaultTheme,
      ),
      // The number of spaces which will replace `\t`.
      // Setting this to 1 does nothing & setting this to value less than 1
      // throws assertion error.
      tabSize: 4,
    );
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _isDark = Theme.of(context).brightness == Brightness.dark;
    return new Scaffold(
      backgroundColor: _isDark ? Colors.black : Colors.white,
      appBar: new AppBar(
        title: new Text("Rich Code Editor"),
        actions: <Widget>[
          TextButton(
            child: Text('Add tab'),
            onPressed: () {
              // Adds a tab at the selection's base base-offet
              controller.addTab();
            },
          )
        ],
      ),
      // Shows line indicator column adjacent to this widget
      body: LineCountIndicator(
        textControllerOfTextField: controller,
        scrollControllerOfTextField: scrollController,
        decoration: LineCountIndicatorDecoration(
          backgroundColor: Colors.grey,
        ),
        // Allow this Text field to be horizontally scrollable
        child: HorizontalScrollable(
          // Additional options for text selection widget
          child: TextField(
            autofocus: true,
            // Our controller should be up casted as CreamyEditingController
            // Note: Declare controller as CreamyEditingController if this fails.
            controller: controller,
            scrollController: scrollController,
            textCapitalization: TextCapitalization.none,
            decoration: InputDecoration.collapsed(hintText: 'Start writing'),
            maxLines: null,
            selectionControls: CreamyTextSelectionControlsProvider(
              type: TextSelectionControlsType.material,
              actionsBuilder: (_, __, ___) {
                return [
                  CreamyTextSelectionToolbarAction(
                    label: 'Button1',
                    onPressed: () {
                      print('Button2');
                    },
                  ),
                  CreamyTextSelectionToolbarAction(
                    label: 'Button2',
                    onPressed: () {
                      print('Button2');
                    },
                  ),
                ];
              },
            ),
          ),
        ),
      ),
    );
  }
}
