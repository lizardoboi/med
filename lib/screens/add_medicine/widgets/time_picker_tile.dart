import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimePickerTile extends StatelessWidget {
  final TimeOfDay selectedTime;
  final VoidCallback onTap;

  const TimePickerTile({
    super.key,
    required this.selectedTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(localizations.timeOfDay), // Переведено на локализованный текст
      subtitle: Text(selectedTime.format(context)),
      trailing: IconButton(
        icon: const Icon(Icons.access_time),
        onPressed: onTap,
      ),
    );
  }
}
