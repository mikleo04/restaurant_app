import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/api/api_service.dart';

void main() {
  group('ApiService', () {
    test('should parse restaurant list', () async {

      final apiService = ApiService(MockClient((request) async {
        return http.Response(json.encode({
          "error": false,
          "message": "success",
          "count": 2,
          "restaurants": [
            {
              "id": "rqdv5juczeskfw1e867",
              "name": "Melting Pot",
              "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit...",
              "pictureId": "14",
              "city": "Medan",
              "rating": 4.2,
            },
            {
              "id": "s1knt6za9kkfw1e867",
              "name": "Kafe Kita",
              "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue...",
              "pictureId": "25",
              "city": "Gorontalo",
              "rating": 4.0,
            },
          ],
        }), 200);
      }));

      final result = await apiService.getRestaurant();

      expect(result.error, false);
      expect(result.message, "success");
      expect(result.count, 2);
      expect(result.restaurants.length, 2);

      expect(result.restaurants[0].id, "rqdv5juczeskfw1e867");
      expect(result.restaurants[0].name, "Melting Pot");
      expect(result.restaurants[0].description, startsWith("Lorem ipsum"));

      expect(result.restaurants[1].id, "s1knt6za9kkfw1e867");
      expect(result.restaurants[1].name, "Kafe Kita");
      expect(result.restaurants[1].description, startsWith("Quisque rutrum"));
    });

    test('should parse restaurant detail', () async {
      final apiService = ApiService(MockClient((request) async {
        return http.Response(json.encode({
          "error": false,
          "message": "success",
          "restaurant": {
            "id": "rqdv5juczeskfw1e867",
            "name": "Melting Pot",
            "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit...",
            "city": "Medan",
            "address": "Jln. Pandeglang no 19",
            "pictureId": "14",
            "categories": [
              {"name": "Italia"},
              {"name": "Modern"}
            ],
            "menus": {
              "foods": [
                {"name": "Paket rosemary"},
                {"name": "Toastie salmon"}
              ],
              "drinks": [
                {"name": "Es krim"},
                {"name": "Sirup"}
              ]
            },
            "rating": 4.2,
            "customerReviews": [
              {
                "name": "Ahmad",
                "review": "Tidak rekomendasi untuk pelajar!",
                "date": "13 November 2019",
              }
            ]
          }
        }), 200);
      }));

      final result = await apiService.getRestaurantDetail("rqdv5juczeskfw1e867");

      expect(result.error, false);
      expect(result.message, "success");
      expect(result.restaurantDetail.id, "rqdv5juczeskfw1e867");
      expect(result.restaurantDetail.name, "Melting Pot");
      expect(result.restaurantDetail.description, startsWith("Lorem ipsum"));

      expect(result.restaurantDetail.categories.length, 2);
      expect(result.restaurantDetail.menus.foods.length, 2);
      expect(result.restaurantDetail.menus.drinks.length, 2);
      expect(result.restaurantDetail.customerReviews.length, 1);
    });

    test('should parse restaurant search result', () async {
      final apiService = ApiService(MockClient((request) async {
        return http.Response(json.encode({
          "error": false,
          "founded": 1,
          "restaurants": [
            {
              "id": "fnfn8mytkpmkfw1e867",
              "name": "Makan mudah",
              "description":
              "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain...",
              "pictureId": "22",
              "city": "Medan",
              "rating": 3.7
            }
          ],
        }), 200);
      }));

      final result = await apiService.getRestaurantSearch("makan");

      expect(result.error, false);
      expect(result.founded, 1);
      expect(result.restaurants.length, 1);

      expect(result.restaurants[0].id, "fnfn8mytkpmkfw1e867");
      expect(result.restaurants[0].name, "Makan mudah");
      expect(result.restaurants[0].description, startsWith("But I must explain"));
    });

  });
}