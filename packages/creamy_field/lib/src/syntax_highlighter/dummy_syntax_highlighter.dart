import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:creamy_field/creamy_field.dart';

/// This is a dummy implementation of Syntax highlighter for Testing purpose.
/// Ideally, you would implement the `SyntaxHighlighterBase` interface as per your need of highlighting rules.
class DummySyntaxHighlighter implements SyntaxHighlighter {
  @override
  List<TextSpan> parseTextEditingValue(TextEditingValue tev) {
    var texts = tev.text.split(' ');

    var lsSpans = List<TextSpan>();
    texts.forEach((text) {
      if (text == 'class') {
        lsSpans
            .add(TextSpan(text: text, style: TextStyle(color: Colors.green)));
      } else if (text == 'if' || text == 'else') {
        lsSpans.add(TextSpan(text: text, style: TextStyle(color: Colors.blue)));
      } else if (text == 'return') {
        lsSpans.add(TextSpan(text: text, style: TextStyle(color: Colors.red)));
      } else {
        lsSpans
            .add(TextSpan(text: text, style: TextStyle(color: Colors.black)));
      }
      lsSpans.add(TextSpan(text: ' ', style: TextStyle(color: Colors.black)));
    });
    return lsSpans;
  }
}
