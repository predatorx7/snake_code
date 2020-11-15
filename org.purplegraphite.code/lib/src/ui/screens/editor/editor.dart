import 'dart:io';

import 'package:creamy_field/creamy_field.dart';
import 'package:flutter/material.dart';

import '../../../models/plain_model/entity.dart';
import '../../../utils/logman.dart';

class EditorScreen extends StatefulWidget {
  factory EditorScreen.fromEntity(Entity entity) {
    if (entity.entity is File) {
      return EditorScreen.fromFileEntity(entity);
    } else if (entity.entity is Directory) {
      return EditorScreen.fromDirectoryEntity(entity);
    } else {
      logger.e(
          'Entity type "${entity.runtimeType}" is not supported by EditorScreen');
      return null;
    }
  }

  factory EditorScreen.fromDirectory(String path) {}

  EditorScreen.fromDirectoryEntity(Entity entity) {
    // Full functionality
  }

  factory EditorScreen.fromFile(String path) {
    // Single file mode
  }

  EditorScreen.fromFileEntity(Entity entity);

  EditorScreen.noDirectory();

  EditorScreen.noFile();

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  RestorableCreamyEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = RestorableCreamyEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CreamyField(),
    );
  }
}
