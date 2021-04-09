import 'dart:io';

import 'package:code/src/models/plain_model/entity.dart';
import 'package:code/src/utils/fileutils.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;

class BrowserController extends ChangeNotifier {
  Directory _current;

  Directory get current => _current;

  List<Entity> _currentEntities = <Entity>[];
  List<Entity> get currentEntities => _currentEntities;
  bool _stopLoading = false;

  bool get stopLoading => _stopLoading;
  List<String> _recentlyCreatedFolder = <String>[];

  // List of paths of newly created folder
  List<String> get recentlyCreatedFolder => _recentlyCreatedFolder;

  /// Creates folder and updates listeners
  void createFolderAndAddToRecent(
      BuildContext context, String recentlyCreatedFolderBasename) async {
    var recentlyCreatedFolderPath =
        path.join(current.path, recentlyCreatedFolderBasename);
    await Directory.fromUri(
      Uri(
        path: recentlyCreatedFolderPath,
      ),
    ).create();
    _recentlyCreatedFolder.add(recentlyCreatedFolderPath);
    notifyListeners();
    await updateEntityList(context);
  }

  Future<File> createFileAndAddToRecent(
      BuildContext context, String recentlyCreatedFolderBasename) async {
    var recentlyCreatedFolderPath =
        path.join(current.path, recentlyCreatedFolderBasename);
    final _file = await File.fromUri(
      Uri(
        path: recentlyCreatedFolderPath,
      ),
    ).create();
    _recentlyCreatedFolder.add(recentlyCreatedFolderPath);
    notifyListeners();
    await updateEntityList(context);
    return _file;
  }

  Future setCurrent(Directory dir) async {
    _current = dir;
    _currentEntities = await FileUtils.listEntities(_current);
    _stopLoading = true;
    notifyListeners();
  }

  Future<void> updateEntityList(BuildContext context) async {
    if (!(await current.exists())) {
      Navigator.of(context).maybePop();
      return;
    }
    var _c = await FileUtils.listEntities(_current);
    if (_c.length == _currentEntities.length) {
      var same = true;
      for (var i = 0; i < _c.length; i++) {
        same = _c[i] == _currentEntities[i];
        if (!same) break;
      }
      if (same) return;
    }

    _currentEntities = _c;
    notifyListeners();
  }
}
