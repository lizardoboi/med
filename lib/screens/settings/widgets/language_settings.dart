import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSetting extends StatelessWidget {
  const LanguageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loc = AppLocalizations.of(context)!;

    return ListTile(
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
    );
  }
}