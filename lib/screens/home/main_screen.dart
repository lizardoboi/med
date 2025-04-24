import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:med/domain/models/medicine_model.dart';
import 'package:med/domain/providers/medicine_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/notification_service.dart';
import '../home/widgets/custom_bottom_navigation_bar.dart';
import '../home/widgets/medicine_search_field.dart';
import '../home/widgets/medicine_tile.dart';
import '../../routes.dart';

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
    final loc = AppLocalizations.of(context)!;
    final medicineProvider = Provider.of<MedicineProvider>(context);
    final filteredMedicines = medicineProvider.medicines.where((medicine) {
      return medicine.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
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
                  ? Center(child: Text(loc.noMedicineRecords))
                  : filteredMedicines.isEmpty
                  ? Center(child: Text(loc.medicineNotFound))
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
                      medicineProvider.updateMedicine(originalIndex, updated);

                      if (val) {
                        await NotificationService.scheduleNotification(
                          title: loc.reminderTitle,
                          body: loc.reminderBody(med.name, med.condition),
                          time: med.time,
                          date: med.startDate,
                          id: med.notificationId,
                          repeats: med.reminder,
                        );
                      } else {
                        await NotificationService.cancelNotification(med.notificationId);
                      }
                    },
                    onTap: () async {
                      final updatedMedicine = await Navigator.pushNamed(
                        context,
                        Routes.addMedicineScreen,
                        arguments: med,
                      );

                      if (updatedMedicine != null && updatedMedicine is Medicine) {
                        final originalIndex = medicineProvider.medicines.indexOf(med);
                        if (originalIndex != -1) {
                          medicineProvider.updateMedicine(originalIndex, updatedMedicine);
                        }
                      }
                    },
                    onDismissed: () async {
                      await NotificationService.cancelNotification(med.notificationId);
                      medicineProvider.deleteMedicine(originalIndex);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.medicineDeleted)),
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
