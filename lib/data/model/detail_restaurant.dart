import 'dart:convert';

class DetailRestaurantResult {
  bool error;
  String message;
  RestaurantDetail restaurantDetail;

  DetailRestaurantResult({
    required this.error,
    required this.message,
    required this.restaurantDetail,
  });

  factory DetailRestaurantResult.fromJson(Map<String, dynamic> json) => DetailRestaurantResult(
    error: json["error"],
    message: json["message"],
    restaurantDetail: RestaurantDetail.fromJson(json["restaurant"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "restaurant": restaurantDetail.toJson(),
  };
}

class RestaurantDetail {
  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<Category> categories;
  Menus menus;
  double rating;
  List<Review> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) => RestaurantDetail(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    city: json["city"],
    address: json["address"],
    pictureId: json["pictureId"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    menus: Menus.fromJson(json["menus"]),
    rating: json["rating"]?.toDouble(),
    customerReviews: List<Review>.from(json["customerReviews"].map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "city": city,
    "address": address,
    "pictureId": pictureId,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "menus": menus.toJson(),
    "rating": rating,
    "customerReviews": List<dynamic>.from(customerReviews.map((x) => x.toJson())),
  };

  String getFullImageUrl() {
    return 'https://restaurant-api.dicoding.dev/images/medium/$pictureId';
  }
}

class Category {
  String name;

  Category({
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}

class Menus {
  List<Category> foods;
  List<Category> drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
    foods: List<Category>.from(json["foods"].map((x) => Category.fromJson(x))),
    drinks: List<Category>.from(json["drinks"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
    "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
  };
}

class Foods {
  Foods({required this.name});

  String name;

  factory Foods.fromJson(Map<String, dynamic> json) => Foods(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {"name": name};
}

class Drinks {
  Drinks({required this.name});

  String name;

  factory Drinks.fromJson(Map<String, dynamic> json) => Drinks(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {"name": name};
}

class Review {
  Review({
    required this.name,
    required this.review,
    required this.date,
  });

  String name;
  String review;
  String date;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    name: json["name"],
    review: json["review"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "review": review,
    "date": date,
  };
}
