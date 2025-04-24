import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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

          ListTile(
            title: Text(loc.language),
            trailing: DropdownButton<String>(
              value: themeProvider.locale.languageCode,
              items: [
                DropdownMenuItem(value: 'en', child: Text(loc.english)),
                DropdownMenuItem(value: 'ru', child: Text(loc.russian)),
                DropdownMenuItem(value: 'fi', child: Text(loc.finnish)),
                DropdownMenuItem(value: 'es', child: Text(loc.spanish)),
              ],
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setLocale(Locale(value));
                }
              },
            ),
          ),

          ListTile(
            title: Text(loc.darkTheme),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (bool value) {
                themeProvider.setThemeMode(
                  value ? AppThemeMode.dark : AppThemeMode.light,
                );
              },
            ),
          ),

          ListTile(
            title: Text(loc.highContrast),
            trailing: Switch(
              value: themeProvider.isHighContrast,
              onChanged: (bool value) {
                themeProvider.setThemeMode(
                  value ? AppThemeMode.highContrast : AppThemeMode.light,
                );
              },
            ),
          ),

          ListTile(
            title: Text(loc.largeText),
            trailing: Switch(
              value: themeProvider.isLargeText,
              onChanged: (bool value) {
                themeProvider.setLargeText(value);
              },
            ),
          ),

          ListTile(
            title: Text(loc.hintsMode),
            trailing: Switch(
              value: themeProvider.isHintsEnabled,
              onChanged: (bool value) {
                themeProvider.setHintsEnabled(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
