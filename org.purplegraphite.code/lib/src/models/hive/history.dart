import 'package:hive/hive.dart';

part 'history.g.dart';

/// UNIMPLEMENTED for a list of open files
@HiveType(typeId: 6)
class FileModificationHistory extends HiveObject {
  @HiveField(1)
  String absolutePath;

  @HiveField(2)
  DateTime _lastModified;

  DateTime get lastModified => _lastModified;

  void updateLastModified() {
    _lastModified = DateTime.now();
  }

  @HiveField(3)
  double scrollOffset;
  @HiveField(4)
  int cursorOffset;
}

@HiveType(typeId: 5)
class History extends HiveObject {
  History(this.absolutePathOfEntity) : super();

  @HiveField(1)
  final String absolutePathOfEntity;

  @HiveField(2)
  FileModificationHistory lastModifiedFileDetails;

  @HiveField(3)
  DateTime _lastModified;

  DateTime get lastModified => _lastModified;

  void _updateLastModified() {
    _lastModified = DateTime.now();
  }

  @override
  Future<void> save() {
    _updateLastModified();
    return super.save();
  }
}
