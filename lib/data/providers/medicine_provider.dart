import 'package:flutter/material.dart';
import '/data/models/medicine_model.dart';

class MedicineProvider with ChangeNotifier {
  final List<Medicine> _medicines = [];

  List<Medicine> get medicines => _medicines;

  void addMedicine(Medicine medicine) {
    _medicines.add(medicine);
    notifyListeners();
  }

  void updateMedicine(int index, Medicine updatedMedicine) {
    _medicines[index] = updatedMedicine;
    notifyListeners();
  }

  void deleteMedicine(int index) {
    _medicines.removeAt(index);
    notifyListeners();
  }
}
