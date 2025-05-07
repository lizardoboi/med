import 'package:hive/hive.dart';

part 'missed_dose_model.g.dart';

@HiveType(typeId: 1)
class MissedDose extends HiveObject {
  @HiveField(0)
  final String medicineName;

  @HiveField(1)
  final DateTime scheduledTime;

  @HiveField(2)
  final bool isTaken;

  @HiveField(3)
  final String profileId;

  MissedDose({
    required this.medicineName,
    required this.scheduledTime,
    this.isTaken = false,
    required this.profileId,
  });

  MissedDose copyWith({
    String? medicineName,
    DateTime? scheduledTime,
    bool? isTaken,
    String? profileId,
  }) {
    return MissedDose(
      medicineName: medicineName ?? this.medicineName,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isTaken: isTaken ?? this.isTaken,
      profileId: profileId ?? this.profileId,
    );
  }
}