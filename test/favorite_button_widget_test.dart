import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/widgets/favorite_button_widget.dart';

void main() {

  testWidgets('Scenario 1: Widget Memuat Dengan Benar', (WidgetTester tester) async {

    final DatabaseHelper databaseHelper = DatabaseHelper();

    final DatabaseProvider databaseProvider = DatabaseProvider(databaseHelper: databaseHelper);

    final Restaurant restaurant = Restaurant(
      id: '1',
      name: 'Restoran Test',
      description: 'Deskripsi Restoran Test',
      pictureId: '12345',
      city: 'Kota Test',
      rating: 4.5,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider(
            create: (context) => databaseProvider,
            child: FavoriteButton(restaurant: restaurant),
          ),
        ),
      ),
    );

    expect(find.byType(FloatingActionButton), findsOneWidget);

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });
}