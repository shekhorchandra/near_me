import 'package:get/get.dart';
import '../../user_category_details/user_category_model/service_model.dart';
import '../models/ReviewModel.dart';

class ServiceDetailsController extends GetxController {
  late String image;
  late String title;
  late String category;
  late double rating;
  late String schedule;
  late String location;
  late String about;
  late List<String> servicesOffered;
  late List<HighlightModel> highlights;
  late List<ReviewModel> reviews;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};

    image = args['image'] ?? '';
    title = args['title'] ?? '';
    category = args['category'] ?? '';
    rating = (args['rating'] ?? 0.0).toDouble();
    schedule = args['schedule'] ?? '';
    location = args['location'] ?? '';
    about = args['about'] ?? '';

    // Services Offered
    servicesOffered = (args['servicesOffered'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ??
        [];

    // Highlights
    highlights = (args['highlights'] as List<dynamic>?)
        ?.map((e) {
      if (e is HighlightModel) return e;
      if (e is Map<String, dynamic>) return HighlightModel.fromJson(e);
      if (e is String) return HighlightModel(image: e, title: '');
      throw Exception("Invalid highlight data: $e");
    })
        .toList() ??
        [];

    // Reviews
    reviews = (args['reviews'] as List<dynamic>?)
        ?.map((e) {
      if (e is ReviewModel) return e;
      if (e is Map<String, dynamic>) {
        return ReviewModel(
          userImage: e['userImage'] ?? 'assets/images/user.png',
          userName: e['userName'] ?? 'Anonymous',
          review: e['review'] ?? '',
          daysAgo: (e['daysAgo'] ?? 0) as int,
        );
      }
      if (e is String) {
        return ReviewModel(
          userImage: 'assets/images/user.png',
          userName: 'Anonymous',
          review: e,
          daysAgo: 0,
        );
      }
      throw Exception("Invalid review data: $e");
    })
        .toList() ??
        [];
  }
}