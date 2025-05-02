
class MissedDose {
  final String medicineName;
  final DateTime scheduledTime;
  final bool isTaken;
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