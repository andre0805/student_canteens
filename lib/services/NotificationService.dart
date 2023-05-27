import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class NotificationService {
  static final NotificationService sharedInstance = NotificationService._();

  NotificationService._();

  Future<void> scheduleNotifications(
    int id,
    int hour,
    int minute,
    Function() callback,
  ) async {
    await AndroidAlarmManager.periodic(
      const Duration(days: 1),
      id,
      callback,
      startAt: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        hour,
        minute,
      ),
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  Future<void> cancelNotifications(int id) async {
    await AndroidAlarmManager.cancel(id);
  }
}
