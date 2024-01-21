import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/widgets/favorite_button_widget.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  testWidgets('Scenario 1: Widget Memuat Dengan Benar', (WidgetTester tester) async {
    final MockDatabaseHelper mockDatabaseHelper = MockDatabaseHelper();
    final DatabaseProvider databaseProvider = DatabaseProvider(databaseHelper: mockDatabaseHelper);

    final Restaurant restaurant = Restaurant(
      id: "s1knt6za9kkfw1e867",
      name: "Kafe Kita",
      description: "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue...",
      pictureId: "25",
      city: "Gorontalo",
      rating: 4.0,
    );

    // Mock the necessary methods for database interaction
    when(mockDatabaseHelper.getFavorites()).thenAnswer((_) async => []);
    when(mockDatabaseHelper.insertFavorite(restaurant)).thenAnswer((_) async {});
    when(mockDatabaseHelper.getFavoriteById(restaurant.id)).thenAnswer((_) async => {});

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