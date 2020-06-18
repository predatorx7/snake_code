// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'themeSettings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeSettingsAdapter extends TypeAdapter<ThemeSettings> {
  @override
  final typeId = 2;

  @override
  ThemeSettings read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
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
}
