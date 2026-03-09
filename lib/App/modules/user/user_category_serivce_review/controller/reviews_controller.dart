import 'package:get/get.dart';

class ReviewsController extends GetxController {

  var selectedTab = 0.obs;

  final tabs = [
    "All",
    "★★★★★",
    "★★★★",
    "★★★",
    "★★",
    "★"
  ];

  final totalReviews = 45.obs;

  final ratingCount = {
    5: 25,
    4: 5,
    3: 5,
    2: 5,
    1: 5
  };

  final reviews = [
    {
      "name": "John Doe",
      "rating": 5,
      "time": "2 days ago",
      "review": "Amazing service. Highly recommended!",
      "image": "https://i.pravatar.cc/150?img=1"
    },
    {
      "name": "Emma Watson",
      "rating": 4,
      "time": "3 days ago",
      "review": "Very good experience",
      "image": "https://i.pravatar.cc/150?img=2"
    },
    {
      "name": "David Smith",
      "rating": 3,
      "time": "5 days ago",
      "review": "Average service",
      "image": "https://i.pravatar.cc/150?img=3"
    },
  ].obs;

  List<Map> get filteredReviews {

    if (selectedTab.value == 0) {
      return reviews;
    }

    int rating = 6 - selectedTab.value;

    return reviews.where((r) => r["rating"] == rating).toList();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

}