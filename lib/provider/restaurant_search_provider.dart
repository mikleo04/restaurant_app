import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/serach_restaurant.dart';

enum ResultStateSearch { loading, noData, success, hasData, error }

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantSearchProvider({required this.apiService});

  late RestaurantSearchResult _restaurantSearchResult = RestaurantSearchResult(
    error: false,
    founded: 0,
    restaurants: [], // Atur sesuai dengan tipe data yang sebenarnya
  );
  RestaurantSearchResult get result => _restaurantSearchResult;

  ResultStateSearch? _state;
  ResultStateSearch? get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _searchResults = [];

  List<Restaurant> get searchResults => _searchResults;

  Future<dynamic> fetchSearchRestaurant(String query) async {
    try {
      if (query.isEmpty) {
        // Jika query kosong, reset hasil pencarian
        _searchResults = [];
        _state = ResultStateSearch.noData; // Anda bisa mengubah status sesuai kebutuhan
        notifyListeners();
      } else {
        _state = ResultStateSearch.loading;
        notifyListeners();

        final restaurantSearch = await apiService.getRestaurantSearch(query);
        if (restaurantSearch.founded == 0 &&
            restaurantSearch.restaurants.isEmpty) {
          _state = ResultStateSearch.noData;
          notifyListeners();
          return _message = 'Pencarian Tidak Ditemukan';
        } else {
          _searchResults = restaurantSearch.restaurants;
          _state = ResultStateSearch.hasData;
          notifyListeners();
          return _restaurantSearchResult = restaurantSearch;
        }
      }
    } catch (e) {
      _state = ResultStateSearch.error;
      notifyListeners();

      return _message = 'Error --> $e';
    }
  }
}
