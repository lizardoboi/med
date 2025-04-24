import 'package:flutter/material.dart';
import 'package:med/domain/providers/medicine_provider.dart';
import 'package:med/domain/providers/missed_dose_provider.dart';
import 'package:med/domain/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'theme/theme_provider.dart';
import 'routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // импорт локализаци

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
      locale: themeProvider.locale, // 👈 текущая выбранная локаль
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('fi'),
        Locale('es'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: Routes.mainScreen,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
