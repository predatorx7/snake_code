import 'package:code/src/common/strings.dart';
import 'package:code/src/models/hive/history.dart';
import 'package:code/src/models/hive/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart' show Box, Hive;

class RecentHistoryProvider extends ChangeNotifier {
  RecentHistoryProvider() {
    _setup();
  }

  Repository<History> _history;
  Repository<FileModificationHistory> _fileModificationHistory;

  Box<History> get box => _history.box;

  bool get hasHistory {
    return !(_history?.isRepositoryEmpty ?? true);
  }

  bool get isInitialized => _history != null;

  /// Sets up & Initializes preferences.
  Future _setup() async {
    Hive.registerAdapter<FileModificationHistory>(
        FileModificationHistoryAdapter());
    _history = await Repository.get<History>(
        StorageBoxNames.HISTORY, HistoryAdapter());

    _history.listenStream((_) {
      notifyListeners();
    });
    notifyListeners();
  }

  History get(String path) {
    return _history.box.get(path);
  }

  List<History> searchFor(String key) {
    final _histories = <History>[];
    for (var item in _history.box.values) {
      final _itemID = item.workspacePath;
      if (key == _itemID) {
        _histories.insert(0, item);
        return _histories;
      } else if (_itemID.contains(key)) {
        _histories.add(item);
      }
    }
    return _histories;
  }

  List<History> getHistories() {
    final _result = _history?.box?.values?.toList() ?? [];
    _result.sort();
    return _result;
  }

  void add(
    String path, [
    FileModificationHistory lastModifiedFileDetails,
  ]) async {
    final _projectHistory = History(workspacePath: path);
    _projectHistory.lastModifiedFileDetails = lastModifiedFileDetails;
    _projectHistory.updateLastModifiedDateTime();
    await _history.box.put(_projectHistory.workspacePath, _projectHistory);
    print(
        'SAVED: ${_history.box.get(_projectHistory.workspacePath).workspacePath}');
    if (_projectHistory.isInBox) await _projectHistory.save();
  }

  Future<bool> remove(String path) async {
    if (box.containsKey(path)) {
      await box.delete(path);
      return true;
    } else {
      return false;
    }
  }

  Future<void> update(History history) async {
    await box.put(history.workspacePath, history);
    await history.save();
  }
}
