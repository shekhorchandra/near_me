import '../../../../user/category/user_category_service_details/models/ReviewModel.dart';
import 'PreviewHighlightService.dart';
import 'PreviewOfferService.dart';

class PreviewServiceDetailsModel {
  final String id;
  final String providerName;
  final String serviceName;
  final String about;
  final String phone;
  final String website;
  final String address;

  final String openingTime;
  final String closingTime;

  final bool isOpen;

  final double rating;

  final int totalReviews;

  final List<String> media;

  final String logo;

  final List<PreviewHighlightService> highlights;

  final List<PreviewOfferService> offeredServices;

  final List<ReviewModel> reviews;

  final double latitude;
  final double longitude;

  PreviewServiceDetailsModel({
    required this.id,
    required this.providerName,
    required this.serviceName,
    required this.about,
    required this.phone,
    required this.website,
    required this.address,
    required this.openingTime,
    required this.closingTime,
    required this.isOpen,
    required this.rating,
    required this.totalReviews,
    required this.media,
    required this.logo,
    required this.highlights,
    required this.offeredServices,
    required this.reviews,
    required this.latitude,
    required this.longitude,
  });

  factory PreviewServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    final coordinates = data["location"]?["coordinates"] ?? [];

    return PreviewServiceDetailsModel(
      id: data["_id"],
      providerName: data["provider_name"] ?? "",
      serviceName: data["service_name"] ?? "",
      about: data["about"] ?? "",
      phone: data["phone"] ?? "",
      website: data["website_link"] ?? "",
      address: data["service_address"] ?? "",
      openingTime: data["openingTime"] ?? "",
      closingTime: data["closingTime"] ?? "",
      isOpen: data["isOpen"] ?? false,
      rating: (data["averageRating"] ?? 0).toDouble(),
      totalReviews: data["totalReviews"] ?? 0,
      media: List<String>.from(data["media"] ?? []),
      logo: data["company_logo"] ?? "",

      highlights: (data["highlight_services"] as List? ?? [])
          .map((e) => PreviewHighlightService.fromJson(e))
          .toList(),

      offeredServices: (data["offer_services"] as List? ?? [])
          .map((e) => PreviewOfferService.fromJson(e))
          .toList(),

      reviews: (data["reviews"] as List? ?? [])
          .map((e) => ReviewModel.fromJson(e))
          .toList(),

      longitude: coordinates.isNotEmpty
          ? (coordinates[0] as num).toDouble()
          : 0.0,

      latitude: coordinates.length > 1
          ? (coordinates[1] as num).toDouble()
          : 0.0,
    );
  }
}