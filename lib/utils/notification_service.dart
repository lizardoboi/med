import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:med/domain/models/missed_dose_model.dart';
import 'package:med/domain/providers/missed_dose_provider.dart';
import 'package:med/domain/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class NotificationService {
  static late GlobalKey<NavigatorState> navigatorKey;

  static Future<void> initialize(GlobalKey<NavigatorState> key) async {
    navigatorKey = key;

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

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      print('Context is null');
      return;
    }

    final payload = receivedAction.payload;
    if (payload == null) return;

    final name = payload['name'];
    final timeStr = payload['time'];
    if (name == null || timeStr == null) return;

    final scheduledTime = DateTime.tryParse(timeStr);
    if (scheduledTime == null) return;

    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final activeProfile = profileProvider.activeProfile;
    if (activeProfile == null) {
      print('No active profile set');
      return;
    }

    final missedDoseProvider = Provider.of<MissedDoseProvider>(context, listen: false);

    final dose = MissedDose(
      medicineName: name,
      scheduledTime: scheduledTime,
      isTaken: receivedAction.buttonKeyPressed == 'TAKEN',
      profileId: activeProfile.id,
    );

    missedDoseProvider.addMissedDose(dose);

    print('${dose.isTaken ? 'Dose taken' : 'Dose not taken'}: $name at $scheduledTime');
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required TimeOfDay time,
    required DateTime date,
    required bool repeats,
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
      actionButtons: [
        NotificationActionButton(
          key: 'TAKEN',
          label: 'Принял',
        ),
        NotificationActionButton(
          key: 'NOT_TAKEN',
          label: 'Не принял',
        ),
      ],
      schedule: NotificationCalendar(
        year: scheduledDateTime.year,
        month: scheduledDateTime.month,
        day: scheduledDateTime.day,
        hour: scheduledDateTime.hour,
        minute: scheduledDateTime.minute,
        second: 0,
        millisecond: 0,
        repeats: repeats,
        allowWhileIdle: true,
      ),
    );
  }

  static Future<void> checkMissedNotifications(BuildContext context) async {
    final now = DateTime.now();
    final notifications = await AwesomeNotifications().listScheduledNotifications();

    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final activeProfile = profileProvider.activeProfile;
    if (activeProfile == null) return;

    final missedDoseProvider = Provider.of<MissedDoseProvider>(context, listen: false);

    for (final notification in notifications) {
      final payload = notification.content?.payload;
      if (payload == null) continue;

      final name = payload['name'];
      final timeStr = payload['time'];
      if (name == null || timeStr == null) continue;

      final scheduledTime = DateTime.tryParse(timeStr);
      if (scheduledTime == null) continue;

      final isMissed = now.isAfter(scheduledTime.add(const Duration(seconds: 1)));
      if (isMissed) {
        print('Missed dose: $name at $scheduledTime');

        final missedDose = MissedDose(
          medicineName: name,
          scheduledTime: scheduledTime,
          isTaken: false,
          profileId: activeProfile.id,
        );

        missedDoseProvider.addMissedDose(missedDose);

        final id = notification.content?.id;
        if (id != null) {
          await cancelNotification(id);
        }
      }
    }
  }

  static Future<void> cancelNotification(int notificationId) async {
    await AwesomeNotifications().cancel(notificationId);
  }
}
