import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:med/domain/models/medicine_model.dart';
import 'package:med/domain/models/profile_model.dart';

class MedicineProvider with ChangeNotifier {
  late final Box<Medicine> _box;
  Profile? _activeProfile;

  MedicineProvider() {
    _box = Hive.box<Medicine>('medicines');
  }

  void setActiveProfile(Profile? profile) {
    _activeProfile = profile;
    notifyListeners();
  }

  List<Medicine> get medicines {
    if (_activeProfile == null) return [];
    return _box.values
        .where((m) => m.profileId == _activeProfile!.id)
        .toList();
  }

  void addMedicine(Medicine medicine) {
    if (_activeProfile == null) return;
    _box.add(medicine.copyWith(profileId: _activeProfile!.id));
    notifyListeners();
  }

  void updateMedicine(int index, Medicine updatedMedicine) {
    final key = _box.keyAt(index);
    _box.put(key, updatedMedicine);
    notifyListeners();
  }

  void deleteMedicine(int index) {
    final key = _box.keyAt(index);
    _box.delete(key);
    notifyListeners();
  }
}