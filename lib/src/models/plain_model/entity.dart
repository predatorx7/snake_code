import 'dart:io';
import 'package:path/path.dart' as path;

class Entity extends Comparable<Entity> {
  String get id => absolutePath;
  String get name => basename;
  String basename;
  String absolutePath;
  FileSystemEntity entity;
  FileStat stat;

  /// Scroll Offset, initially 0
  double scrollOffset = 0.0;

  Entity(this.entity) {
    if (!this.entity.isAbsolute) {
      this.entity = this.entity.absolute;
    }
    absolutePath = this.entity.path;
    basename = path.basename(this.entity.path);
  }

  Entity.blank()
      : absolutePath = DateTime.now().millisecondsSinceEpoch.toString(),
        basename = 'untitled';

  void updateStatus() async {
    this.stat = await entity.stat();
  }

  @override
  bool operator ==(Object other) {
    if (other is Entity) {
      return this.absolutePath == other.absolutePath;
    } else
      return false;
  }

  @override
  int compareTo(Entity other) {
    // Converting 1st char to lowercase
    String a = '${this.basename[0].toLowerCase()}${this.basename.substring(1)}';
    String b =
        '${other.basename[0].toLowerCase()}${other.basename.substring(1)}';

    if (a == b) {
      return 0;
    }

    var _c = [a, b];
    _c.sort();
    if (_c[0] == a) {
      return -1;
    } else {
      return 1;
    }
  }
}
