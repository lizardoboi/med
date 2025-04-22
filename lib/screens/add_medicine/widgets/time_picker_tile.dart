import 'package:flutter/material.dart';

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
    return ListTile(
      title: const Text('Время приёма'),
      subtitle: Text(selectedTime.format(context)),
      trailing: IconButton(
        icon: const Icon(Icons.access_time),
        onPressed: onTap,
      ),
    );
  }
}