import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/add_review.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

class ApiService {

  final http.Client client;

  ApiService(this.client);


  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantsResult> getRestaurant() async {
    final response = await client.get(Uri.parse('$_baseUrl/list'));
    if (response.statusCode == 200) {
      return RestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top restaurants');
    }
  }

  Future<DetailRestaurantResult> getRestaurantDetail(String restaurantId) async {
    final response = await client.get(Uri.parse('$_baseUrl/detail/$restaurantId'));
    if (response.statusCode == 200) {
      return DetailRestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant details');
    }
  }

  Future<AddReviewResult> postReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/review'),
      body: jsonEncode(<String, String>{
        'id': id,
        'name': name,
        'review': review,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      return AddReviewResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed post data');
    }
  }

}