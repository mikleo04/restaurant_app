import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});


  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Favorites"),
      ),
      child: _buildList(),
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.loading) {
          return FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 800)),
            builder: (context, snapshot) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        } else if (provider.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: provider.favorite.length,
            itemBuilder: (context, index) {
              return CardRestaurant(restaurant: provider.favorite[index]);
            }
          );
        } else {
          return Center(
            child: Material(
              child: Text(provider.message),
            ),
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
