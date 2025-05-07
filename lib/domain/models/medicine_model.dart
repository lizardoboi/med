import 'package:flutter/material.dart';

class Medicine {
  final String name;
  final String condition;
  final TimeOfDay time;
  final DateTime startDate;
  final bool reminder;
  final bool repeatDaily;
  final int notificationId;
  final String profileId;
  final String dosage;
  final String notes;

  Medicine({
    required this.name,
    required this.condition,
    required this.time,
    required this.startDate,
    required this.reminder,
    required this.repeatDaily,
    required this.notificationId,
    required this.profileId,
    this.dosage = '',
    this.notes = '',
  });

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
