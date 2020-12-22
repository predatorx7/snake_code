import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'history.g.dart';

/// UNIMPLEMENTED for a list of open files
@HiveType(typeId: 6)
class FileModificationHistory extends HiveObject {
  @HiveField(1)
  final String absolutePath;
  @HiveField(2)
  DateTime lastModified;
  @HiveField(3)
  final double scrollOffset;
  @HiveField(4)
  final int cursorOffset;

  FileModificationHistory({
    this.absolutePath,
    this.scrollOffset,
    this.cursorOffset,
  });

  void setlatestModified() {
    lastModified = DateTime.now();
  }
}

@HiveType(typeId: 5)
class History extends HiveObject with Comparable<History> {
  @HiveField(1)
  final String workspacePath;

  @HiveField(2)
  FileModificationHistory lastModifiedFileDetails;

  @HiveField(3)
  DateTime lastModified;

  History({@required this.workspacePath});

  void updateLastModifiedDateTime() {
    lastModified = DateTime.now();
  }

  @override
  Future<void> save() async {
    updateLastModifiedDateTime();
    if (lastModifiedFileDetails != null) await lastModifiedFileDetails.save();
    return await super.save();
  }

  static bool compareByDate = true;

  @override
  int compareTo(History other) {
    if (compareByDate ?? true) {
      return this.lastModified.compareTo(other.lastModified);
    } else {
      return this.workspacePath.compareTo(other.workspacePath);
    }
  }
}
