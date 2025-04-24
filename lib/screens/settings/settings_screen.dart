import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/hints_mode_switch.dart';
import 'widgets/language_settings.dart';
import 'widgets/large_text_switch.dart';
import 'widgets/theme_switch.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            loc.appPreferences,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Используем виджеты для отображения настроек
          LanguageSetting(),
          ThemeSwitch(),
          LargeTextSwitch(),
          HintsModeSwitch(),
        ],
      ),
    );
  }
}
