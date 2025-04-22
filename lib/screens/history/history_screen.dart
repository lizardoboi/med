import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/missed_dose_provider.dart';  // Импортируйте провайдер

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Используем `Consumer` для доступа к MissedDoseProvider
    return Consumer<MissedDoseProvider>(
      builder: (context, missedDoseProvider, _) {
        final missedDoses = missedDoseProvider.missedDoses;

        return Scaffold(
          appBar: AppBar(
            title: const Text('История пропусков'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Переход на главный экран
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/', // Путь к главному экрану (укажите правильный маршрут)
                      (Route<dynamic> route) => false, // Удаляет все предыдущие маршруты
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  missedDoseProvider.clearHistory();
                },
              ),
            ],
          ),
          body: missedDoses.isEmpty
              ? const Center(child: Text('Нет пропущенных доз 🟢'))
              : ListView.builder(
            itemCount: missedDoses.length,
            itemBuilder: (context, index) {
              final dose = missedDoses[index];
              return ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: Text(dose.medicineName),
                subtitle: Text(
                  'Назначено: ${dose.scheduledTime.toLocal().toString().substring(0, 16)}',
                ),
              );
            },
          ),
        );
      },
    );
  }
}
