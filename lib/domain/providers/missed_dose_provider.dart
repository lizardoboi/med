import 'package:flutter/material.dart';
import '../models/missed_dose_model.dart';  // Убедитесь, что импортируете MissedDose

class MissedDoseProvider with ChangeNotifier {
  final List<MissedDose> _missedDoses = [];

  List<MissedDose> get missedDoses => _missedDoses;

  // Добавляем пропущенную дозу в список
  void addMissedDose(MissedDose dose) {
    _missedDoses.add(dose);
    notifyListeners();
  }

  // Очищаем историю
  void clearHistory() {
    _missedDoses.clear();
    notifyListeners();
  }

  // Метод для отметки дозы как принятой
  void markDoseAsTaken(MissedDose dose) {
    final index = _missedDoses.indexWhere((item) => item.scheduledTime == dose.scheduledTime && item.medicineName == dose.medicineName);
    if (index != -1) {
      _missedDoses[index].isTaken = true;
      notifyListeners();
    }
  }

  // Метод для отметки дозы как пропущенной
  void markDoseAsMissed(MissedDose dose) {
    final index = _missedDoses.indexWhere((item) => item.scheduledTime == dose.scheduledTime && item.medicineName == dose.medicineName);
    if (index != -1) {
      _missedDoses[index].isTaken = false;
      notifyListeners();
    }
  }
}
