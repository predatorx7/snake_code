import 'package:flutter/material.dart';
import 'package:creamy_field/creamy_field.dart'; // imported the package

void main() {
  runApp(MaterialApp(
    home: MyEditorApp(),
  ));
}

class MyEditorApp extends StatefulWidget {
  @override
  _MyEditorAppState createState() => _MyEditorAppState();
}

class _MyEditorAppState extends State<MyEditorApp> {
  // Declared a regular syntax controller.
  TextEditingController controller;

  @override
  void initState() {
    super.initState();

    // The below example shows the [CreamyEditingController] as [TextEditingController]
    // which uses CreamySyntaxHighlighter for highlighting syntax of text value from
    // the text field which uses this controller.
    controller = CreamyEditingController(
      // This is the CreamySyntaxHighlighter which will be used by the controller
      // to generate list of RichText.
      syntaxHighlighter: CreamySyntaxHighlighter(
        language: LanguageType.dart,
        theme: HighlightedThemeType.githubTheme,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Rich Code Editor"),
      ),
      // A CreamyField is a text field which supports CreamyEditingController
      // & CreamySyntaxHighlighter.
      //
      // This text field is similar to Material TextField but will be
      // tailored (expected in future) for writing rich text,
      // especially for markup & programming languages.
      //
      // For now, using it like Material TextField as below
      body: CreamyField(
        autofocus: true,
        // Our controller should be up casted as CreamyEditingController
        // Note: Declare controller as CreamyEditingController if this fails.
        controller: controller,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration.collapsed(hintText: 'Start writing'),
        maxLines: null,
        // Shows line indicator column adjacent to this widget
        showLineIndicator: true,
        // Allow this Text field to be horizontally scrollable
        horizontallyScrollable: true,
      ),
    );
  }
}
