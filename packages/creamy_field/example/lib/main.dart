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
  CreamyEditingController controller;

  @override
  void initState() {
    super.initState();

    // The below example shows [CreamyEditingController], a text editing controller.
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
  }

  @override
  void dispose() {
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
          FlatButton(
            child: Text('Add tab'),
            onPressed: () {
              // Adds a tab at the selection's base base-offet
              controller.addTab();
            },
          )
        ],
      ),
      body: CreamyField(
        autofocus: true,
        // Our controller should be up casted as CreamyEditingController
        // Note: Declare controller as CreamyEditingController if this fails.
        controller: controller,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration.collapsed(hintText: 'Start writing'),
        lineCountIndicatorDecoration: LineCountIndicatorDecoration(
          backgroundColor: Colors.grey,
        ),
        maxLines: null,
        // Shows line indicator column adjacent to this widget
        showLineIndicator: true,
        // Allow this Text field to be horizontally scrollable
        horizontallyScrollable: true,
        // Additional options for text selection widget
        toolbarOptions: CreamyToolbarOptions.allTrue(
          // Below line enables dark mode in selection widget
          selectionToolbarThemeMode: ThemeMode.dark,
          useCamelCaseLabel: true,
          actions: [
            CreamyToolbarItem(
              label: 'Button1',
              callback: () {
                print('Button2');
              },
            ),
            CreamyToolbarItem(
              label: 'Button2',
              callback: () {
                print('Button2');
              },
            ),
          ],
        ),
      ),
    );
  }
}
