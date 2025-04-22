import 'package:flutter/material.dart';

class MedicineSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const MedicineSearchField({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Search Medicine',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    );
  }
}