// lib/services/notification_service.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_reminder/view_models/service/fcm_service.dart';
import 'firebase_options.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static final FcmService _fcmService = FcmService();
  static final GetStorage _storage = GetStorage();

  // handles message when the app is in the background or terminated
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message,
      ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await _initalizeLocalNotification();
    await _showFlutterNotification(message);
  }

  /// initialize Firebase Messaging and local Notification
  static Future<void> initializeNotification() async {
    await _firebaseMessaging.requestPermission();

    // Called when app is brought to foreground from background by tapping a notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground received');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
      _showFlutterNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔁 Notification opened: ${message.data}');
    });

    // ✅ Get and send FCM token
    await _getFcmToken();

    // ✅ Listen for token refresh
    _listenTokenRefresh();

    // Initialize the local notification plugin
    await _initalizeLocalNotification();

    // Check if app was launched by tapping on a notification
    await _getInitalNotification();
  }

  /// ✅ Get FCM Token and Send to Server
  static Future<void> _getFcmToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('📱 FCM Token: $token');
        await _sendTokenToServer(token);
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
    }
  }

  /// ✅ Listen for Token Refresh
  static void _listenTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((String newToken) async {
      print('🔄 FCM Token refreshed: $newToken');
      await _sendTokenToServer(newToken, forceUpdate: true);
    });
  }

  /// ✅ Send Token to Server (with optimization)
  static Future<void> _sendTokenToServer(String newToken, {bool forceUpdate = false}) async {
    try {
      // Get saved token from local storage
      final String? savedToken = _storage.read('fcm_token');

      // Only send if token changed or force update
      if (forceUpdate || newToken != savedToken) {
        print('📤 Sending FCM token to server...');

        final response = await _fcmService.sendFcmToken<Map<String, dynamic>>(newToken);

        if (response['success'] == true) {
          // Save new token locally
          await _storage.write('fcm_token', newToken);
          print('✅ FCM token saved successfully');
        } else {
          print('❌ Failed to save FCM token: ${response['message']}');
        }
      } else {
        print('ℹ️ FCM token unchanged, skipping server update');
      }
    } catch (e) {
      print('❌ Error sending FCM token to server: $e');
    }
  }

  /// ✅ Public method to manually send token (called from controllers)
  static Future<void> sendFcmTokenToServer({bool forceUpdate = false}) async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _sendTokenToServer(token, forceUpdate: forceUpdate);
      }
    } catch (e) {
      print('❌ Error in sendFcmTokenToServer: $e');
    }
  }

  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic>? data = message.data;

    String title = notification?.title ?? data['title'] ?? 'No Title';
    String body = notification?.body ?? data['body'] ?? 'No Body';

    // Android notification config
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'Notification channel for basic tests',
      priority: Priority.high,
      importance: Importance.high,
    );

    // iOS notification config
    DarwinNotificationDetails iosNotificationDetails =
    const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Combine platform-specific settings
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    // Show notification
    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  /// Initializes the local notification system (both android and ios)
  static Future<void> _initalizeLocalNotification() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings isoInit = DarwinInitializationSettings();

    final InitializationSettings initSetting = InitializationSettings(
      android: androidInit,
      iOS: isoInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initSetting,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("User tapped notification: ${response.payload}");
      },
    );
  }

  // Handles notification tap when app is terminated
  static Future<void> _getInitalNotification() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      print(
        "App launched from terminated state via notification: ${message.data}",
      );
    }
  }
}