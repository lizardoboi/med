import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LargeTextSwitch extends StatelessWidget {
  const LargeTextSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loc = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(loc.largeText),
      trailing: Switch(
        value: themeProvider.isLargeText,
        onChanged: (bool value) {
          themeProvider.setLargeText(value);
        },
      ),
    );
  }
}
