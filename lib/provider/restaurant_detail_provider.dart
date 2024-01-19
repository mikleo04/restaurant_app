import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/utils/result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  RestaurantDetailProvider({
    required this.apiService,
    required this.restaurantId,
  }) {
    fetchDetailRestaurant(restaurantId);
  }

  late DetailRestaurantResult _restaurantDetailResult;
  DetailRestaurantResult get result => _restaurantDetailResult;

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  Future<dynamic> fetchDetailRestaurant(String restaurantId) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantDetail = await apiService.getRestaurantDetail(restaurantId);

      _state = ResultState.hasData;
      notifyListeners();

      return _restaurantDetailResult = restaurantDetail;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final postReviewResult = await apiService.postReview(
        id: id,
        name: name,
        review: review,
      );
      if (postReviewResult.error == false &&
          postReviewResult.message == 'success') {
        await fetchDetailRestaurant(id);

        return ResultState.success;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      _message = 'Error --> $e';
      return ResultState.error;
    }
  }
}