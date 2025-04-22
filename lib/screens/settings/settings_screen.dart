import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'App Preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          /// 🔘 Language Selector
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: themeProvider.locale.languageCode,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ru', child: Text('Русский')),
              ],
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setLocale(Locale(value));
                }
              },
            ),
          ),

          /// 🌙 Dark Theme
          ListTile(
            title: const Text('Dark Theme'),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (bool value) {
                themeProvider.setThemeMode(
                  value ? AppThemeMode.dark : AppThemeMode.light,
                );
              },
            ),
          ),

          /// ⚫ High Contrast
          ListTile(
            title: const Text('High Contrast Theme'),
            trailing: Switch(
              value: themeProvider.isHighContrast,
              onChanged: (bool value) {
                themeProvider.setThemeMode(
                  value ? AppThemeMode.highContrast : AppThemeMode.light,
                );
              },
            ),
          ),

          /// 🔠 Large Buttons & Text
          ListTile(
            title: const Text('Large Buttons & Text'),
            trailing: Switch(
              value: themeProvider.isLargeText,
              onChanged: (bool value) {
                themeProvider.setLargeText(value);
              },
            ),
          ),

          /// 💡 Hints Mode
          ListTile(
            title: const Text('Hints Mode'),
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
