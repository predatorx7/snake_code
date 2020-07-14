import 'dart:io';

import 'package:creamy_field/creamy_field.dart';
import 'package:flutter/material.dart';

class EditorTabController with ChangeNotifier {
  String get directoryPath => entity.path;
  final File entity;
  ScrollController scrollController;
  FocusNode focusNode;
  CreamyEditingController textController;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  void initState() {
    scrollController = ScrollController();
    textController = CreamyEditingController();
    focusNode = FocusNode();
    _initialized = true;
  }

  @override
  void dispose() {
    scrollController.dispose();
    focusNode.dispose();
    textController.dispose();
    super.dispose();
    _initialized = false;
  }

  EditorTabController(this.entity);
}

class EditorTab extends StatefulWidget {
  final EditorTabController controller;

  const EditorTab._({
    @required this.controller,
    Key key,
  }) : super(key: key);

  factory EditorTab.fromFile(File entity) {
    return EditorTab._(
      controller: EditorTabController(entity),
    );
  }

  @override
  _EditorTabState createState() => _EditorTabState();
}

class _EditorTabState extends State<EditorTab> {
  @override
  void initState() {
    widget.controller.initState();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
