import 'package:code/src/common/strings.dart';
import 'package:code/src/models/hive/history.dart';
import 'package:code/src/models/hive/repository.dart';
import 'package:flutter/foundation.dart';

class RecentHistoryProvider extends ChangeNotifier {
  RecentHistoryProvider() {
    _setup();
  }

  Repository<History> _history;
  Repository<FileModificationHistory> _fileModificationHistory;

  bool get hasHistory {
    return !(_history?.isRepositoryEmpty ?? true);
  }

  bool get isInitialized => _history != null;

  /// Sets up & Initializes preferences.
  Future _setup() async {
    Repository.register<FileModificationHistory>(
        FileModificationHistoryAdapter());
    Repository.register<History>(HistoryAdapter());
    _fileModificationHistory =
        await Repository.get(StorageBoxNames.FILE_MODIFICATION_HISTORY);
    _history = await Repository.get<History>(StorageBoxNames.HISTORY);

    notifyListeners();
  }

  History get(String path) {
    final _result = _history.box.get(path);
    return _result;
  }

  void add(
    String path,
    String lastModifiedFilePath,
    int lastModifiedFileCursorOffset,
    double lastModifiedFileScrollOffset,
  ) async {
    final _entry = History(path);
    final _lastModifiedFileDetails = FileModificationHistory();
    _lastModifiedFileDetails.absolutePath = lastModifiedFilePath;
    _lastModifiedFileDetails.cursorOffset = lastModifiedFileCursorOffset;
    _lastModifiedFileDetails.scrollOffset = lastModifiedFileScrollOffset;
    _lastModifiedFileDetails.updateLastModified();
    await _fileModificationHistory.box
        .put(lastModifiedFilePath, _lastModifiedFileDetails);
    _entry.lastModifiedFileDetails = _lastModifiedFileDetails;
    await _history.box.put(path, _entry);
  }

  void update(History history) async {
    await _history.box.put(history.absolutePathOfEntity, history);
  }
}
