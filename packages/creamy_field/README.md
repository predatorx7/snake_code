# creamy_field

[![](https://img.shields.io/pub/v/creamy_field)](https://pub.dev/packages/creamy_field)
[![](https://img.shields.io/github/issues/predatorx7/snake_code)](https://github.com/predatorx7/snake_code/issues)
[![Flutter package analysis](https://github.com/predatorx7/snake_code/workflows/Flutter%20package%20analysis/badge.svg?branch=packages%2Fcreamy_field)](https://github.com/predatorx7/snake_code/actions?query=workflow%3A%22Flutter+package+analysis%22)

Components & widgets with rich text, custom selection toolbar & syntax highlight support. Useful for Rich text editors.

## Getting Started

### The main components of this package

1. [CreamyTextField (REMOVED)](#CreamyTextField)
1. [CreamyEditingController](#CreamyEditingController)
1. [Syntax Highlighter](#CreamySyntaxHighlighter)
1. [LineCountIndicator](#LineCountIndicator)
1. [HorizontalScrollable](#HorizontalScrollable)
1. [CreamyTextSelectionControlsProvider](#CreamyTextSelectionControlsProvider)

The creamy_field package uses some code from flutter to keep API similar/compatible with other components in flutter.

#### CreamyTextField

This widget has been removed.

The CreamyTextField was a text widget similar to Flutter's `TextField` widget with additional features. However, with update to flutter v2.x.x, we don't need this anymore. Components from this package can be used with flutter library to provide additional functionality while editing text. 

#### CreamySyntaxHighlighter

You can use a limited support for syntax highlighting of many programming languages & themes using CreamySyntaxHighlighter.

Since, the text field itself is independent of the syntax highlighting rules, you will only need to implement the syntax highlighter implementation separately for your custom syntax and provide this to the controller.

#### CreamyEditingController

The CreamyEditingController is responsible for changing tab sizes, applyng syntax highlighting to text and providing other useful information like line count.

You can use CreamyEditingController as TextEditingController in regular TextFields/TextFormFields of flutter. Syntax highlighting will work on them too.

Some text features described above are provided by an extension on TextEditingController. Check [CreamyTextFieldExtensions].

#### LineCountIndicator

A horizontal widget with lists of indexes to represent adjacent TextField's line number.

A [LineCountIndicatorDecoration] decoration can be applied to this widget.

Make sure that the decoration uses the same font-family & font-size from the TextField.

#### HorizontalScrollable

Makes a child widget horizontally scrollable. Developed with intent of wrapping a TextField to make it horizontally scrollable.

In the future, the controller in this widget which is provided to a child TextField will be used to determine horizontal scroll extent.

#### CreamyTextSelectionControlsProvider

The class can be used to add additional toolbar actions to a selection toolbar in a text field.

This package provides several text selection controls (only 1 in v0.4.0) via CreamyTextSelectionControls. You can create your own selection controls which supports additional toolbar actions by mixing with [CreamyTextSelectionControls] and providing that in [CreamyTextSelectionControlsProvider.custom].

### Note

- Versions **before** v0.4.0 is not compatible with flutter v2.x.x due to a lot of breaking changes introduced in Text editing APIs. We'll try to keep the API stable in v0.4.0 and above.

- Use [creamy_field v0.3.3](https://pub.dev/packages/creamy_field/versions/0.3.3) if you're using flutter sdk `>=1.22.0 <2.0.0`

- Use [creamy_field v0.3.2](https://pub.dev/packages/creamy_field/versions/0.3.2) if you're using flutter sdk `>1.20.0 <1.22.0`

- Use [creamy_field v0.3.1](https://pub.dev/packages/creamy_field/versions/0.3.1) if you're using flutter sdk `<=1.20.0`



Check [screenshots folder](https://github.com/predatorx7/snake_code/tree/master/packages/creamy_field/screenshots) for some sample UI screenshots.

Feel free to add features, [issues](https://github.com/predatorx7/snake_code/issues) & [pull request](https://github.com/predatorx7/snake_code/pulls)
