import 'dart:io';

import 'package:code/service/saver.dart';
import 'package:code/src/models/hive/history.dart';
import 'package:code/src/models/provider/history.dart';
import 'package:code/src/models/provider/theme.dart';
import 'package:creamy_field/creamy_field.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;

import '../../../models/plain_model/entity.dart';
import '../../../utils/logman.dart';

/// The mode in which the controller will handle the Editor
///
/// - Directory: A folder is opened as a directory
/// - SingleFile: A single file is opened to be edited
/// - NoDirectory: No project has been created. Location to save project will be asked on first save attempt.
/// - NoFle: No file has been created. Location to save file will be asked on first save attempt.
enum EditorMode {
  Directory,
  SingleFile,
  NoDirectory,
  NoFile,
}

/// The settings for current Editor and Editor controller
class EditorSettings {
  final bool isDirectory;

  bool get isFile => !isDirectory;

  final Entity entity;

  final EditorMode editorMode;

  /// Create a setting from an [Entity].
  ///
  /// If the Entity represents a File then the controller will handle Editor in File based mode.
  /// If the [Entity] represents [Directory] then the controller will handle Editor in a Project based mode.
  ///
  /// Symbolic links are not supported.
  factory EditorSettings.fromEntity(Entity entity) {
    if (entity.entity is File) {
      return EditorSettings.fromFileEntity(entity);
    } else if (entity.entity is Directory) {
      return EditorSettings.fromDirectoryEntity(entity);
    } else {
      logger.info(
          'Entity type "${entity.runtimeType}" is not supported by EditorScreen');
      return null;
    }
  }

  /// Create a setting from a [path] to a Directory.
  ///
  /// The controller using this setting will handle Editor in a Project based mode.
  factory EditorSettings.fromDirectory(String path) {
    final Entity entity = Entity(Directory(path));
    return EditorSettings.fromDirectoryEntity(entity);
  }

  /// Create a setting from an [Entity] which represents a Directory.
  ///
  /// The controller using this setting will handle Editor in a Project based mode.
  EditorSettings.fromDirectoryEntity(this.entity)
      : isDirectory = true,
        editorMode = EditorMode.Directory {
    _echo();
  }

  _echo() {
    print('Settings created in $editorMode');
  }

  /// Create a setting from a [path] to a File.
  ///
  /// The controller using this setting will handle Editor in File based mode.
  ///
  /// Symbolic links are not supported.
  factory EditorSettings.fromFile(String path) {
    final Entity entity = Entity(File(path));
    return EditorSettings.fromFileEntity(entity);
  }

  /// Create a setting from an [Entity] which represents a File.
  ///
  /// The controller using this setting will handle Editor in File based mode.
  ///
  /// Symbolic links are not supported.
  EditorSettings.fromFileEntity(this.entity)
      : isDirectory = false,
        editorMode = EditorMode.SingleFile {
    _echo();
  }

  EditorSettings.noDirectory()
      : entity = null,
        isDirectory = true,
        editorMode = EditorMode.NoDirectory {
    _echo();
  }

  EditorSettings.noFile()
      : entity = null,
        isDirectory = false,
        editorMode = EditorMode.NoFile {
    _echo();
  }
}

class EditorTabPage with EquatableMixin {
  final Entity _entity;

  EditorTabPage(this._entity) {
    _id = "$_sIDs-${DateTime.now().toIso8601String()}";
    _sIDs++;
  }

  String _id;

  static int _sIDs = 0;

  String get id => _id;

  String get absolutePath => _entity.absolutePath;

  ValueKey _key;

  ValueKey get valueKey {
    if (_key == null) _key = ValueKey(_entity.absolutePath);
    return _key;
  }

  String get basename => _entity != null ? _entity.basename : 'untitled';

  String _openTimeInText;

  Entity get entity => _entity;

  File get fileEntity => entity.entity;

  String get restorationID {
    assert(_openTimeInText != null);
    return '$absolutePath-$_openTimeInText';
  }

  CreamyEditingController textEditingController;
  ScrollController scrollController;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized ?? false;

  Future<void> open(CreamySyntaxHighlighter syntaxHighlighter) async {
    if (isInitialized) return;
    textEditingController = CreamyEditingController(
      syntaxHighlighter: syntaxHighlighter,
    );
    final exists = await fileEntity.exists();
    if (exists) {
      final content = await fileEntity.readAsString();
      textEditingController.text = content;
    }
    scrollController = ScrollController();
    _openTimeInText = DateTime.now().toIso8601String();
    _isInitialized = true;
  }

  void close() {
    if (!isInitialized) return;
    textEditingController.dispose();
    scrollController.dispose();
    textEditingController = null;
    scrollController = null;
    _openTimeInText = null;
    _isInitialized = false;
  }

  @override
  List<String> get props => [
        absolutePath,
      ];
}

class EditorController with ChangeNotifier {
  final RecentHistoryProvider historyProvider;
  final ThemeProvider themeProvider;

  EditorController(this.historyProvider, this.themeProvider);

  EditorSettings _settings;

  Entity get entity => _settings.entity;

  String get superDirectoryPath {
    final _path = entity.absolutePath;
    if (_settings.isDirectory) {
      /// This Entity is a directory. We only need this directory path.
      return _path;
    } else {
      /// This entity is a File. We need the directory path which contains this File.
      return path.dirname(_path);
    }
  }

  /// The mode in which the controller is handling the Editor
  EditorMode get mode => _settings.editorMode;

  List<EditorTabPage> _tabs = [];

  /// list of tabs user opened
  List<EditorTabPage> get tabs => _tabs;

  /// page which is shown in  Editor
  EditorTabPage _activePage;

  void changeActiveTo(EditorTabPage page) {
    _activePage = page;
    notifyListeners();
  }

  /// Get the currently active page
  EditorTabPage get activePage {
    if (_tabs?.isEmpty ?? true) return null;
    if (_activePage != null) return _activePage;
    _activePage = _tabs.first;
    return _activePage;
  }

  /// Should a start page be shown when no tabs are open
  bool get showStartPage => _tabs?.isEmpty ?? true;

  final fileSaving = FileSaving();

  /// Open a page in tabs
  void addPage(EditorTabPage page) async {
    for (var item in _tabs) {
      if (item.absolutePath == page.absolutePath) {
        return;
      }
    }
    await _addPage(page);
    _activePage = page;
    notifyListeners();
  }

  void _addPage(EditorTabPage page) async {
    final _syntaxHighlighter = themeProvider.createSyntaxHighlighter(
      page.basename,
    );
    await page.open(_syntaxHighlighter);
    _tabs.add(page);
    fileSaving.add(page);
  }

  void updateSettings(EditorSettings settings) async {
    assert(settings != null);

    _settings = settings;
    switch (settings.editorMode) {
      case EditorMode.SingleFile:
        final page = EditorTabPage(entity);
        await _addPage(page);
        break;
      case EditorMode.NoDirectory:
        break;
      case EditorMode.NoFile:
        final page = EditorTabPage(null);
        await _addPage(page);
        break;
      case EditorMode.Directory:
      default:
    }
    notifyListeners();
    historyProvider.add(
      settings.entity.absolutePath,
      FileModificationHistory(),
    );
  }

  void removePage(EditorTabPage page) {
    if (activePage == page) {
      _activePage = null;
    }
    _removePage(page);
    notifyListeners();
  }

  void _removePage(EditorTabPage page) {
    _tabs.remove(page);
    fileSaving.remove(page);
    page.close();
  }
}
