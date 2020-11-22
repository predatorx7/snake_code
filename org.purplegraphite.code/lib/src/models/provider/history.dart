import 'package:code/src/common/strings.dart';
import 'package:code/src/models/hive/history.dart';
import 'package:code/src/models/hive/repository.dart';
import 'package:flutter/foundation.dart';

class RecentHistoryProvider extends ChangeNotifier {
  RecentHistoryProvider() {
    _setup();
  }

  Repository<History> _history;

  bool get hasHistory {
    return !(_history?.isRepositoryEmpty ?? true);
  }

  /// Sets up & Initializes preferences.
  Future _setup() async {
    _history = await Repository.get<History>(
        StorageBoxNames.HISTORY, HistoryAdapter());

    notifyListeners();
    // _themeSettingsR.listenStream(_onThemeChange); // No current use
  }

  History searchFor(String path) {
    for (History i in _history.iterable()) {
      if (i.workspacePath == path) {
        return i;
      }
    }

    return null;
  }

  void add(String path) {
    
  }

  void remove() {

  }

  void update() {

  }

  void get() {
    
  }
}
