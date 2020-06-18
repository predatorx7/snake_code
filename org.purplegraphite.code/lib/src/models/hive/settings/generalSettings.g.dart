// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generalSettings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeneralSettingsAdapter extends TypeAdapter<GeneralSettings> {
  @override
  final typeId = 1;

  @override
  GeneralSettings read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeneralSettings().._debuggingEnabled = fields[1] as bool;
  }

  @override
  void write(BinaryWriter writer, GeneralSettings obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj._debuggingEnabled);
  }
}
