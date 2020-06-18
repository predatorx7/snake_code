// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryAdapter extends TypeAdapter<History> {
  @override
  final typeId = 5;

  @override
  History read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return History()
      ..workspacePath = fields[1] as String
      ..lastOpenFile = fields[2] as String
      ..lineNumber = fields[3] as int
      ..columnNumber = fields[4] as int
      ..lastModified = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, History obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.workspacePath)
      ..writeByte(2)
      ..write(obj.lastOpenFile)
      ..writeByte(3)
      ..write(obj.lineNumber)
      ..writeByte(4)
      ..write(obj.columnNumber)
      ..writeByte(5)
      ..write(obj.lastModified);
  }
}
