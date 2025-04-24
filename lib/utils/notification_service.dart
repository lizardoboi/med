import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:med/domain/models/missed_dose_model.dart';
import 'package:med/domain/providers/missed_dose_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tzdata;


class NotificationService {
  static Future<void> initialize() async {
    tzdata.initializeTimeZones();

    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'medicine_channel',
          channelName: 'Medicine Reminders',
          channelDescription: 'Напоминания о приёме лекарств',
          defaultColor: Colors.teal,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ],
    );
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required TimeOfDay time,
    required DateTime date,
    required bool repeats, // <-- Добавлено
    int? id,
  }) async {
    final now = DateTime.now();

    DateTime scheduledDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Если время в прошлом — переносим на следующий день
    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'medicine_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        payload: {
          'name': title,
          'time': scheduledDateTime.toIso8601String(),
        },
      ),
      schedule: NotificationCalendar(
        year: scheduledDateTime.year,
        month: scheduledDateTime.month,
        day: scheduledDateTime.day,
        hour: scheduledDateTime.hour,
        minute: scheduledDateTime.minute,
        second: 0,
        millisecond: 0,
        repeats: repeats, // <-- Добавлено
        allowWhileIdle: true,
      ),
    );
  }

  static Future<void> cancelNotification(int notificationId) async {
    await AwesomeNotifications().cancel(notificationId);
  }

  /// 🔍 Проверка пропущенных уведомлений
  static Future<void> checkMissedNotifications(BuildContext context) async {
    final now = DateTime.now();
    final notifications = await AwesomeNotifications().listScheduledNotifications();

    for (final notification in notifications) {
      final payload = notification.content?.payload;
      if (payload == null) continue;

      final name = payload['name'];
      final timeStr = payload['time'];
      if (name == null || timeStr == null) continue;

      final scheduledTime = DateTime.tryParse(timeStr);
      if (scheduledTime == null) continue;

      final bool isMissed = now.isAfter(scheduledTime.add(const Duration(minutes: 10)));

      if (isMissed) {
        // Добавляем пропущенную дозу
        Provider.of<MissedDoseProvider>(context, listen: false).addMissedDose(
          MissedDose(
            medicineName: name,
            scheduledTime: scheduledTime,
          ),
        );

        // Отменяем старое уведомление
        final id = notification.content?.id;
        if (id != null) {
          await cancelNotification(id);
        }
      }
    }
  }
}
