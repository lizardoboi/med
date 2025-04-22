import 'package:flutter/material.dart';
import '../../../routes.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
      ],
      onTap: (index) async {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, Routes.historyScreen);
        } else if (index == 1) {
          await Navigator.pushNamed(
            context,
            Routes.addMedicineScreen,
          );
        }
      },
    );
  }
}
