import 'dart:io';

import 'package:code/src/models/plain_model/entity.dart';
import 'package:flutter/widgets.dart';

class EditorController extends ChangeNotifier {
  Map<String, Entity> _openFiles = {};

  /// A map of open files where a file's full path is key & it's [Entity] is value.
  Map<String, Entity> get openFiles => _openFiles;

  /// Basename of file in viewport
  String currentTitle;

  /// Current file in viewport
  Entity currentFile;

  Directory _currentWorkspace;

  Directory get currentWorkspace => _currentWorkspace;

  /// set workspace
  void setCurrentWorkspace(Directory currentWorkspace) {
    _currentWorkspace = currentWorkspace;
    notifyListeners();
  }

  /// Set current tab
  void setCurrentTab(Entity file) {
    currentTitle = file.basename;
    currentFile = file;
    notifyListeners();
  }

  /// Add files to open-file-list
  void addToOpenFiles(Entity file) {
    _openFiles[file.id] = file;
    notifyListeners();
  }

  /// Remove files from open-file-list. Use `<Enitity>.id` as [key].
  void removeFromOpenFiles(String key) {
    _openFiles.remove(key);
  }
}
