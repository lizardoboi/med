import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DatePickerTile extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onTap;

  const DatePickerTile({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(localizations.startDate), // Локализованная строка
      subtitle: Text('${selectedDate.toLocal()}'.split(' ')[0]),
      trailing: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: onTap,
      ),
    );
  }
}
