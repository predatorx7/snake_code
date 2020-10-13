# creamy_field

[![](https://img.shields.io/pub/v/creamy_field)](https://pub.dev/packages/creamy_field)
[![](https://img.shields.io/github/issues/predatorx7/snake_code)](https://github.com/predatorx7/snake_code/issues)
[![Flutter package analysis](https://github.com/predatorx7/snake_code/workflows/Flutter%20package%20analysis/badge.svg?branch=packages%2Fcreamy_field)](https://github.com/predatorx7/snake_code/actions?query=workflow%3A%22Flutter+package+analysis%22)

Components & widgets with rich text, custom selection toolbar & syntax highlight support. Useful for Rich text editors.

## Getting Started

### The main components of this package

1. [CreamyTextField](#CreamyTextField)
1. [CreamyEditingController](#CreamyEditingController)
1. [Syntax Highlighter](#CreamySyntaxHighlighter)
1. [creamyTextSelectionControls](#creamyTextSelectionControls)

The creamy_field package uses code from flutter to keep API similar/compatible with other components in flutter.

#### CreamyTextField

The CreamyTextField is a text widget similar to Flutter's `TextField` widget. However, unlike a regular `TextField`, this widget supports a syntax highlighter, line indicator, selection toolbar actions, custom text selection toolbar support, ability to horizontally scroll and a controller which provides more description about a text.

#### CreamySyntaxHighlighter

You can use a limited support for syntax highlighting of many programming languages & themes using CreamySyntaxHighlighter.

Since, the text field itself is independent of the syntax highlighting rules, you will only need to implement the syntax highlighter implementation separately for your custom syntax and provide this to the controller.

#### CreamyEditingController

The CreamyEditingController is responsible for changing tab sizes, applyng syntax highlighting to text and providing other useful information like line count.

You can use CreamyEditingController as TextEditingController in regular TextFields/TextFormFields of flutter. Syntax highlighting will work on them too.

#### creamyTextSelectionControls

The additional toolbar actions added in [CreamyTextField](#CreamyTextField) is shown in creamyTextSelectionControls.

If you won't use creamyTextSelectionControls as your CreamyField's text selection control, then actions will not be shown.

### Note

- Versions **before** v0.3.3 is not compatible with flutter v1.22.0 and above due to a lot of breaking changes introduced in Text editing APIs.

- Use [creamy_field v0.3.1](https://pub.dev/packages/creamy_field/versions/0.3.1) if you're using flutter sdk before 1.20.0

- Use [creamy_field v0.3.2](https://pub.dev/packages/creamy_field/versions/0.3.2) if you're using flutter sdk before 1.22.0

Check [screenshots folder](https://github.com/predatorx7/snake_code/tree/master/packages/creamy_field/screenshots) for some sample UI screenshots.

Feel free to add features, [issues](https://github.com/predatorx7/snake_code/issues) & [pull request](https://github.com/predatorx7/snake_code/pulls)
