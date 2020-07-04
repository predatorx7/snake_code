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
import 'package:highlight/highlight.dart' show highlight, Node;

import './highlighted_theme_type.dart';
import './language_type.dart';
import '../syntax_highlighter.dart';

/// Highlights a source code's syntax based on language type & theme type.
///
/// This highlighter internally uses `flutter_highlight` & `highlight`
class CreamySyntaxHighlighter implements SyntaxHighlighter {
  /// The original code to be highlighted
  String _source;

  /// The original code to be highlighted
  String get source => _source;

  /// The [tabSize] number of spaces which will be used instead of `\t`.
  final int tabSize;

  /// Highlight language
  ///
  /// It is recommended to give it a value for performance
  ///
  /// [All available languages](https://github.com/pd4d10/highlight/tree/master/highlight/lib/languages)
  final String language;

  /// Highlight theme
  ///
  /// [All available themes](https://github.com/pd4d10/highlight/blob/master/flutter_highlight/lib/themes)
  final Map<String, TextStyle> theme;

  /// Creates a syntax highlighter.
  ///
  /// You can specify the language mode & theme type with [language], [theme] respectively.
  ///
  /// For the highlight language, it is recommended to give [language] a value for performance
  /// [All available languages](https://github.com/pd4d10/highlight/tree/master/highlight/lib/languages)
  ///
  /// The supported highlight themes are
  /// [All available themes](https://github.com/pd4d10/highlight/blob/master/flutter_highlight/lib/themes)
  CreamySyntaxHighlighter({
    LanguageType language,
    HighlightedThemeType theme = HighlightedThemeType.githubTheme,
    this.tabSize = 8, // TODO: https://github.com/flutter/flutter/issues/50087
  })  : this.language = toLanguageName(language) ?? LanguageType.all,
        this.theme = getHighlightedThemeStyle(theme) ?? const {};

  List<TextSpan> _convert(List<Node> nodes) {
    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    void _traverse(Node node) {
      if (node.value != null) {
        currentSpans.add(node.className == null
            ? TextSpan(text: node.value)
            : TextSpan(text: node.value, style: theme[node.className]));
      } else if (node.children != null) {
        List<TextSpan> tmp = [];
        currentSpans.add(TextSpan(children: tmp, style: theme[node.className]));
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
    _source = value.text.replaceAll('\t', ' ' * tabSize);
    return _convert(highlight.parse(source, language: language).nodes);
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
