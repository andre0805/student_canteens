import 'package:student_canteens/models/SCUser.dart';
import 'package:student_canteens/services/NotificationService.dart';
import 'package:student_canteens/services/StorageService.dart';
import 'package:student_canteens/utils/Constants.dart';
import 'package:student_canteens/utils/utils.dart';

class SessionManager {
  static final StorageService storageService = StorageService.sharedInstance;
  static final NotificationService notificationService =
      NotificationService.sharedInstance;

  static final SessionManager sharedInstance = SessionManager._();

  SessionManager._();

  SCUser? currentUser;

  Future<void> signIn(SCUser user) async {
    currentUser = user;

    if (user.city != null) {
      await storageService.saveString(Constants.userCityKey, user.city!);
    }

    if (user.lunchTime != null) {
      await notificationService.scheduleNotifications(
        Constants.notificationId,
        user.lunchTime!.hour,
        user.lunchTime!.minute,
        Utils.notificationTask,
      );
      print(
          "Scheduled notifications for lunch at ${user.lunchTime!.hour}:${user.lunchTime!.minute}");
    }
  }

  Future<void> signOut() async {
    currentUser = null;
    await storageService.removeKey(Constants.selectedCityKey);
    await storageService.removeKey(Constants.selectedDrawerItemIndexKey);
    await storageService.removeKey(Constants.selectedSortCriteriaKey);
    await storageService.removeKey(Constants.userCityKey);
    await notificationService.cancelNotifications(0);
  }
}
