// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missed_dose_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MissedDoseAdapter extends TypeAdapter<MissedDose> {
  @override
  final int typeId = 1;

  @override
  MissedDose read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MissedDose(
      medicineName: fields[0] as String,
      scheduledTime: fields[1] as DateTime,
      isTaken: fields[2] as bool,
      profileId: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MissedDose obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.medicineName)
      ..writeByte(1)
      ..write(obj.scheduledTime)
      ..writeByte(2)
      ..write(obj.isTaken)
      ..writeByte(3)
      ..write(obj.profileId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MissedDoseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
