import 'package:flutter/material.dart';
import 'package:med/domain/models/medicine_model.dart';
import 'medicine_tile.dart';

class MedicineListView extends StatelessWidget {
  final List<Medicine> medicines;
  final Function(int index, bool val) onReminderChanged;
  final Function(int index) onTap;
  final Function(int index) onDismissed;

  const MedicineListView({
    super.key,
    required this.medicines,
    required this.onReminderChanged,
    required this.onTap,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          return MedicineTile(
            medicine: medicines[index],
            onReminderChanged: (val) => onReminderChanged(index, val),
            onTap: () => onTap(index),
            onDismissed: () => onDismissed(index),
          );
        },
      ),
    );
  }
}