import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/serach_restaurant.dart';
import 'package:restaurant_app/utils/result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantSearchProvider({required this.apiService});

  late RestaurantSearchResult _restaurantSearchResult = RestaurantSearchResult(
    error: false,
    founded: 0,
    restaurants: [],
  );
  RestaurantSearchResult get result => _restaurantSearchResult;

  ResultState? _state;
  ResultState? get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _searchResults = [];

  List<Restaurant> get searchResults => _searchResults;

  Future<dynamic> fetchSearchRestaurant(String query) async {
    try {
      if (query.isEmpty) {
        _searchResults = [];
        _state = ResultState.noData;
        notifyListeners();
      } else {
        _state = ResultState.loading;
        notifyListeners();

        final restaurantSearch = await apiService.getRestaurantSearch(query);
        if (restaurantSearch.founded == 0 &&
            restaurantSearch.restaurants.isEmpty) {
          _state = ResultState.noData;
          notifyListeners();
          return _message = 'Pencarian Tidak Ditemukan';
        } else {
          _searchResults = restaurantSearch.restaurants;
          _state = ResultState.hasData;
          notifyListeners();
          return _restaurantSearchResult = restaurantSearch;
        }
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      return _message = 'Error --> $e';
    }
  }
}
