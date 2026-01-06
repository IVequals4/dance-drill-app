// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drill.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DrillAdapter extends TypeAdapter<Drill> {
  @override
  final int typeId = 0;

  @override
  Drill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Drill(
      name: fields[0] as String,
      list: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Drill obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
