import 'dart:io';

import 'package:creamy_field/creamy_field.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

import '../../../models/plain_model/entity.dart';
import '../../../models/plain_model/entity.dart';
import '../../../utils/logman.dart';

enum EditorMode {
  Directory,
  SingleFile,
  NoDirectory,
  NoFile,
}

class EditorSettings {
  final bool isDirectory;

  bool get isFile => !isDirectory;

  final Entity entity;

  final EditorMode editorMode;

  factory EditorSettings.fromEntity(Entity entity) {
    if (entity.entity is File) {
      return EditorSettings.fromFileEntity(entity);
    } else if (entity.entity is Directory) {
      return EditorSettings.fromDirectoryEntity(entity);
    } else {
      logger.e(
          'Entity type "${entity.runtimeType}" is not supported by EditorScreen');
      return null;
    }
  }

  factory EditorSettings.fromDirectory(String path) {
    final Entity entity = Entity(Directory(path));
    return EditorSettings.fromDirectoryEntity(entity);
  }

  EditorSettings.fromDirectoryEntity(this.entity)
      : isDirectory = true,
        editorMode = EditorMode.Directory;

  factory EditorSettings.fromFile(String path) {
    final Entity entity = Entity(File(path));
    return EditorSettings.fromFileEntity(entity);
  }

  EditorSettings.fromFileEntity(this.entity)
      : isDirectory = false,
        editorMode = EditorMode.SingleFile;

  EditorSettings.noDirectory()
      : entity = null,
        isDirectory = true,
        editorMode = EditorMode.NoDirectory;

  EditorSettings.noFile()
      : entity = null,
        isDirectory = false,
        editorMode = EditorMode.NoFile;
}

class EditorTabPage {
  final Entity _entity;

  EditorTabPage(this._entity) {
    _id = "$_sIDs-${DateTime.now().toIso8601String()}";
    _sIDs++;
  }

  String _id;

  static int _sIDs = 0;

  String get id => _id;

  String get absolutePath => _entity.absolutePath;

  String get basename => _entity != null ? _entity.basename : 'untitled';

  String _openTimeInText;

  Entity get entity => _entity;

  String get restorationID {
    assert(_openTimeInText != null);
    return '$absolutePath-$_openTimeInText';
  }

  RestorableCreamyEditingController textEditingController;

  void open() {
    textEditingController = RestorableCreamyEditingController();
    _openTimeInText = DateTime.now().toIso8601String();
  }

  void close() {
    textEditingController.dispose();
    textEditingController = null;
    _openTimeInText = null;
  }
}

class EditorController with ChangeNotifier {
  EditorSettings _settings;

  Entity get entity => _settings.entity;

  String get superDirectoryPath {
    final _path = entity.absolutePath;
    if (_settings.isDirectory) {
      return _path;
    } else {
      return path.dirname(_path);
    }
  }

  EditorMode get mode => _settings.editorMode;

  void updateSettings(EditorSettings settings) {
    _settings = settings;
    switch (mode) {
      case EditorMode.Directory:
        // TODO: Handle this case.
        break;
      case EditorMode.SingleFile:
        // TODO: Handle this case.
        break;
      case EditorMode.NoDirectory:
        // TODO: Handle this case.
        break;
      case EditorMode.NoFile:
        // TODO: Handle this case.
        break;
    }
    notifyListeners();
  }
}
