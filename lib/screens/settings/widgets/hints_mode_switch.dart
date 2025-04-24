import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HintsModeSwitch extends StatelessWidget {
  const HintsModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loc = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(loc.hintsMode),
      trailing: Switch(
        value: themeProvider.isHintsEnabled,
        onChanged: (bool value) {
          themeProvider.setHintsEnabled(value);
        },
      ),
    );
  }
}
