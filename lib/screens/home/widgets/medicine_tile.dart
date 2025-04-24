import 'package:flutter/material.dart';
import 'package:med/domain/models/medicine_model.dart';


class MedicineTile extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onTap;
  final ValueChanged<bool> onReminderChanged;
  final VoidCallback onDismissed;

  const MedicineTile({
    super.key,
    required this.medicine,
    required this.onTap,
    required this.onReminderChanged,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(medicine.name + medicine.startDate.toIso8601String()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDismissed(),
      child: ListTile(
        title: Text(medicine.name),
        subtitle: Text(
          '${medicine.condition}, '
              'в ${medicine.time.format(context)}, '
              '${medicine.startDate.toLocal().toString().split(' ')[0]}',
        ),
        trailing: Switch(
          value: medicine.reminder,
          onChanged: onReminderChanged,
        ),
        onTap: onTap,
      ),
    );
  }
}