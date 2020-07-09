import 'package:creamy_field/creamy_field.dart';
import 'package:flutter/widgets.dart' show ChangeNotifier;

class CodeController extends ChangeNotifier {
  CreamyEditingController textController;
  String path;

  void addController(CreamyEditingController controller) {
    textController = controller;
  }

  void updateController(CreamyEditingController controller) {
    disposeController();
    addController(controller);
  }

  void disposeController() {
    textController.dispose();
  }

  void updatePath(String path) {
    this.path = path;
    notifyListeners();
  }
}
