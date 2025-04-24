import 'package:flutter/material.dart';
import '../models/missed_dose_model.dart';  // Убедитесь, что импортируете MissedDose

class MissedDoseProvider with ChangeNotifier {
  final List<MissedDose> _missedDoses = [];

  List<MissedDose> get missedDoses => _missedDoses;

  void addMissedDose(MissedDose dose) {
    _missedDoses.add(dose);
    notifyListeners();
  }

  void clearHistory() {
    _missedDoses.clear();
    notifyListeners();
  }
}
