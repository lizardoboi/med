import 'package:flutter/material.dart';
import 'package:med/data/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'theme/theme_provider.dart';
import 'data/providers/medicine_provider.dart';
import 'data/providers/missed_dose_provider.dart'; // Импортируем MissedDoseProvider
import 'routes.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => MedicineProvider()),
      ChangeNotifierProvider(create: (_) => MissedDoseProvider()), // Добавили MissedDoseProvider
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ],
    child: const MyApp(),
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  void _requestNotificationPermission() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Medication Reminder',
      theme: themeProvider.currentTheme,
      initialRoute: Routes.mainScreen,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
