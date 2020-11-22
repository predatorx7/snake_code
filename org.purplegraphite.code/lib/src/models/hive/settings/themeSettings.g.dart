// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'themeSettings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeSettingsAdapter extends TypeAdapter<ThemeSettings> {
  @override
  final int typeId = 2;

  @override
  ThemeSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeSettings(
      fields[1] as int,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeSettings obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.themeChoice)
      ..writeByte(2)
      ..write(obj.themeModeS);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
