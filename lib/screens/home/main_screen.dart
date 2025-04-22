import 'package:flutter/material.dart';
import 'package:med/data/models/medicine_model.dart';
import 'package:provider/provider.dart';
import '../../utils/notification_service.dart';
import '../../data/providers/medicine_provider.dart';
import '../home/widgets/custom_bottom_navigation_bar.dart';
import '../home/widgets/medicine_search_field.dart';
import '../home/widgets/medicine_tile.dart';
import '../../routes.dart'; // Убедись, что путь правильный

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.checkMissedNotifications(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);

    final filteredMedicines = medicineProvider.medicines.where((medicine) {
      return medicine.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Reminder'),
        leading: IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            Navigator.pushNamed(context, Routes.profileScreen);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, Routes.settingsScreen);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MedicineSearchField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: medicineProvider.medicines.isEmpty
                  ? const Center(child: Text('Нет записей о лекарствах'))
                  : filteredMedicines.isEmpty
                  ? const Center(child: Text('Лекарство не найдено'))
                  : ListView.builder(
                itemCount: filteredMedicines.length,
                itemBuilder: (context, index) {
                  final med = filteredMedicines[index];
                  final originalIndex =
                  medicineProvider.medicines.indexOf(med);

                  return MedicineTile(
                    medicine: med,
                    onReminderChanged: (val) async {
                      final updated = med.copyWith(reminder: val);
                      medicineProvider.updateMedicine(
                          originalIndex, updated);

                      if (val) {
                        await NotificationService.scheduleNotification(
                          title: 'Напоминание о лекарстве',
                          body:
                          'Пора принять: ${med.name} (${med.condition})',
                          time: med.time,
                          date: med.startDate,
                          id: med.notificationId,
                          repeats: med.reminder,
                        );
                      } else {
                        await NotificationService.cancelNotification(
                            med.notificationId);
                      }
                    },
                      onTap: () async {
                        final updatedMedicine = await Navigator.pushNamed(
                          context,
                          Routes.addMedicineScreen,
                          arguments: med,  // Передаем лекарство для редактирования
                        );

                        if (updatedMedicine != null && updatedMedicine is Medicine) {
                          // Обновляем существующую запись в Provider
                          final originalIndex = medicineProvider.medicines.indexOf(med);
                          if (originalIndex != -1) {
                            medicineProvider.updateMedicine(originalIndex, updatedMedicine); // Обновляем в списке
                          }
                        }
                      },
                    onDismissed: () async {
                      await NotificationService.cancelNotification(
                          med.notificationId);
                      medicineProvider.deleteMedicine(originalIndex);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Medicine deleted')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
