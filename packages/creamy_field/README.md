# creamy_field

A Text Editing Field with rich text & syntax highlight support.

## Getting Started

There are two main components of the rich code editor:

1. Rich Editing Field
2. Syntax Highlighter

The editor is a text area which is identical to Flutter's `TextField` widget. However, unlike a regular `TextField` the editor uses an instance of syntax highlighter object to parse and highlight code syntax.

You can also use a limited support for many programming languages & themes using RichEditingController.

Since the editor itself is independent of the syntax highlighting rules, the same editor can be used for any other programming langugages. Only the syntax highlighter implentation needs to be created separately for each new programming language.

## Previews from example

![markdown](./flutter_01.png)

![dart](./flutter_02.png)

Based on [rich_code_editor](https://github.com/psovit/rich_code_editor/)
