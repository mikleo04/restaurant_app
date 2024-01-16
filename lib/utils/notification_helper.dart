import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingAndroid = const AndroidInitializationSettings('app_icon');

    var initializationSettingIos = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingAndroid,
        iOS: initializationSettingIos
    );
    
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
      final payload = details.payload;
      if (payload != null) {
        print('notification payload$payload');
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
      });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantsResult restaurant) async {
    var channelId = "1";
    var channelName = "channel_01";
    var channerlDescription = "Restaurant Notification";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId, channelName,
      channelDescription: channerlDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(true, true)
    );

    var iosPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics
    );

    var tittleNotification = "<b>Top Restaurant</b>";
    var randomRestaurantIndex = Random().nextInt(restaurant.restaurants.length);
    var titleRestaurant = restaurant.restaurants[randomRestaurantIndex].name;
    
    await flutterLocalNotificationsPlugin.show(
      0, tittleNotification, titleRestaurant, platformChannelSpecifics,
      payload: json.encode(restaurant.toJson())
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = RestaurantsResult.fromJson(json.decode(payload));
        var restaurant = data.restaurants[0];
        Navigation.intentWithData(route, restaurant);
      }
    );
  }

}