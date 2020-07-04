import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

// This is the interface that must be implemented by Syntax highlighter's for each programming language
abstract class SyntaxHighlighter {
  /// Parses text from [value] & generates syntax highglighted text as list of `TextSpan` object.
  List<TextSpan> parseTextEditingValue(TextEditingValue value);

  /// Handler to support enter press event.
  /// Can be used to add extra tab indents on enter press.
  TextEditingValue onEnterPress(TextEditingValue oldValue) => oldValue;

  /// Handler to support backspace press event.
  /// Can be used to remove extra tab indents on backspace press.
  TextEditingValue onBackSpacePress(
          TextEditingValue oldValue, TextSpan currentSpan) =>
      oldValue;
}
