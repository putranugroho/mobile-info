// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationApi {
//   static final notifications = FlutterLocalNotificationsPlugin();
//   final sounds = 'army.wav';
//   static Future notificationDetails() async {
//     return const NotificationDetails(
//         android: AndroidNotificationDetails(
//       actions: [],
//       "1",
//       'basic',
//       importance: Importance.max,
//     ));
//   }

//   static Future init() async {
//     final android = AndroidInitializationSettings('@mipmap/ic_launcher');

//     final settings = InitializationSettings(
//       android: android,
//     );

//     await notifications.initialize(
//       settings,
//     );
//   }

//   void onDidReceiveNotificationResponse(
//       NotificationResponse notificationResponse) async {
//     final String? payload = notificationResponse.payload;
//     if (notificationResponse.payload != null) {}
//   }
// }
