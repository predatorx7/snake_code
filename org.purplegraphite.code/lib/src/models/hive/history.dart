import 'package:hive/hive.dart';

part 'history.g.dart';

@HiveType(typeId: 5)
class History extends HiveObject {
  @HiveField(1)
  String workspacePath;

  @HiveField(2)
  String lastOpenFile;

  @HiveField(3)
  int lineNumber;

  @HiveField(4)
  int columnNumber;

  /// Last Modified time in milliseconds since unix epoch.
  @HiveField(5)
  int lastModified;

  void setlatestModified() {
    lastModified = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Future<void> save() {
    setlatestModified();
    return super.save();
  }
}
