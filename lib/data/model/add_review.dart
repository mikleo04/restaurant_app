
import 'package:restaurant_app/data/model/detail_restaurant.dart';

class AddReviewResult {
  AddReviewResult({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  bool error;
  String message;
  List<Review> customerReviews;

  factory AddReviewResult.fromJson(Map<String, dynamic> json) =>
      AddReviewResult(
        error: json["error"],
        message: json["message"],
        customerReviews: List<Review>.from(
          json["customerReviews"].map((x) => Review.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "customerReviews":
    List<dynamic>.from(customerReviews.map((x) => x.toJson())),
  };
}