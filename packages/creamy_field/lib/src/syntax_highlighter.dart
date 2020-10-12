import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'syntax_highlighter/creamy_syntax_highlighter.dart' show CreamySyntaxHighlighter;
import 'syntax_highlighter/dummy_syntax_highlighter.dart' show DummySyntaxHighlighter;

/// This is the interface that must be implemented by a Syntax highlighter
/// like [CreamySyntaxHighlighter] & [DummySyntaxHighlighter]
abstract class SyntaxHighlighter {
  /// Parses text from [value] & generates syntax highlighted text as list of [TextSpan].
  List<TextSpan> parseTextEditingValue(TextEditingValue value);

  /// Handler to support enter press event.
  /// Can be used to add extra tab indents on enter press.
  TextEditingValue onEnterPress(TextEditingValue oldValue) => oldValue;

  /// Handler to support backspace press event.
  /// Can be used to remove extra tab indents on backspace press.
  TextEditingValue onBackSpacePress(TextEditingValue oldValue, TextSpan currentSpan) => oldValue;
}
