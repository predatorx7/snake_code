// Copyright (c) 2020, Mushaheed Syed. All rights reserved.
//
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.
// --------------------------------------------------------------------------------
// MIT License
//
// Copyright (c) 2019 Rongjian Zhang
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_highlight/themes/dark.dart' as dark_theme_highlight;
import 'package:flutter_highlight/themes/default.dart'
    as default_theme_highlight;
import 'package:highlight/highlight.dart' show highlight, Node;

import './highlighted_theme_type.dart';
import './language_type.dart';
import '../syntax_highlighter.dart';

/// Highlights a source code's syntax based on language type & theme type.
///
/// This highlighter internally uses [flutter_highlight](https://pub.dev/packages/flutter_highlight)
/// & [highlight](https://pub.dev/packages/highlight)
class CreamySyntaxHighlighter implements SyntaxHighlighter {
  // The original code to be highlighted
  String _source;

  /// Highlight language
  ///
  /// If null then no syntax highlighting will be done.
  ///
  /// [All available languages](https://github.com/pd4d10/highlight/tree/master/highlight/lib/languages)
  final LanguageType language;

  final String _language;

  /// Highlight theme
  ///
  /// Defaults to a light theme.
  ///
  /// [All available themes](https://github.com/pd4d10/highlight/blob/master/flutter_highlight/lib/themes)
  final HighlightedThemeType theme;

  Map<String, TextStyle> _theme;

  /// The dark theme used by this highlighter when [brightness] is [Brightness.dark]
  ///
  /// Defaults to a dark theme.
  final HighlightedThemeType darkTheme;

  Map<String, TextStyle> _darkTheme;

  /// The theme used by this syntax highlighter.
  /// If brightness is dark, [darkTheme] is used and when it's light or null, [theme] is used.
  final ThemeMode themeMode;

  Brightness _brightness;

  /// The Theme brightness of the syntax highlight
  Brightness get brightness => _brightness;

  /// Provide the context to this highligher. This method will be used to update
  /// the brighness based on context in [RichEditableText]
  ///
  /// If you're not using [CreamyField] or [RichEditableText] then use this
  /// to obtain context as it's required to get context.
  void withContext(BuildContext context) {
    // change brightness
    switch (themeMode) {
      case ThemeMode.light:
        _brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        _brightness = Brightness.dark;
        break;
      case ThemeMode.system:
      default:
        _brightness = Theme.of(context).brightness;
        break;
    }
  }

  // The effective theme brighness of this syntax highlighter.
  Brightness get _effectiveBrightness => _brightness ?? Brightness.light;

  bool get _isThemeDark => (_effectiveBrightness == Brightness.dark) ?? false;

  Map<String, TextStyle> get _effectiveTheme {
    if (language == null) return const {};
    // Returning the regular theme as dark theme is null.
    if (_darkTheme == null) return _theme;
    // If theme mode is dark returns a dark theme, else returns the regular theme
    return _isThemeDark ? _darkTheme : _theme;
  }

  /// Creates a syntax highlighter.
  ///
  /// You can specify the language mode & theme type with [language], [theme], [darkTheme], [brightness] respectively.
  ///
  /// For the highlight language, it is recommended to give [language] a value for performance
  /// [All available languages](https://github.com/pd4d10/highlight/tree/master/highlight/lib/languages)
  ///
  /// The supported highlight themes are
  /// [All available themes](https://github.com/pd4d10/highlight/blob/master/flutter_highlight/lib/themes)
  ///
  /// syntax will not be highlighted if language is null.
  CreamySyntaxHighlighter({
    @required this.language,
    @required this.theme,
    this.darkTheme,
    this.themeMode,
  })  : this._language =
            (language != null) ? (toLanguageName(language) ?? 'all') : null,
        this._theme = theme != null
            ? getHighlightedThemeStyle(theme)
            : default_theme_highlight.defaultTheme,
        this._darkTheme = darkTheme != null
            ? getHighlightedThemeStyle(darkTheme)
            : dark_theme_highlight.darkTheme;

  List<TextSpan> _convert(List<Node> nodes) {
    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    void _traverse(Node node) {
      final TextStyle _all =
          _isThemeDark ? TextStyle(color: Colors.white) : null;
      if (node.value != null) {
        currentSpans.add(node.className == null
            ? TextSpan(text: node.value, style: _all)
            : TextSpan(
                text: node.value, style: _effectiveTheme[node.className]));
      } else if (node.children != null) {
        List<TextSpan> tmp = [];
        currentSpans.add(
            TextSpan(children: tmp, style: _effectiveTheme[node.className]));
        stack.add(currentSpans);
        currentSpans = tmp;

        node.children.forEach((n) {
          _traverse(n);
          if (n == node.children.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        });
      }
    }

    for (var node in nodes) {
      _traverse(node);
    }

    return spans;
  }

  @override
  List<TextSpan> parseTextEditingValue(TextEditingValue value) {
    _source = value.text;
    return _convert(highlight
        .parse(_source, language: _language, autoDetection: _language == null)
        .nodes);
  }

  @override
  TextEditingValue onBackSpacePress(
      TextEditingValue oldValue, TextSpan currentSpan) {
    throw UnimplementedError(
        'This syntax highlighter does not support [onBackSpacePress]');
  }

  @override
  TextEditingValue onEnterPress(TextEditingValue oldValue) {
    throw UnimplementedError(
        'This syntax highlighter does not support [onEnterPress]');
  }
}
