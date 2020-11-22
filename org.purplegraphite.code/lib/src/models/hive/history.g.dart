// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileModificationHistoryAdapter
    extends TypeAdapter<FileModificationHistory> {
  @override
  final int typeId = 6;

  @override
  FileModificationHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FileModificationHistory()
      ..absolutePath = fields[1] as String
      ..lastModified = fields[2] as DateTime
      ..scrollOffset = fields[3] as double
      ..cursorOffset = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, FileModificationHistory obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.absolutePath)
      ..writeByte(2)
      ..write(obj.lastModified)
      ..writeByte(3)
      ..write(obj.scrollOffset)
      ..writeByte(4)
      ..write(obj.cursorOffset);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileModificationHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HistoryAdapter extends TypeAdapter<History> {
  @override
  final int typeId = 5;

  @override
  History read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return History()
      ..workspacePath = fields[1] as String
      ..lastModifiedFileDetails = fields[2] as FileModificationHistory
      ..lastModified = fields[3] as DateTime;
  }

  @override
  void write(BinaryWriter writer, History obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.workspacePath)
      ..writeByte(2)
      ..write(obj.lastModifiedFileDetails)
      ..writeByte(3)
      ..write(obj.lastModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
