import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/models/QueueLength.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/StorageService.dart';
import 'package:student_canteens/utils/Constants.dart';

class Utils {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  static void showAlertDialog(
      BuildContext context, String title, String subtitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showAlertDialogWithActions(
    BuildContext context,
    String title,
    String subtitle,
    List<Widget> actions,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: actions,
        );
      },
    );
  }

  static void showAlertDialogWithCustomContent(
    BuildContext context,
    String title,
    Widget content,
    List<Widget> actions,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: content,
          actions: actions,
        );
      },
    );
  }

  static void showSnackBarMessage(BuildContext context, String message) {
    hideCurrentSnackBar(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static void showSnackBarMessageWithAction(
    BuildContext context,
    String message,
    String actionText,
    Function action,
  ) {
    hideCurrentSnackBar(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: actionText,
          onPressed: () => action(),
        ),
      ),
    );
  }

  static void hideCurrentSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  static void notificationTask() async {
    // Fetch data
    final canteens = await GCF.sharedInstance.getCanteens();
    final city =
        await StorageService.sharedInstance.getString(Constants.userCityKey);

    String notificationTitle;
    String notificationBody = "";

    if (city == null) return;

    // get canteens in city
    final List<Canteen> canteensInCity =
        canteens.where((canteen) => canteen.city == city).toList();
    final List<Canteen> shortestQueueCanteens = canteensInCity
        .where((element) => element.queueLength != QueueLength.UNKNOWN)
        .toList();
    shortestQueueCanteens.sort(
        (a, b) => QueueLengthExtension.compare(a.queueLength, b.queueLength));

    if (shortestQueueCanteens.isEmpty) {
      notificationTitle = "Hej! Vrijeme je za ručak! 🍽";
      notificationBody =
          "Nažalost, trenutno nemamo dostupnih informacija o redovima u menzama, ali svakako navrati kasnije i provjeri stanje u menzama.";
    } else if (shortestQueueCanteens.length == 1) {
      notificationTitle = "Hej! Vrijeme je za ručak! 🍽";
      notificationBody =
          "Trenutno imamo samo informaciju o stanju reda u menzi ${shortestQueueCanteens[0].name}: ${QueueLengthExtension.getLegendDescription(shortestQueueCanteens[0].queueLength)}.";
    } else {
      notificationTitle =
          "Hej! Vrijeme je za ručak! 🍽 Pogledaj dostupne opcije.";
      notificationBody += "Najkraći redovi su u menzama:";
      for (Canteen c in shortestQueueCanteens.sublist(
          0, min(3, shortestQueueCanteens.length))) {
        notificationBody +=
            " ${c.name} - ${QueueLengthExtension.getLegendDescription(c.queueLength)}";
        if (c != shortestQueueCanteens.last) {
          notificationBody += ", ";
        }
      }
    }

    // Show notification with the data
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      styleInformation: BigTextStyleInformation(''),
    );
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await FlutterLocalNotificationsPlugin().show(
      0,
      notificationTitle,
      notificationBody,
      platformChannelSpecifics,
    );
  }
}
