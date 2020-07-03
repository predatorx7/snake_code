import 'package:flutter/widgets.dart' show TextEditingController;

class TextDescription {
  final TextEditingController controller;
  const TextDescription(this.controller);
  String get text => controller?.text ?? '';
  String get selectedText => controller.selection.textInside(text);
  String get beforeSelectedText => controller.selection.textBefore(text);
  String get afterSelectedText => controller.selection.textAfter(text);
  int get totalLines => text?.split('\n')?.length ?? 0;
  int get atLine => beforeSelectedText?.split('\n')?.length ?? 1;
  int get atColumn {
    int _extent = controller?.selection?.extentOffset ?? 0;
    String precursorText = text?.substring(0, _extent) ?? '';
    return _extent - precursorText?.lastIndexOf('\n') ?? 0;
  }

  Map<String, dynamic> get toMap => <String, dynamic>{
        'text': text,
        'totalLines': totalLines,
        'atLine': atLine,
        'atColumn': atColumn,
        'selectedText': selectedText,
        'beforeSelectedText': beforeSelectedText,
        'afterSelectedText': afterSelectedText,
      };

  void printMap() {
    var _map = toMap;
    _map.forEach((key, dynamic value) {
      if (key == 'text') return;
      print('$key : $value');
    });
  }
}
