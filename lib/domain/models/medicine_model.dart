import 'package:flutter/material.dart';

class Medicine {
  final String name;
  final String condition;
  final TimeOfDay time;
  final DateTime startDate;
  final bool reminder;       // включено ли уведомление
  final bool repeatDaily;    // повторять ли каждый день
  final int notificationId;

  Medicine({
    required this.name,
    required this.condition,
    required this.time,
    required this.startDate,
    this.reminder = true,
    this.repeatDaily = false,           // по умолчанию false
    required this.notificationId,
  });

  Medicine copyWith({
    String? name,
    String? condition,
    TimeOfDay? time,
    DateTime? startDate,
    bool? reminder,
    bool? repeatDaily,
    int? notificationId,
  }) {
    return Medicine(
      name: name ?? this.name,
      condition: condition ?? this.condition,
      time: time ?? this.time,
      startDate: startDate ?? this.startDate,
      reminder: reminder ?? this.reminder,
      repeatDaily: repeatDaily ?? this.repeatDaily,
      notificationId: notificationId ?? this.notificationId,
    );
  }
}
