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

        // Разделение на принятые и непринятые дозы
        final takenDoses = missedDoses.where((dose) => dose.isTaken).toList();
        final notTakenDoses = missedDoses.where((dose) => !dose.isTaken).toList();

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
              : ListView(
            children: [
              if (takenDoses.isNotEmpty)
                ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      localizations.takenDoses, // Заголовок для принятых доз
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: takenDoses.length,
                    itemBuilder: (context, index) {
                      final dose = takenDoses[index];
                      return ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.green),
                        title: Text(dose.medicineName),
                        subtitle: Text(
                          '${localizations.scheduledAt}: ${dose.scheduledTime.toLocal().toString().substring(0, 16)}',
                        ),
                      );
                    },
                  ),
                ],
              if (notTakenDoses.isNotEmpty)
                ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      localizations.notTakenDoses, // Заголовок для непринятых доз
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: notTakenDoses.length,
                    itemBuilder: (context, index) {
                      final dose = notTakenDoses[index];
                      return ListTile(
                        leading: const Icon(Icons.warning, color: Colors.red),
                        title: Text(dose.medicineName),
                        subtitle: Text(
                          '${localizations.scheduledAt}: ${dose.scheduledTime.toLocal().toString().substring(0, 16)}',
                        ),
                      );
                    },
                  ),
                ],
            ],
          ),
        );
      },
    );
  }
}