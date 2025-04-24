import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MedicineSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const MedicineSearchField({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: localizations.searchMedicine,
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(),
      ),
    );
  }
}