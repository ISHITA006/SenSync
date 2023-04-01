import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class NotificationService {
  NotificationService();

  final _localNotifications = FlutterLocalNotificationsPlugin();
   final BehaviorSubject<String> behaviorSubject = BehaviorSubject();

  // static Future notificationDetails(FlutterLocalNotificationsPlugin fln) async{
  //   var not = NotificationDetails(iOS: IOSNotificationDetails());
  //   await fln.show(0, title, body, notificationDetails)
  // }

  Future<void> initializePlatformNotifications() async {
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void selectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      behaviorSubject.add(payload);
    }
  }

  Future<NotificationDetails> _notificationDetails() async {
  IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
      sound: 'notification_sound.mp3',
      threadIdentifier: "thread1",
      );

  final details = await _localNotifications.getNotificationAppLaunchDetails();
  if (details != null && details.didNotificationLaunchApp) {
    behaviorSubject.add(details.payload!);
  }
  NotificationDetails platformChannelSpecifics = NotificationDetails(iOS: iosNotificationDetails);

  return platformChannelSpecifics;
}

  Future<void> showLocalNotification({
  required int id,
  required String title,
  required String body,
  required String payload}) async {
  final platformChannelSpecifics = await _notificationDetails();
  await _localNotifications.show(
    id,
    title,
    body,
    platformChannelSpecifics,
    payload: payload,
  );
}
}