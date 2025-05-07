// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineAdapter extends TypeAdapter<Medicine> {
  @override
  final int typeId = 0;

  @override
  Medicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medicine(
      name: fields[0] as String,
      condition: fields[1] as String,
      time: TimeOfDay(hour: fields[2] as int, minute: fields[3] as int), // Восстановление TimeOfDay
      startDate: fields[4] as DateTime,
      reminder: fields[5] as bool,
      repeatDaily: fields[6] as bool,
      notificationId: fields[7] as int,
      profileId: fields[8] as String,
      dosage: fields[9] as String,
      notes: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Medicine obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.condition)
      ..writeByte(2)
      ..write(obj.hour) // Сохраняем hour
      ..writeByte(3)
      ..write(obj.minute) // Сохраняем minute
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.reminder)
      ..writeByte(6)
      ..write(obj.repeatDaily)
      ..writeByte(7)
      ..write(obj.notificationId)
      ..writeByte(8)
      ..write(obj.profileId)
      ..writeByte(9)
      ..write(obj.dosage)
      ..writeByte(10)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MedicineAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}