// Copyright (c) 2020, Mushaheed Syed. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause license that can be
// found in the LICENSE file.
//
// --------------------------------------------------------------------------------
// Copyright 2014 The Flutter Authors. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
// ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:creamy_field/creamy_field.dart';

import '../syntax_highlighter.dart';

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
  /// Creates a controller for an editable text field.
  ///
  /// This constructor treats a null [text] argument as if it were an empty
  /// string.
  CreamyEditingController({
    String? text,
    this.syntaxHighlighter,
    this.tabSize = 1,
  })  : assert(tabSize > 0),
        this._syntaxHighlighter = syntaxHighlighter,
        super(text == null
            ? TextEditingValue.empty
            : TextEditingValue(text: __replaceTabsWithSpaces(text, tabSize)));

  /// Creates a controller for an editable text field from an initial [TextEditingValue].
  ///
  /// This constructor treats a null [value] argument as if it were
  /// [TextEditingValue.empty].
  CreamyEditingController.fromValue(
    TextEditingValue? value, {
    this.syntaxHighlighter,
    this.tabSize = 1,
  })  : assert(tabSize > 0),
        this._syntaxHighlighter = syntaxHighlighter,
        assert(
          value == null ||
              !value.composing.isValid ||
              value.isComposingRangeValid,
          'New TextEditingValue $value has an invalid non-empty composing range '
          '${value.composing}. It is recommended to use a valid composing range, '
          'even for readonly text fields',
        ),
        super(value ?? TextEditingValue.empty);

  /// The current string the user is editing.
  String get text => value.text;

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
      text: __replaceTabsWithSpaces(newText, tabSize),
      selection: const TextSelection.collapsed(offset: -1),
      composing: TextRange.empty,
    );
  }

  @override
  set value(TextEditingValue newValue) {
    assert(
      !newValue.composing.isValid || newValue.isComposingRangeValid,
      'New TextEditingValue $newValue has an invalid non-empty composing range '
      '${newValue.composing}. It is recommended to use a valid composing range, '
      'even for readonly text fields',
    );
    super.value = newValue;
  }

  /// The [tabSize] number of spaces which will be used instead of `\t`.
  /// Defaults to 1.
  ///
  /// Note: Flutter currently doesn't support tabSize.
  /// Check this issue for more information
  /// https://github.com/flutter/flutter/issues/50087
  final int tabSize;

  /// Whether the controller will highlight syntax
  ///
  /// Highlighting is disabled if [syntaxHighlighter] is null
  bool get highlightingEnabled => syntaxHighlighter != null;

  /// The syntax highlighter which will parse text from Text Field
  final SyntaxHighlighter? syntaxHighlighter;

  /// The syntax highlighter which will parse text from Text Field
  SyntaxHighlighter? _syntaxHighlighter;

  // Observed that \t renders as a single space in flutter.
  // int tabSize = 4;

  /// Use your own implementation of [SyntaxHighlighter].
  ///
  /// Using this will override built-in syntax highlighting based on
  /// [languageType] & [highlightedThemeType]
  void changeSyntaxHighlighting(SyntaxHighlighter syntaxHighlighter) {
    _syntaxHighlighter = syntaxHighlighter;
  }

  static const _defaultFontColor = Color(0xff000000);

  // TODO: dart:io is not available at web platform currently
  // See: https://github.com/flutter/flutter/issues/39998
  // So we just use monospace here for now
  static const _defaultFontFamily = 'monospace';

  TextSpan _buildSyntaxHighlightedTextSpan(TextStyle? textStyle) {
    var _textStyle = TextStyle(
      fontFamily: _defaultFontFamily,
      color: _defaultFontColor,
    );

    if (textStyle != null) {
      _textStyle = _textStyle.merge(textStyle);
    }

    return TextSpan(
      style: _textStyle,
      children: _syntaxHighlighter!.parseTextEditingValue(value),
    );
  }

  /// Appends a tab at the [TextSelection.baseOffset] and
  /// moves the selection-offset at `previous offset + tab size`.
  void addTab() {
    final int oldOffset = this.selection.baseOffset;
    String replacement;
    if (tabSize != 1) {
      replacement = ' ' * tabSize;
    } else {
      replacement = '\t';
    }
    text = text.replaceRange(oldOffset, oldOffset, replacement);
    this.selection = TextSelection.fromPosition(
      TextPosition(
        offset: oldOffset + tabSize,
      ),
    );
  }

  /// Replaces tabs `\t` with `'' * [tabSize]`
  /// Check https://github.com/flutter/flutter/issues/50087
  // TODO: temporary solution was used. Find a proper fix.
  void _replaceTabsWithSpaces() {
    if (tabSize != 1) {
      if (text.contains('\t')) {
        text = __replaceTabsWithSpaces(text, tabSize);
      }
    }
  }

  /// purpose of this static function is to use in constructor
  /// to prevent unnecessary state rebuild.
  static String __replaceTabsWithSpaces(String text, int tabSize) {
    if (tabSize == 1) return text;
    return text.replaceAll('\t', ' ' * tabSize);
  }

  /// Builds [TextSpan] from current editing value.
  ///
  /// By default makes text in composing range appear as underlined.
  /// Descendants can override this method to customize appearance of text.
  TextSpan buildTextSpan({TextStyle? style, required bool withComposing}) {
    assert(!value.composing.isValid ||
        !withComposing ||
        value.isComposingRangeValid);

    _replaceTabsWithSpaces();
    // This is where the magic happens
    if (_syntaxHighlighter != null && highlightingEnabled) {
      // custom syntax highlighter is used.
      return _buildSyntaxHighlightedTextSpan(style);
    }

    // No syntax highlighting is applied
    if (!value.isComposingRangeValid || !withComposing) {
      return TextSpan(style: style, text: text);
    }
    final TextStyle composingStyle = style!.merge(
      const TextStyle(decoration: TextDecoration.underline),
    );
    return TextSpan(
      style: style,
      children: <TextSpan>[
        TextSpan(text: value.composing.textBefore(value.text)),
        TextSpan(
          style: composingStyle,
          text: value.composing.textInside(value.text),
        ),
        TextSpan(
          text: value.composing.textAfter(value.text),
        ),
      ],
    );
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
  ///
  /// If the new selection if of non-zero length, or is outside the composing
  /// range, the composing composing range is cleared.
  set selection(TextSelection newSelection) {
    if (!isSelectionWithinTextBounds(newSelection))
      throw FlutterError('invalid text selection: $newSelection');
    final TextRange newComposing = newSelection.isCollapsed &&
            _isSelectionWithinComposingRange(newSelection)
        ? value.composing
        : TextRange.empty;
    value = value.copyWith(selection: newSelection, composing: newComposing);
  }

  /// Set the [value] to empty.
  ///
  /// After calling this function, [text] will be the empty string and the
  /// selection will be collapsed at zero offset.
  ///
  /// Calling this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this method should only be called between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  void clear() {
    value =
        const TextEditingValue(selection: TextSelection.collapsed(offset: 0));
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

  /// Check that the [selection] is inside of the composing range.
  bool _isSelectionWithinComposingRange(TextSelection selection) {
    return selection.start >= value.composing.start &&
        selection.end <= value.composing.end;
  }
}

