import 'package:code/src/models/plain_model/text_description.dart';
import 'package:flutter/widgets.dart'
    show ChangeNotifier, TextEditingController;

class CodeController extends ChangeNotifier {
  TextEditingController textController;
  String path;

  TextDescription _documentDescription;

  TextDescription get documentDescription => _documentDescription;

  void addController(TextEditingController controller) {
    textController = controller;
    notifyListeners();
    textController.addListener(listenController);
  }

  void updateController(TextEditingController controller) {
    disposeController();
    addController(controller);
  }

  void disposeController() {
    textController.dispose();
  }

  void listenController() {
    _documentDescription = TextDescription(textController);
    notifyListeners();
  }

  void updatePath(String path) {
    this.path = path;
    notifyListeners();
  }
}
