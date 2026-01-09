// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReferenceAdapter extends TypeAdapter<Reference> {
  @override
  final int typeId = 1;

  @override
  Reference read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reference(
      name: fields[0] as String,
      tags: (fields[1] as List).cast<String>(),
      description: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Reference obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.tags)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReferenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
