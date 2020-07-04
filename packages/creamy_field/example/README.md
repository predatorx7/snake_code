# example

This example demonstrates a sample usage of `creamy_field` package.

## Usage with TextEditingController & Syntax highlighter

The below example shows the [CreamyEditingController] as [TextEditingController]
which uses CreamySyntaxHighlighter for highlighting syntax of text value from
the text field which uses this controller.

```dart
TextEditingController controller = CreamyEditingController(
        syntaxHighlighter: CreamySyntaxHighlighter(
        language: LanguageType.dart,
        theme: HighlightedThemeType.githubTheme,
    ),
);
```

## CreamyField

A CreamyField is a text field which supports CreamyEditingController & CreamySyntaxHighlighter.
This text field is similar to Material TextField but will be tailored (expected in future) for
writing rich text, especially for markup & programming languages.

For now, use it like Material TextField as

```dart
CreamyField(
    autofocus: true,
    controller: controller,
    textCapitalization: TextCapitalization.none,
    decoration: InputDecoration.collapsed(hintText: 'Start writing'),
);
```