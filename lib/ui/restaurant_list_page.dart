import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';


class RestaurantListPage extends StatelessWidget {

  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurant App',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(70),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          textAlign: TextAlign.start,
                          onChanged: (query) {
                            Provider.of<RestaurantSearchProvider>(
                              context,
                              listen: false,
                            ).fetchSearchRestaurant(query);
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundColor: Colors.grey.withAlpha(70),
                  child: const Icon(Icons.person),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "The Most Popular Restaurant",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: _buildList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer2<RestaurantProvider, RestaurantSearchProvider>(
      builder: (context, restaurantProvider, searchProvider, child) {
        List<Restaurant> displayRestaurants =
        searchProvider.result.restaurants.isNotEmpty
            ? searchProvider.result.restaurants
            : restaurantProvider.result.restaurants;

        if (searchProvider.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (restaurantProvider.state == ResultState.loading ||
            searchProvider.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (restaurantProvider.state == ResultState.hasData ||
            searchProvider.state == ResultState.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: displayRestaurants.length,
            itemBuilder: (context, index) {
              var restaurant = displayRestaurants[index];
              return CardRestaurant(restaurant: restaurant);
            },
          );
        } else if (restaurantProvider.state == ResultState.noData ||
            searchProvider.state == ResultState.noData) {
          return const Center(
            child: Column(
              children: [
                Icon(Icons.warning_rounded),
                Text("Data tidak tersedia !")
              ],
            ),
          );
        } else if (restaurantProvider.state == ResultState.error ||
            searchProvider.state == ResultState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_rounded),
                Text("Upps tidak terhubung ke internet !"),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    restaurantProvider.fetchAllRestaurant();
                  },
                  child: Text("Refresh"),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Column(
                children: [Icon(Icons.warning_rounded), Text("Terjadi kesalahan !")]),
          );
        }
      },
    );
  }

}
