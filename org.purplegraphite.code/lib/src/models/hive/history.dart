import 'package:hive/hive.dart';

part 'history.g.dart';

/// UNIMPLEMENTED for a list of open files
@HiveType(typeId: 6)
class FileModificationHistory extends HiveObject {
  @HiveField(1)
  String absolutePath;
  @HiveField(2)
  DateTime lastModified;
  @HiveField(3)
  double scrollOffset;
  @HiveField(4)
  int cursorOffset;
}

@HiveType(typeId: 5)
class History extends HiveObject {
  @HiveField(1)
  String workspacePath;

  @HiveField(2)
  FileModificationHistory lastModifiedFileDetails;

  @HiveField(3)
  DateTime lastModified;

  void setlatestModified() {
    lastModified = DateTime.now();
  }

  @override
  Future<void> save() {
    setlatestModified();
    return super.save();
  }
}
