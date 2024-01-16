import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/common/style.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';


class DetailPage extends StatelessWidget {
  static const routeName = '/article_detail';
  final Restaurant restaurant;

  DetailPage({super.key, required this.restaurant});

  final TextEditingController reviewController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (_) =>  RestaurantDetailProvider(
        apiService: ApiService(http.Client()),
        restaurantId: restaurant.id
      ),
      child: Scaffold(
        body: Consumer<RestaurantDetailProvider>(
          builder: (context, state, _) {
            if (state.state == ResultStateDetail.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultStateDetail.hasData) {
              return buildDetailRestaurant(context, state);
            } else if (state.state == ResultState.noData) {
              return const Center(
                child: Column(
                  children: [
                    Icon(Icons.warning_rounded),
                    Text("Data tidak tersedia !"),
                  ],
                ),
              );
            } else if (state.state == ResultStateDetail.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_rounded),
                    Text("Upps tidak terhubung ke internet !"),
                    SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        state.fetchDetailRestaurant(restaurant.id);
                      },
                      child: Text("Refresh"),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_rounded),
                    Text("Upps tidak terhubung ke internet !"),
                    SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        state.fetchDetailRestaurant(restaurant.id);
                      },
                      child: Text("Refresh"),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  CustomScrollView buildDetailRestaurant(BuildContext context, RestaurantDetailProvider state) {
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
                    ..color = Colors.white.withOpacity(0.8)
              ),
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
                                .labelMedium,
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
                                .labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restauranDetail.categories.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            restauranDetail.categories[index].name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
                      .bodyMedium,
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Minuman",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                buildListMenu(restauranDetail.menus.drinks, 'assets/iced-coffee.png'),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                        "Makanan",
                        style: Theme.of(context).textTheme.labelMedium
                    )
                ),
                buildListMenu(restauranDetail.menus.foods, 'assets/bibimbap.png'),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Review",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                SizedBox(height: 10,),
                customerReview(restauranDetail.customerReviews),
                Padding(
                  padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'Nama',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: secondColor),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: reviewController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Tambahkan review...',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: secondColor),
                              ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: secondColor,
                            minimumSize: const Size(double.infinity, 48.0),
                          ),
                          onPressed: () async {
                            String name = nameController.text;
                            String newReview = reviewController.text;
                            if (name.isNotEmpty && newReview.isNotEmpty) {
                                ResultStateDetail result = await state.addReview(
                                  id: restaurant.id,
                                  name: name,
                                  review: newReview,
                                );

                              if (result == ResultStateDetail.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                    'Review berhasil ditambahkan'),
                                  ),
                                );
                                nameController.clear();
                                reviewController.clear();
                              } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(
                                    content: Text(
                                    'Gagal menambahkan review'),
                                    ),
                                 );
                              }
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Tambah Review",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                                ),
                              ),
                          ),
                        ),
                      ],
                    ),
                ),
              ],
            ),
          ),
        ),
      ],
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

  SizedBox customerReview(review) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: review.length,
        itemExtent: 170.0,
        itemBuilder: (context, index) {
          final list = review[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Card(
              color: Colors.white,

              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      list.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      list.date,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: Text(
                        list.review,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
