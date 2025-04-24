import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Dark theme
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

        // High contrast theme
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
      ],
    );
  }
}
