import 'package:creamy_field/creamy_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const String initialText = """Lorem ipsum is typically a corrupted version of De finibus bonorum et malorum;
A first-century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical, improper Latin.

Versions of the Lorem ipsum text have been used in typesetting at least since the 1960s, when it was popularized by advertisements for Letraset transfer sheets. 
Lorem ipsum was introduced to the digital world in the mid-1980s when Aldus employed it in graphic and word-processing templates for its desktop publishing program PageMaker. Other popular word processors including Pages and Microsoft Word have since adopted Lorem ipsum as well. """;

void main() {
  group('Tests for descriptions obtained from CreamyEditingController: ', () {
    test('Text description test - 1', () {
      const int _baseOffset = 0, _extentOffset = 11;
      final CreamyEditingController textController1 = CreamyEditingController.fromValue(
        TextEditingValue(
          text: initialText,
          selection: const TextSelection(
            baseOffset: _baseOffset,
            extentOffset: _extentOffset,
          ),
        ),
      );
      expect(textController1.selectedText, initialText.substring(_baseOffset, _extentOffset));
      expect(textController1.totalLineCount, 5);
      expect(textController1.atLine, 1);
      expect(textController1.atColumn, 12);
      expect(textController1.baseColumn, 1);
      expect(textController1.extentColumn, 12);
    });

    test('Text description test - 2', () {
      const int _baseOffset = 79, _extentOffset = 94;
      final CreamyEditingController textController2 = CreamyEditingController.fromValue(
        TextEditingValue(
          text: initialText,
          selection: const TextSelection(
            baseOffset: _baseOffset,
            extentOffset: _extentOffset,
          ),
        ),
      );
      expect(textController2.selectedText, initialText.substring(_baseOffset, _extentOffset));
      expect(textController2.totalLineCount, 5);
      expect(textController2.atLine, 2);
      expect(textController2.atColumn, 16);
      expect(textController2.baseColumn, 1);
      expect(textController2.extentColumn, 16);
    });

    test('Text description test - 3', () {
      int _baseOffset = initialText.length - 7, _extentOffset = initialText.length;
      final CreamyEditingController textController3 = CreamyEditingController.fromValue(
        TextEditingValue(
          text: initialText,
          selection: TextSelection(
            baseOffset: _baseOffset,
            extentOffset: _extentOffset,
          ),
        ),
      );
      expect(textController3.selectedText, initialText.substring(_baseOffset, _extentOffset));
      expect(textController3.totalLineCount, 5);
      expect(textController3.atLine, 5);
      expect(textController3.atColumn, 281);
      expect(textController3.baseColumn, 274);
      expect(textController3.extentColumn, 281);
    });
  });

  group('When using CreamyEditingController, are \\t getting replaced with spaces when', () {
    CreamyEditingController controller;
    final int tabSize = 4;
    final String textWithSpaces = 'hello${' ' * tabSize}world';
    final String textWithTabs = 'hello\tworld';
    setUp(() {
      controller = CreamyEditingController(
        text: textWithTabs,
        tabSize: tabSize,
      );
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    });
    test('the constructor is initialized with a text containing `\\t`', () {
      expect(
        controller.text,
        textWithSpaces,
        reason: 'The number of spaces replaced by single tab is not equal to tabSize',
      );
    });
    test('text is changed', () {
      final String newLineWithTab = '\n\tAdded tab on start of this line';
      final String newLineWithSpaces = '\n${' ' * tabSize}Added tab on start of this line';
      controller.text = '${controller.text}$newLineWithTab';
      expect(controller.text, textWithSpaces + newLineWithSpaces);
    });

    test('\\t is added to the end', () {
      final String previousText = controller.text;
      controller.addTab();
      final int newBaseOffset = controller.selection.baseOffset;
      final String newText = controller.text;
      expect(newBaseOffset, controller.text.length, reason: 'cursor was not moved to the end');
      expect(newText, previousText + (' ' * tabSize), reason: 'At the end, the number of spaces replaced by single tab is not equal to tabSize');
    });

    test('\\t is added not in the end or start', () {
      final String previousText = controller.text;
      final int offset = (previousText.length / 2).round();
      controller.selection = TextSelection.fromPosition(TextPosition(
        offset: offset,
      ));
      final int oldBaseOffset = controller.selection.baseOffset;
      controller.addTab();
      final int newBaseOffset = controller.selection.baseOffset;
      final String newText = controller.text;
      expect(newBaseOffset, oldBaseOffset + tabSize,
          reason: 'cursor was not moved to the correct position after tabs where replaced with spaces, previous offset: ${previousText.length}, tabSize: $tabSize');
      expect(newText, previousText.substring(0, offset) + (' ' * tabSize) + previousText.substring(offset, previousText.length),
          reason: 'At the end, the number of spaces replaced by single tab is not equal to tabSize');
    });
    tearDown(() {
      controller.dispose();
    });
  });
}
