import 'package:flutter/material.dart';
import 'package:med/screens/history/history_screen.dart';
import 'data/models/medicine_model.dart';
import 'screens/home/main_screen.dart';
import 'screens/add_medicine/add_medicine_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/profile/profile_screen.dart';

class Routes {
  static const String mainScreen = '/';
  static const String addMedicineScreen = '/addMedicine';
  static const String settingsScreen = '/settings';
  static const String profileScreen = '/profile';
  static const String historyScreen = '/history';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainScreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case addMedicineScreen:
      // Передаем аргументы в AddMedicineScreen, если они есть
        final medicine = settings.arguments as Medicine?;
        return MaterialPageRoute(
          builder: (_) => AddMedicineScreen(medicine: medicine),
        );
      case settingsScreen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case historyScreen:
        return MaterialPageRoute(builder:  (_) => const HistoryScreen());
      default:
        return MaterialPageRoute(builder: (_) => const MainScreen());
    }
  }
}