import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  final String _endpoints;

  ApiService({required String endpoints}) : _endpoints = endpoints;

  Future<RestaurantsResult> topRestaurants() async {
    final response = await http.get(Uri.parse(_baseUrl + _endpoints));
    if (response.statusCode == 200) {
      return RestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top restaurants');
    }
  }
}