import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'medicine_model.g.dart';

@HiveType(typeId: 0)
class Medicine extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String condition;

  @HiveField(2)
  final int hour;

  @HiveField(3)
  final int minute;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final bool reminder;

  @HiveField(6)
  final bool repeatDaily;

  @HiveField(7)
  final int notificationId;

  @HiveField(8)
  final String profileId;

  @HiveField(9)
  final String dosage;

  @HiveField(10)
  final String notes;

  Medicine({
    required this.name,
    required this.condition,
    required TimeOfDay time,
    required this.startDate,
    required this.reminder,
    required this.repeatDaily,
    required this.notificationId,
    required this.profileId,
    this.dosage = '',
    this.notes = '',
  })  : hour = time.hour,
        minute = time.minute;

  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);

  Medicine copyWith({
    String? name,
    String? condition,
    TimeOfDay? time,
    DateTime? startDate,
    bool? reminder,
    bool? repeatDaily,
    int? notificationId,
    String? profileId,
    String? dosage,
    String? notes,
  }) {
    return Medicine(
      name: name ?? this.name,
      condition: condition ?? this.condition,
      time: time ?? this.time,
      startDate: startDate ?? this.startDate,
      reminder: reminder ?? this.reminder,
      repeatDaily: repeatDaily ?? this.repeatDaily,
      notificationId: notificationId ?? this.notificationId,
      profileId: profileId ?? this.profileId,
      dosage: dosage ?? this.dosage,
      notes: notes ?? this.notes,
    );
  }
}