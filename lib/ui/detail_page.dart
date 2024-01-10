import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/common/style.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';


class DetailPage extends StatelessWidget {
  static const routeName = '/article_detail';
  final Restaurant restaurant;

  const DetailPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (_) =>  RestaurantDetailProvider(
        apiService: ApiService(http.Client()),
        restaurantId: restaurant.id
      ),
      child: Scaffold(
        body: Consumer<RestaurantDetailProvider> (
          builder: (context, state, _) {
            if (state.state == ResultStateDetail.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultStateDetail.hasData) {
              var restauranDetail = state.result.restaurantDetail;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    backgroundColor: primaryColor,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: restauranDetail.pictureId,
                        child: Image.network(
                          restauranDetail.getFullImageUrl(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        restauranDetail.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.fill
                              ..color = Colors.white.withOpacity(0.8)),
                      ),
                    ),
                    pinned: true,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.location_city,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      restauranDetail.city,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headline5,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      restauranDetail.rating.toString(),
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headline5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            restauranDetail.description ?? "",
                            textAlign: TextAlign.justify,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2,
                            maxLines: 8,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "Minuman",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          buildListMenu(restauranDetail.menus.drinks, 'assets/iced-coffee.png'),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                  "Makanan",
                                  style: Theme.of(context).textTheme.headline6
                              )
                          ),
                          buildListMenu(restauranDetail.menus.foods, 'assets/bibimbap.png'),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: secondColor,
                              minimumSize: const Size(double.infinity, 48.0),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_cart,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "PESAN",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 5,
                                        fontSize: 16
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state.state == ResultState.noData) {
              return Center(
                child: Material(
                  child: Text(state.message),
                ),
              );
            } else if (state.state == ResultState.error) {
              return Center(
                child: Material(
                  child: Text(state.message),
                ),
              );
            } else {
              return const Center(
                child: Material(
                  child: Text('error'),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  SizedBox buildListMenu(menu, image) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: menu.length,
        itemExtent: 170.0,
        itemBuilder: (context, index) {
          final data = menu[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image.asset(
                    image,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Colors.brown.withOpacity(0.5),
                    ),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        data.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
