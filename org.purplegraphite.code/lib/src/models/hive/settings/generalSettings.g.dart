// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generalSettings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeneralSettingsAdapter extends TypeAdapter<GeneralSettings> {
  @override
  final int typeId = 1;

  @override
  GeneralSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
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

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
