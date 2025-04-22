import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/medicine_model.dart';
import '../../utils/notification_service.dart';
import '../../data/providers/medicine_provider.dart';
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

  Medicine? _existingMedicine;
  String? _selectedCondition;
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();
  bool _repeatDaily = false;

  final List<String> _conditions = [
    'До еды',
    'После еды',
    'Перед сном',
    'Утром',
  ];

  @override
  void initState() {
    super.initState();
    NotificationService.initialize();

    if (widget.medicine != null) {
      _existingMedicine = widget.medicine;
      _controller.text = _existingMedicine!.name;
      _selectedCondition = _existingMedicine!.condition;
      _selectedTime = _existingMedicine!.time;
      _selectedDate = _existingMedicine!.startDate;
      _repeatDaily = _existingMedicine!.repeatDaily; // ⚠️ используется repeatDaily
    }
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
    final name = _controller.text;

    if (name.isNotEmpty && _selectedCondition != null) {
      final isEditing = _existingMedicine != null;

      final int notificationId = isEditing
          ? _existingMedicine!.notificationId
          : DateTime.now().millisecondsSinceEpoch.remainder(100000);

      final updatedMedicine = Medicine(
        name: name,
        condition: _selectedCondition!,
        time: _selectedTime,
        startDate: _selectedDate,
        reminder: isEditing ? _existingMedicine!.reminder : true, // оставляем как было
        repeatDaily: _repeatDaily,
        notificationId: notificationId,
      );

      final medicineProvider = Provider.of<MedicineProvider>(context, listen: false);

      if (isEditing) {
        final originalIndex = medicineProvider.medicines.indexOf(_existingMedicine!);
        if (originalIndex != -1) {
          medicineProvider.updateMedicine(originalIndex, updatedMedicine);
        }
      } else {
        medicineProvider.addMedicine(updatedMedicine);
      }

      // Планируем уведомление только если reminder включён
      if (updatedMedicine.reminder) {
        await NotificationService.scheduleNotification(
          title: 'Напоминание о лекарстве',
          body: 'Пора принять: $name ($_selectedCondition)',
          time: _selectedTime,
          date: _selectedDate,
          id: notificationId,
          repeats: _repeatDaily,
        );
      }

      Navigator.pop(context, updatedMedicine);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _existingMedicine != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать лекарство' : 'Добавить лекарство'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Название лекарства',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              children: _conditions.map((condition) {
                return ConditionButton(
                  label: condition,
                  isActive: _selectedCondition == condition,
                  onChanged: (_) {
                    setState(() => _selectedCondition = condition);
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
              child: Text(isEditing ? 'Сохранить изменения' : 'Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
