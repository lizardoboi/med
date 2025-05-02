import 'package:flutter/material.dart';
import '../models/missed_dose_model.dart';  // Убедитесь, что импортируете MissedDose
import 'package:med/domain/models/profile_model.dart';

class MissedDoseProvider with ChangeNotifier {
  final List<MissedDose> _allDoses = [];
  Profile? _activeProfile;

  void setActiveProfile(Profile? profile) {
    _activeProfile = profile;
    notifyListeners();
  }

  List<MissedDose> get missedDoses {
    if (_activeProfile == null) return [];
    return _allDoses
        .where((dose) => dose.profileId == _activeProfile!.id)
        .toList();
  }

  void addMissedDose(MissedDose dose) {
    if (_activeProfile == null) return;
    _allDoses.add(dose.copyWith(profileId: _activeProfile!.id));
    notifyListeners();
  }

  void markDoseAsTaken(MissedDose dose) {
    final index = _allDoses.indexWhere((item) =>
    item.scheduledTime == dose.scheduledTime &&
        item.medicineName == dose.medicineName &&
        item.profileId == _activeProfile?.id);
    if (index != -1) {
      _allDoses[index] = _allDoses[index].copyWith(isTaken: true);
      notifyListeners();
    }
  }

  void markDoseAsMissed(MissedDose dose) {
    final index = _allDoses.indexWhere((item) =>
    item.scheduledTime == dose.scheduledTime &&
        item.medicineName == dose.medicineName &&
        item.profileId == _activeProfile?.id);
    if (index != -1) {
      _allDoses[index] = _allDoses[index].copyWith(isTaken: false);
      notifyListeners();
    }
  }

  void clearHistory() {
    _allDoses.removeWhere((dose) => dose.profileId == _activeProfile?.id);
    notifyListeners();
  }
}

