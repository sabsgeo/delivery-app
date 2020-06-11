import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:vegitabledelivery/services/navigator.dart';
import 'package:vegitabledelivery/singletons/app_data.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future initialise() async {
    if(!appData.notificationConfigured) {
      appData.notificationConfigured = true;
      if (Platform.isIOS) {
        await _fcm.requestNotificationPermissions(IosNotificationSettings());
      }

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      var android = AndroidInitializationSettings('@mipmap/ic_launcher');
      var iOS = IOSInitializationSettings();
      var initializationSettings = InitializationSettings(android, iOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (payload) async {
        Map mapData = json.decode(payload);
        Map<String, dynamic> details = new Map();
        details['orderId'] = mapData['data']['orderId'];
        details['from'] = 'notification';
        await GetIt.instance<NavigationService>().navigateTo('/summary', details);
        return true;
      });

      _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          var android = AndroidNotificationDetails('channel id', 'channel NAME', 'CHANNEL DESCRIPTION');
          var iOS = IOSNotificationDetails();
          var platform = NotificationDetails(android, iOS);
          String payloadData = json.encode(message);
          flutterLocalNotificationsPlugin.show(0, message['notification']['title'], message['notification']['body'], platform, payload: payloadData);
        },
        onLaunch: (Map<String, dynamic> message) async {
          Map<String, dynamic> details = new Map();
          details['orderId'] = message['data']['orderId'];
          details['from'] = 'notification';
          await GetIt.instance<NavigationService>().navigateTo('/summary', details);
        },
        onResume: (Map<String, dynamic> message) async {
          Map<String, dynamic> details = new Map();
          details['orderId'] = message['data']['orderId'];
          details['from'] = 'notification';
          await GetIt.instance<NavigationService>().navigateTo('/summary', details);
        },
      );
    }
  }
}
