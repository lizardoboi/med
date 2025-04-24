import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        Text(localizations.repeatDaily), // Локализованная строка
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
