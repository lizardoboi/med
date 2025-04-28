
class MissedDose {
  final String medicineName;
  final DateTime scheduledTime;
  bool isTaken; // Добавляем поле isTaken для отслеживания состояния

  MissedDose({
    required this.medicineName,
    required this.scheduledTime,
    this.isTaken = false, // по умолчанию считаем, что доза не принята
  });
}