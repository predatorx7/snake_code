import 'package:flutter/material.dart';
import 'package:creamy_field/creamy_field.dart';

void main() {
  runApp(MaterialApp(
    home: DemoCodeEditor(),
  ));
}

class DemoCodeEditor extends StatefulWidget {
  @override
  _DemoCodeEditorState createState() => _DemoCodeEditorState();
}

class _DemoCodeEditorState extends State<DemoCodeEditor> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    // _syntaxHighlighterBase = DummySyntaxHighlighter();
    controller = CreamyEditingController(
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
      body: Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(2.0),
          decoration:
              new BoxDecoration(border: new Border.all(color: Colors.grey)),
          child: CreamyField(
            autofocus: true,
            controller: controller,
            textCapitalization: TextCapitalization.none,
            decoration: InputDecoration.collapsed(hintText: 'Start writing'),
            maxLines: null,
            // onChanged: (String s) {},
            // onBackSpacePress: (TextEditingValue oldValue) {},
            // onEnterPress: (TextEditingValue oldValue) {
            // var result = _syntaxHighlighterBase.onEnterPress(oldValue);
            // if (result != null) {
            //   _rec.value = result;
            // }
            // setState(() {});
            // },
          )),
    );
  }
}
