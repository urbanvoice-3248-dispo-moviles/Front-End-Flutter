import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'api_client.dart';
import 'token_manager.dart';
import '../constants/api_constants.dart';

class FcmService {
  final ApiClient _apiClient = ApiClient();
  final TokenManager _tokenManager = TokenManager();
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    _showLocalNotification(message);
  }

  Future<void> initialize() async {
    await Firebase.initializeApp();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    _registerToken();
  }

  Future<void> _registerToken() async {
    try {
      final messaging = FirebaseMessaging.instance;

      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await messaging.getToken();
      if (token != null) {
        await _sendTokenToBackend(token);
      }

      messaging.onTokenRefresh.listen(_sendTokenToBackend);
    } catch (e) {
      // Firebase no configurado o error de conexión
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      final userId = await _tokenManager.getUserId();
      if (userId == null) return;

      await _apiClient.post(
        ApiConstants.fcmTokens,
        data: {
          'token': token,
          'deviceType': 'flutter',
        },
        headers: {'X-User-ID': '$userId'},
      );
    } catch (e) {
      // Reintentar en el próximo refresh
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final title = message.notification?.title ??
        message.data['title'] ??
        'UrbanVoice';
    final body = message.notification?.body ??
        message.data['message'] ??
        '';
    _showLocalNotification(message, title: title, body: body);
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Navegar a la pantalla de alertas al tocar la notificación
  }

  static void _showLocalNotification(
    RemoteMessage message, {
    String? title,
    String? body,
  }) {
    final notification = message.notification;
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidDetails = AndroidNotificationDetails(
      'urbanvoice_alerts',
      'Alertas UrbanVoice',
      channelDescription: 'Notificaciones de alertas e incidentes',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );
    flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title ?? notification?.title ?? 'UrbanVoice',
      body ?? notification?.body ?? '',
      details,
    );
  }

  Future<void> deleteToken() async {
    try {
      final userId = await _tokenManager.getUserId();
      if (userId != null) {
        await _apiClient.delete(
          ApiConstants.fcmTokens,
          headers: {'X-User-ID': '$userId'},
        );
      }
    } catch (e) {
      //
    }
  }
}
