# creamy_field

[![](https://img.shields.io/pub/v/creamy_field)](https://pub.dev/packages/creamy_field)
[![](https://img.shields.io/github/issues/predatorx7/snake_code)](https://github.com/predatorx7/snake_code/issues)

Components & widgets with rich text, custom selection toolbar & syntax highlight support. Useful for Rich text editors.

## Getting Started

### The main components of this package:

1. CreamyTextField
1. CreamyEditingController
1. Syntax Highlighter
1. creamyTextSelectionControls

The CreamyTextField is a text widget similar to Flutter's `TextField` widget. However, unlike a regular `TextField` the editor supports a syntax highlighter and a controller which provides more description about a text.

You can also use a limited support for many programming languages & themes using CreamySyntaxHighlighter.

Since the text field itself is independent of the syntax highlighting rules, the same text field can be used for any other programming or markup langugage.
Only the syntax highlighter implementation needs to be created separately for each new programming language.

Check [screenshots folder](https://github.com/predatorx7/snake_code/tree/master/packages/creamy_field/screenshots) for some sample UI screenshots.

Feel free to add features, [issues](https://github.com/predatorx7/snake_code/issues) & [pull request](https://github.com/predatorx7/snake_code/pulls)
