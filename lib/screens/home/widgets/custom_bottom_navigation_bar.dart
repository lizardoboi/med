import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../routes.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.history),
          label: localizations.history,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.add),
          label: localizations.add,
        ),
      ],
      onTap: (index) async {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, Routes.historyScreen);
        } else if (index == 1) {
          await Navigator.pushNamed(context, Routes.addMedicineScreen);
        }
      },
    );
  }
}