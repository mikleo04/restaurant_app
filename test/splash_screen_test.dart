import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/ui/home_page.dart';
import 'package:restaurant_app/ui/splash_screen.dart';
import 'package:http/http.dart' as http;


void main() {
  testWidgets('Splash screen displays correctly', (WidgetTester tester) async {

    var restaurantProvider = RestaurantProvider(apiService: ApiService(http.Client()));
    var restaurantSearchProvider = RestaurantSearchProvider(apiService: ApiService(http.Client()));


    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: restaurantProvider),
          ChangeNotifierProvider.value(value: restaurantSearchProvider),
        ],
        child: MaterialApp(
          home: SplashScreenPage(),
          routes: {
            SplashScreenPage.routeName: (context) => SplashScreenPage(),
            HomePage.routeName: (context) => HomePage(),
          },
        ),
      ),
    );

    await tester.pump(Duration(seconds: 4));

    expect(find.text('Restaurant App'), findsOneWidget);

    expect(find.byType(Image), findsOneWidget);

  });
}