import 'dart:isolate';
import 'dart:ui';

import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/main.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:http/http.dart' as http;

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendport;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializedIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName
    );
  }

  static Future<void> callback() async {
    print('Alarm fires!');
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiService(http.Client()).getRestaurant();
    await notificationHelper.showNotification(
      flutterLocalNotificationsPlugin, result);

    _uiSendport ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendport?.send(null);
  }

}