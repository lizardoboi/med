import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/missed_dose_model.dart';
import '../models/profile_model.dart';

class MissedDoseProvider with ChangeNotifier {
  late final Box<MissedDose> _box;
  Profile? _activeProfile;

  MissedDoseProvider() {
    _box = Hive.box<MissedDose>('missed_doses');
  }

  void setActiveProfile(Profile? profile) {
    _activeProfile = profile;
    notifyListeners();
  }

  List<MissedDose> get missedDoses {
    if (_activeProfile == null) return [];
    return _box.values
        .where((dose) => dose.profileId == _activeProfile!.id)
        .toList();
  }

  void addMissedDose(MissedDose dose) {
    if (_activeProfile == null) return;
    _box.add(dose.copyWith(profileId: _activeProfile!.id));
    notifyListeners();
  }

  void markDoseAsTaken(MissedDose dose) {
    final key = _box.keys.firstWhere(
          (k) {
        final item = _box.get(k);
        return item != null &&
            item.scheduledTime == dose.scheduledTime &&
            item.medicineName == dose.medicineName &&
            item.profileId == _activeProfile?.id;
      },
      orElse: () => null,
    );

    if (key != null) {
      final updated = dose.copyWith(isTaken: true);
      _box.put(key, updated);
      notifyListeners();
    }
  }

  void markDoseAsMissed(MissedDose dose) {
    final key = _box.keys.firstWhere(
          (k) {
        final item = _box.get(k);
        return item != null &&
            item.scheduledTime == dose.scheduledTime &&
            item.medicineName == dose.medicineName &&
            item.profileId == _activeProfile?.id;
      },
      orElse: () => null,
    );

    if (key != null) {
      final updated = dose.copyWith(isTaken: false);
      _box.put(key, updated);
      notifyListeners();
    }
  }

  void clearHistory() {
    final keysToRemove = _box.keys.where((k) {
      final dose = _box.get(k);
      return dose?.profileId == _activeProfile?.id;
    }).toList();

    for (var k in keysToRemove) {
      _box.delete(k);
    }

    notifyListeners();
  }
}