class RestorableCreamyEditingController
    extends RestorableListenable<CreamyEditingController> {
  /// Creates a [RestorableTextEditingController].
  ///
  /// This constructor treats a null `text` argument as if it were the empty
  /// string.
  factory RestorableCreamyEditingController({String? text}) =>
      RestorableCreamyEditingController.fromValue(
        text == null ? TextEditingValue.empty : TextEditingValue(text: text),
      );

  /// Creates a [RestorableTextEditingController] from an initial
  /// [TextEditingValue].
  ///
  /// This constructor treats a null `value` argument as if it were
  /// [TextEditingValue.empty].
  RestorableCreamyEditingController.fromValue(TextEditingValue value)
      : _initialValue = value;

  final TextEditingValue _initialValue;

  @override
  CreamyEditingController createDefaultValue() {
    return CreamyEditingController.fromValue(_initialValue);
  }

  @override
  CreamyEditingController fromPrimitives(Object? data) {
    return CreamyEditingController(text: data as String?);
  }

  @override
  Object toPrimitives() {
    return value.text;
  }

  TextEditingController? _controller;

  @override
  void initWithValue(TextEditingController value) {
    _disposeControllerIfNecessary();
    _controller = value;
    super.initWithValue(value as CreamyEditingController);
  }

  @override
  void dispose() {
    super.dispose();
    _disposeControllerIfNecessary();
  }

  void _disposeControllerIfNecessary() {
    if (_controller != null) {
      // Scheduling a microtask for dispose to give other entities a chance
      // to remove their listeners first.
      scheduleMicrotask(_controller!.dispose);
    }
  }
}
