import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:creamy_field/creamy_field.dart';

import 'syntax_highlighter.dart';

/// A controller for an editable text field.
///
/// Similar to [TextEditingController] but with
/// properties to get several more details about a text like:
/// 1. Total number of lines
/// 1. Line number of caret
/// 1. Shows column number of cursor
///
/// Also supports syntax highlighting, and syntax highlight theme type.
class CreamyEditingController extends ValueNotifier<TextEditingValue>
    implements TextEditingController {
  /// Enable syntax highlighting
  bool _enableHighlighting;

  /// syntax highlighting status
  bool get enableHighlighting =>
      _enableHighlighting ?? (syntaxHighlighter != null) ?? false;

  /// The syntax highlighter which will parse text from Text Field
  final SyntaxHighlighter syntaxHighlighter;

  /// The syntax highlighter which will parse text from Text Field
  SyntaxHighlighter _syntaxHighlighter;

  /// Creates a controller for an editable text field.
  ///
  /// This constructor treats a null [text] argument as if it were an empty
  /// string.
  CreamyEditingController({
    String text,
    this.syntaxHighlighter,
  })  : this._syntaxHighlighter = syntaxHighlighter,
        this._enableHighlighting = (syntaxHighlighter != null) ?? false,
        super(text == null
            ? TextEditingValue.empty
            : TextEditingValue(text: text));

  /// Creates a controller for an editable text field from an initial [TextEditingValue].
  ///
  /// This constructor treats a null [value] argument as if it were
  /// [TextEditingValue.empty].
  CreamyEditingController.fromValue(
    TextEditingValue value, {
    this.syntaxHighlighter,
  })  : this._syntaxHighlighter = syntaxHighlighter,
        this._enableHighlighting = (syntaxHighlighter != null) ?? false,
        super(value ?? TextEditingValue.empty);

  /// The current string the user is editing.
  String get text => value.text;

  /// Use your own implementation of [SyntaxHighlighter].
  ///
  /// Using this will override built-in syntax highlighting based on
  /// [languageType] & [highlightedThemeType]
  void changeSyntaxHighlighting(SyntaxHighlighter syntaxHighlighter) {
    _syntaxHighlighter = syntaxHighlighter;
  }

  /// Toggle text's syntax highlighting.
  void toggleHighlighting(bool value) {
    this._enableHighlighting = value;
  }

  /// Setting this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this value should only be set between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  ///
  /// This property can be set from a listener added to this
  /// [TextEditingController]; however, one should not also set [selection]
  /// in a separate statement. To change both the [text] and the [selection]
  /// change the controller's [value].
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: const TextSelection.collapsed(offset: -1),
      composing: TextRange.empty,
    );
  }

  static const _defaultFontColor = Color(0xff000000);

  // TODO: dart:io is not available at web platform currently
  // See: https://github.com/flutter/flutter/issues/39998
  // So we just use monospace here for now
  static const _defaultFontFamily = 'monospace';

  TextSpan _buildSyntaxHighlightedTextSpan(TextStyle textStyle) {
    var _textStyle = TextStyle(
      fontFamily: _defaultFontFamily,
      color: _defaultFontColor,
    );

    if (textStyle != null) {
      _textStyle = _textStyle.merge(textStyle);
    }

    return TextSpan(
      style: _textStyle,
      children: _syntaxHighlighter.parseTextEditingValue(value),
    );
  }

  /// Builds [TextSpan] from current editing value.
  ///
  /// By default makes text in composing range appear as underlined.
  /// Descendants can override this method to customize appearance of text.
  TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
    // This is where the magic happens
    if (_syntaxHighlighter != null && enableHighlighting) {
      // custom syntax highlighter is used.
      return _buildSyntaxHighlightedTextSpan(style);
    }

    // No syntax highlighting is applied
    if (!value.composing.isValid || !withComposing) {
      return TextSpan(style: style, text: text);
    }
    final TextStyle composingStyle = style.merge(
      const TextStyle(decoration: TextDecoration.underline),
    );
    return TextSpan(style: style, children: <TextSpan>[
      TextSpan(text: value.composing.textBefore(value.text)),
      TextSpan(
        style: composingStyle,
        text: value.composing.textInside(value.text),
      ),
      TextSpan(text: value.composing.textAfter(value.text)),
    ]);
  }

  /// The currently selected [text].
  ///
  /// If the selection is collapsed, then this property gives the offset of the
  /// cursor within the text.
  TextSelection get selection => value.selection;

  /// Setting this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this value should only be set between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  ///
  /// This property can be set from a listener added to this
  /// [TextEditingController]; however, one should not also set [text]
  /// in a separate statement. To change both the [text] and the [selection]
  /// change the controller's [value].
  set selection(TextSelection newSelection) {
    if (!isSelectionWithinTextBounds(newSelection))
      throw FlutterError('invalid text selection: $newSelection');
    value = value.copyWith(selection: newSelection, composing: TextRange.empty);
  }

  /// The text currently under selection
  String get selectedText => value.selection.textInside(text);

  /// The text before the current text selection
  String get beforeSelectedText => value.selection.textBefore(text);

  /// The text after the current text selection
  String get afterSelectedText => value.selection.textAfter(text);

  /// Total number of lines in the [text]
  int get totalLineCount => value.text?.split('\n')?.length ?? 0;

  /// The line at which end cursor lies
  int get atLine => beforeSelectedText?.split('\n')?.length ?? 1;

  /// The column at which the end cursor is at.
  int get atColumn {
    int _extent = value?.selection?.extentOffset ?? 0;
    String precursorText = text?.substring(0, _extent) ?? '';
    return (_extent - (precursorText?.lastIndexOf('\n') ?? 0));
  }

  Map<String, dynamic> get textDescriptionToMap => <String, dynamic>{
        'text': text,
        'totalLines': totalLineCount,
        'atLine': atLine,
        'atColumn': atColumn,
        'selectedText': selectedText,
        'beforeSelectedText': beforeSelectedText,
        'afterSelectedText': afterSelectedText,
      };

  /// Set the [value] to empty.
  ///
  /// After calling this function, [text] will be the empty string and the
  /// selection will be invalid.
  ///
  /// Calling this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this method should only be called between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  void clear() {
    value = TextEditingValue.empty;
  }

  /// Set the composing region to an empty range.
  ///
  /// The composing region is the range of text that is still being composed.
  /// Calling this function indicates that the user is done composing that
  /// region.
  ///
  /// Calling this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this method should only be called between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  void clearComposing() {
    value = value.copyWith(composing: TextRange.empty);
  }

  /// Check that the [selection] is inside of the bounds of [text].
  bool isSelectionWithinTextBounds(TextSelection selection) {
    return selection.start <= text.length && selection.end <= text.length;
  }
}
