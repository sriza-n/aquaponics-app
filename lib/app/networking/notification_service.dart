// notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    try {
      var androidDetails = AndroidNotificationDetails(
          'channelId', 'channelName',
          importance: Importance.max, priority: Priority.high);
      var platformDetails = NotificationDetails(android: androidDetails);
      await flutterLocalNotificationsPlugin.show(
          0, title, body, platformDetails);
    } catch (e) {
      print('Failed to show notification: $e');
      // Handle the error or rethrow to handle it at a higher level
    }
  }
}
