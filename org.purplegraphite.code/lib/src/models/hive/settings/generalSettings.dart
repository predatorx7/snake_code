import 'package:code/src/models/hive/repository.dart';
import 'package:hive/hive.dart';

part 'generalSettings.g.dart';

@HiveType(typeId: 1)
class GeneralSettings extends HiveObject {
  @HiveField(1)
  bool _debuggingEnabled;

  bool get debuggingEnabled => _debuggingEnabled ?? false;

  void set debuggingEnabled(bool debuggingEnabled) {
    if (_debuggingEnabled) {
      print('Cannot disable debugging');
      return;
    }
    _debuggingEnabled = debuggingEnabled;
  }
}
