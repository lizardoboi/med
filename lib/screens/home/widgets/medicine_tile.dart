import 'package:flutter/material.dart';
import 'package:med/domain/models/medicine_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final localizations = AppLocalizations.of(context)!;
    final formattedDate = medicine.startDate.toLocal().toString().split(' ')[0];
    final time = medicine.time.format(context);
    final dosageText = medicine.dosage.isNotEmpty ? ', ${medicine.dosage}' : '';

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
      child: GestureDetector(
        onLongPress: () {
          if (medicine.notes.isNotEmpty) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(medicine.name),
                content: Text(medicine.notes),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(localizations.okNotes),
                  ),
                ],
              ),
            );
          }
        },
        child: ListTile(
          title: Text(medicine.name),
          subtitle: Text(
            '${medicine.condition}, $time, $formattedDate$dosageText',
          ),
          trailing: Switch(
            value: medicine.reminder,
            onChanged: onReminderChanged,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}