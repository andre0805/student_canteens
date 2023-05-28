import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:student_canteens/utils/Constants.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService sharedInstance = NotificationService._();

  NotificationService._();

  Future<void> scheduleNotifications(
    int id,
    int hour,
    int minute,
    Function() callback,
  ) async {
    var now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    if (Platform.isAndroid) {
      await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        id,
        callback,
        startAt: scheduledDate,
        wakeup: true,
        rescheduleOnReboot: true,
        exact: true,
      );
    }

    if (Platform.isIOS) {
      const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
      const platformChannelSpecifics = NotificationDetails(
        iOS: iOSPlatformChannelSpecifics,
      );

      await FlutterLocalNotificationsPlugin().zonedSchedule(
        Constants.notificationId,
        'Hej! Vrijeme je za ručak! 🍽',
        'Provjeri stanje redova u menzama i odaberi najbolju opciju za sebe!',
        scheduledDate,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelNotifications(int id) async {
    if (Platform.isAndroid) {
      await AndroidAlarmManager.cancel(id);
    }

    if (Platform.isIOS) {
      await FlutterLocalNotificationsPlugin().cancel(id);
    }
  }
}
