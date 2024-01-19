import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/database_provider.dart';

class FavoriteButton extends StatelessWidget {
  final Restaurant restaurant;

  const FavoriteButton({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, _) {
        return FutureBuilder(
          future: provider.isFavorite(restaurant.id),
          builder: (context, snapshot) {
            var isFavorite = snapshot.data ?? false;
            return FloatingActionButton(
              onPressed: () {
                isFavorite
                    ? provider.removeFavorite(restaurant.id)
                    : provider.addFavorite(restaurant);
              },
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.pinkAccent,
              ),
            );
          },
        );
      },
    );
  }
}