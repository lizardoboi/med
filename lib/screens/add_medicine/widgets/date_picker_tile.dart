import 'package:flutter/material.dart';

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
    return ListTile(
      title: const Text('Дата начала'),
      subtitle: Text('${selectedDate.toLocal()}'.split(' ')[0]),
      trailing: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: onTap,
      ),
    );
  }
}