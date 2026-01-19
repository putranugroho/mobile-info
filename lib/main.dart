import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_info/module/splash_screen_page.dart';
import 'package:mobile_info/utils/custom_scroll.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app_router.dart';

/// ================================
/// ANDROID LOCAL NOTIFICATION
/// ================================
final FlutterLocalNotificationsPlugin localNotif =
    FlutterLocalNotificationsPlugin();

Future<void> initLocalNotif() async {
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

  const initSettings = InitializationSettings(android: androidInit);

  await localNotif.initialize(initSettings);
}

/// ================================
/// WEB LOCAL NOTIFICATION
/// ================================

/// ================================
/// BACKGROUND HANDLER (ANDROID)
/// ================================

/// ================================
/// INIT PUSH
/// ================================

Future<void> initWebPush() async {
  if (!kIsWeb) return;

  try {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken(
        vapidKey:
            'BLTB29Uy3GxtzvXpg7XdMJmCx_8v0hT-3mRRc_DxydjTb6erLTwwJlflthGZF9TFDi_ef7SU42W5MqGLCUCdzIM',
      );
      debugPrint('✅ FCM WEB TOKEN: $token');
    } else {
      debugPrint('❌ Web notification permission denied');
    }
  } catch (e, s) {
    debugPrint('❌ initWebPush error: $e');
    debugPrint('$s');
  }
}

Future<void> initAndroidPush() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();

  final token = await messaging.getToken();
  debugPrint('✅ FCM ANDROID TOKEN: $token');

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

Future<void> initPush() async {
  if (kIsWeb) {
    await initWebPush();
  } else if (Platform.isAndroid) {
    await initAndroidPush();
    // await initAndroidLocalNotif();
  }
}

/// ================================
/// FCM LISTENERS
/// ================================

void setupFCMListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    debugPrint('🔔 FOREGROUND NOTIF');

    final title =
        message.notification?.title ?? message.data['title'] ?? 'IBPR';
    final body = message.notification?.body ?? message.data['body'] ?? '';

    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    await localNotif.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('🟢 NOTIF DIKLIK');
    debugPrint('Data: ${message.data}');
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(
    options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null,
  );

  await initLocalNotif(); // ⬅️ WAJIB
  setupFCMListeners();
  await initPush();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (kIsWeb) {
    final uri = Uri.base;
    final token = uri.queryParameters['token'];

    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    }
  }

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final title = message.notification?.title ?? message.data['title'] ?? 'IBPR';
  final body = message.notification?.body ?? message.data['body'] ?? '';

  const androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  await FlutterLocalNotificationsPlugin().show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    body,
    const NotificationDetails(android: androidDetails),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreenPage(),
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
    );
  }
}
