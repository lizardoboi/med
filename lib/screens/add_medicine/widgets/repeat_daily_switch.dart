import 'package:flutter/material.dart';

class RepeatDailySwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RepeatDailySwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Повторять ежедневно'),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}