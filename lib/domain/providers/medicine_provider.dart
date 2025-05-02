import 'package:flutter/material.dart';
import 'package:med/domain/models/medicine_model.dart';
import 'package:med/domain/models/profile_model.dart';

class MedicineProvider with ChangeNotifier {
  final List<Medicine> _allMedicines = [];
  Profile? _activeProfile;

  void setActiveProfile(Profile? profile) {
    _activeProfile = profile;
    notifyListeners();
  }

  List<Medicine> get medicines {
    if (_activeProfile == null) return [];
    return _allMedicines
        .where((m) => m.profileId == _activeProfile!.id)
        .toList();
  }

  void addMedicine(Medicine medicine) {
    if (_activeProfile == null) return;
    _allMedicines.add(
      medicine.copyWith(profileId: _activeProfile!.id),
    );
    notifyListeners();
  }

  void updateMedicine(int index, Medicine updatedMedicine) {
    _allMedicines[index] = updatedMedicine;
    notifyListeners();
  }

  void deleteMedicine(int index) {
    _allMedicines.removeAt(index);
    notifyListeners();
  }
}