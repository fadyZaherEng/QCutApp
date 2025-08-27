import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //initial notification with android and ios

  static Future<void> init() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
    );
  }

  static void onTap(NotificationResponse notificationResponse) {
    // navigator
    if (int.parse(notificationResponse.payload.toString()) != -1) {
      // sl<GlobalKey<NavigatorState>>().currentState!.context.pushName(
      //       AppRoutes.productDetails,
      //       arguments: int.parse(notificationResponse.payload.toString()),
      //     );
    }
  }

  // static Future<void> showSimpleNotification({
  //   required String title,
  //   required String body,
  //   required String payload,
  // }) async {
  //   const notificationDetails = NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       'asroo-id',
  //       'asroo-name',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //     ),
  //     iOS: DarwinNotificationDetails(
  //       presentAlert: true,
  //       presentBadge: true,
  //       presentSound: true,
  //     ),
  //   );
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     title,
  //     body,
  //     notificationDetails,
  //     payload: payload,
  //   );
  // }
  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    // Match "dd-mm-yyyy hh:mm"
    final regex = RegExp(r'(\d{2}-\d{2}-\d{4})\s+(\d{2}:\d{2})');
    final match = regex.firstMatch(payload);

    if (match != null) {
      final date = match.group(1); // "28-08-2025"
      final time = match.group(2); // "16:30"

      // باقي النص (من غير التاريخ والوقت)
      final restOfText = payload.replaceAll(regex, "").trim();
      print("Date: $date, Time: $time, Rest: $restOfText");

      final bigTextStyle = BigTextStyleInformation(
        "$restOfText\n🗓 $date   ⏰ $time", // نخلي التاريخ والوقت أوضح
        htmlFormatBigText: true, // بعض الأجهزة بتدعم شوية Formatting
      );

      final androidDetails = AndroidNotificationDetails(
        'asroo-id',
        'asroo-name',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigTextStyle,
      );

      const iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        details,
        payload: payload,
      );
    } else {
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'asroo-id',
          'asroo-name',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
    }
  }
}
