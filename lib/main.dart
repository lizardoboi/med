import 'package:flutter/material.dart';
import 'package:med/domain/providers/medicine_provider.dart';
import 'package:med/domain/providers/missed_dose_provider.dart';
import 'package:med/domain/providers/profile_provider.dart';
import 'package:med/utils/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'theme/theme_provider.dart';
import 'routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initialize(navigatorKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),

        // MedicineProvider зависит от активного профиля
        ChangeNotifierProxyProvider<ProfileProvider, MedicineProvider>(
          create: (_) => MedicineProvider(),
          update: (_, profileProvider, medicineProvider) {
            medicineProvider ??= MedicineProvider();
            medicineProvider.setActiveProfile(profileProvider.activeProfile);
            return medicineProvider;
          },
        ),

        // MissedDoseProvider зависит от активного профиля
        ChangeNotifierProxyProvider<ProfileProvider, MissedDoseProvider>(
          create: (_) => MissedDoseProvider(),
          update: (_, profileProvider, missedDoseProvider) {
            missedDoseProvider ??= MissedDoseProvider();
            missedDoseProvider.setActiveProfile(profileProvider.activeProfile);
            return missedDoseProvider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

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
      navigatorKey: navigatorKey,
      title: 'Medication Reminder',
      theme: themeProvider.currentTheme,
      locale: themeProvider.locale,
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
