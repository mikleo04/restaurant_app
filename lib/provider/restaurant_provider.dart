import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/utils/result_state.dart';


class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {

    _restaurantsResult = RestaurantsResult(
      error: false,
      message: '',
      count: 0,
      restaurants: [],
    );
    fetchAllRestaurant();
  }

  late RestaurantsResult _restaurantsResult;
  late DetailRestaurantResult _detailRestaurantResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantsResult get result => _restaurantsResult;
  DetailRestaurantResult get resultDetail => _detailRestaurantResult;

  ResultState get state => _state;

  Future<dynamic> fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurant();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantsResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}