import 'package:code/src/ui/screens/editor/controller.dart';

class FileSaving {
  static List<EditorTabPage> pages = [];

  void add(EditorTabPage page) {
    pages.add(page);
    _addOnChangeSaveCallback(page);
  }

  void remove(EditorTabPage page) {
    pages.remove(page);
  }

  bool _isAutoSaveEnabled = true;

  void _addOnChangeSaveCallback(EditorTabPage page) {
    if (page.textEditingController != null) {
      page.textEditingController.addListener(() async {
        if (_isAutoSaveEnabled) {
          await save(page);
        }
      });
    }
  }

  Future<void> save(EditorTabPage page) async {
    if (page.textEditingController != null) {
      final exists = await page.fileEntity.exists();
      if (!exists) return;
      await page.fileEntity.writeAsString(page.textEditingController.text);
    }
  }

  void enableAutoSave() {
    _isAutoSaveEnabled = true;
  }

  void disableAutoSave() {
    _isAutoSaveEnabled = false;
  }
}
