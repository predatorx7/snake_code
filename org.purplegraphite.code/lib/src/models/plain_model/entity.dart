import 'dart:io';
import 'package:path/path.dart' as path;

/// A FileSystemEntity wrapper
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

  static String _toLowercaseFirstChar(String string) {
    return "${string[0].toLowerCase()}${string.substring(1)}";
  }

  @override
  int compareTo(Entity other) {
    // Converting 1st char to lowercase
    String a = _toLowercaseFirstChar(this.basename);
    String b = _toLowercaseFirstChar(other.basename);

    if (a[0] == '.' || b[0] == '.') {
      if (a[0] == '.' && b[0] == '.') {
        a = _toLowercaseFirstChar(a.substring(1));
        b = _toLowercaseFirstChar(b.substring(1));
      } else if (a[0] == '.') {
        return 1;
      } else if (b[0] == '.') {
        return -1;
      }
    }

    if (a == b) return 0;
    var _c = [a, b];
    _c.sort();
    if (_c[0] == a) {
      return -1;
    } else {
      return 1;
    }
  }
}
