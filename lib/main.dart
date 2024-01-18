import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/preferences/preferences_helper.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/preferences_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:restaurant_app/ui/detail_page.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/ui/home_page.dart';
import 'package:restaurant_app/ui/setting_page.dart';
import 'package:restaurant_app/ui/splash_screen.dart';
import 'package:restaurant_app/utils/background_servicce.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/style.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializedIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RestaurantDetailProvider(
              restaurantId: '', apiService: ApiService(http.Client())
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(
            apiService: ApiService(http.Client()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantSearchProvider(
            apiService: ApiService(http.Client()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SchedulingProvider(),
          child: const SettingPage(),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            )
          )
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper())
        )
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Restaurant App',
            theme: provider.themeData,
            builder: (context, child) {
              return CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: provider.isDarkTheme ? Brightness.dark : Brightness.light,
                ),
                child: Material(
                  child: child,
                )
              );
            },
            navigatorKey: navigatorkey,
            initialRoute: SplashScreenPage.routeName,
            routes: {
              SplashScreenPage.routeName: (context) => const SplashScreenPage(),
              HomePage.routeName: (context) => const HomePage(),
              DetailPage.routeName: (context) => DetailPage(restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant,),
            },
          );
        },
      )
    );
  }
}
