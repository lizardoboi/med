import 'package:flutter/material.dart';
import 'package:med/domain/providers/missed_dose_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<MissedDoseProvider>(
      builder: (context, missedDoseProvider, _) {
        final missedDoses = missedDoseProvider.missedDoses;

        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.missedDoseHistory),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                      (Route<dynamic> route) => false,
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  missedDoseProvider.clearHistory();
                },
                tooltip: localizations.clearHistory,
              ),
            ],
          ),
          body: missedDoses.isEmpty
              ? Center(child: Text(localizations.noMissedDoses))
              : ListView.builder(
            itemCount: missedDoses.length,
            itemBuilder: (context, index) {
              final dose = missedDoses[index];
              return ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: Text(dose.medicineName),
                subtitle: Text(
                  '${localizations.scheduledAt}: ${dose.scheduledTime.toLocal().toString().substring(0, 16)}',
                ),
              );
            },
          ),
        );
      },
    );
  }
}
