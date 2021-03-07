import 'package:flutter/widgets.dart' show TextEditingController;

/// Extension methods on [TextEditingController] for additional information about the editing text.

extension CreamyTextFieldExtensions on TextEditingController {
  /// The text currently under selection
  String get selectedText => selection.textInside(text);

  /// The text before the current text selection
  String get beforeSelectedText => selection.textBefore(text);

  /// The text after the current text selection
  String get afterSelectedText => selection.textAfter(text);

  /// Total number of lines in the [text]
  int get totalLineCount => text.split('\n').length;

  /// The line at which end cursor lies
  int get atLine => beforeSelectedText.split('\n').length;

  /// The column at which the end cursor is at.
  int get atColumn {
    int _extent = selection.extentOffset;
    String precursorText = text.substring(0, _extent);
    return (_extent - precursorText.lastIndexOf('\n'));
  }

  /// The column index where the selection extent ends.
  /// Same as [atColumn].
  int get extentColumn {
    return atColumn;
  }

  /// The column index at which the selection (base) begins.
  int get baseColumn {
    int _base = selection.baseOffset;
    String precursorText = text.substring(0, _base);
    return (_base - precursorText.lastIndexOf('\n'));
  }

  // TODO: add extensions to TextEditingValue
  Map<String, dynamic> get textDescriptionMap => <String, dynamic>{
        'text': text,
        'beforeSelectedText': beforeSelectedText,
        'afterSelectedText': afterSelectedText,
        'selectedText': selectedText,
        'totalLines': totalLineCount,
        'atLine': atLine,
        'atColumn': atColumn,
        'baseColumn': baseColumn,
        'extentColumn': extentColumn,
      };
}
