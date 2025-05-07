import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:med/domain/models/medicine_model.dart';
import 'package:med/domain/providers/medicine_provider.dart';
import 'package:med/domain/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/notification_service.dart';
import 'widgets/condition_button.dart';
import 'widgets/date_picker_tile.dart';
import 'widgets/repeat_daily_switch.dart';
import 'widgets/time_picker_tile.dart';

class AddMedicineScreen extends StatefulWidget {
  final Medicine? medicine;

  const AddMedicineScreen({super.key, this.medicine});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  Medicine? _existingMedicine;
  List<String> _selectedConditions = []; // Изменяем на список
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();
  bool _repeatDaily = false;

  List<String> _conditions(BuildContext context) => [
    AppLocalizations.of(context)!.beforeMeal,
    AppLocalizations.of(context)!.afterMeal,
    AppLocalizations.of(context)!.beforeSleep,
    AppLocalizations.of(context)!.morning,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.medicine != null) {
      _existingMedicine = widget.medicine;
      _controller.text = _existingMedicine!.name;
      _dosageController.text = _existingMedicine!.dosage;
      _notesController.text = _existingMedicine!.notes;
      _selectedConditions = List.from(_existingMedicine!.condition.split(',')); // Изменяем на список
      _selectedTime = _existingMedicine!.time;
      _selectedDate = _existingMedicine!.startDate;
      _repeatDaily = _existingMedicine!.repeatDaily;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveMedicine() async {
    final name = _controller.text.trim();
    final dosage = _dosageController.text.trim();
    final notes = _notesController.text.trim();

    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final activeProfile = profileProvider.activeProfile;

    if (activeProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.noActiveProfile)),
      );
      return;
    }

    if (name.isNotEmpty && _selectedConditions.isNotEmpty) { // Убедитесь, что есть хотя бы одно выбранное условие
      final isEditing = _existingMedicine != null;

      final int notificationId = isEditing
          ? _existingMedicine!.notificationId
          : DateTime.now().millisecondsSinceEpoch.remainder(100000);

      final updatedMedicine = Medicine(
        name: name,
        condition: _selectedConditions.join(','), // Преобразуем список обратно в строку
        time: _selectedTime,
        startDate: _selectedDate,
        reminder: isEditing ? _existingMedicine!.reminder : true,
        repeatDaily: _repeatDaily,
        notificationId: notificationId,
        profileId: activeProfile.id,
        dosage: dosage,
        notes: notes,
      );

      final medicineProvider = Provider.of<MedicineProvider>(context, listen: false);

      if (isEditing) {
        final originalIndex =
        medicineProvider.medicines.indexOf(_existingMedicine!);
        if (originalIndex != -1) {
          medicineProvider.updateMedicine(originalIndex, updatedMedicine);
        }
      } else {
        medicineProvider.addMedicine(updatedMedicine);
      }

      if (updatedMedicine.reminder) {
        await NotificationService.scheduleNotification(
          title: AppLocalizations.of(context)!.reminderTitle,
          body: AppLocalizations.of(context)!.reminderBody(
            updatedMedicine.name,
            updatedMedicine.condition,
          ),
          time: _selectedTime,
          date: _selectedDate,
          id: notificationId,
          repeats: _repeatDaily,
        );
      }

      Navigator.pop(context, updatedMedicine);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseFillAllFields)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _existingMedicine != null;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing
            ? localizations.editMedicine
            : localizations.addMedicine),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: localizations.medicineName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _dosageController,
              decoration: InputDecoration(
                labelText: localizations.dosage,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: localizations.doctorNotes,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              children: _conditions(context).map((condition) {
                return ConditionButton(
                  label: condition,
                  isActive: _selectedConditions.contains(condition),
                  onChanged: (_) {
                    setState(() {
                      if (_selectedConditions.contains(condition)) {
                        _selectedConditions.remove(condition); // Удалить, если уже выбрано
                      } else {
                        _selectedConditions.add(condition); // Добавить, если не выбрано
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            TimePickerTile(
              selectedTime: _selectedTime,
              onTap: _pickTime,
            ),
            DatePickerTile(
              selectedDate: _selectedDate,
              onTap: _pickDate,
            ),
            const SizedBox(height: 16.0),
            RepeatDailySwitch(
              value: _repeatDaily,
              onChanged: (value) {
                setState(() {
                  _repeatDaily = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveMedicine,
              child: Text(isEditing
                  ? localizations.saveChanges
                  : localizations.create),
            ),
          ],
        ),
      ),
    );
  }
}
