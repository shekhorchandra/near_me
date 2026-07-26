class MyServiceModel {
  final String id;
  final String serviceName;
  final String providerName;
  final String providerEmail;
  final String companyLogo;
  final String categoryName;
  final String serviceAddress;
  final String phone;
  final String about;
  final String websiteLink;
  final String openingTime;
  final String closingTime;
  final String subscriptionStatus;
  final String planName;
  final double averageRating;
  final bool allTimeAvailability;
  final List<String> media;

  const MyServiceModel({
    required this.id,
    required this.serviceName,
    required this.providerName,
    required this.providerEmail,
    required this.companyLogo,
    required this.categoryName,
    required this.serviceAddress,
    required this.phone,
    required this.about,
    required this.websiteLink,
    required this.openingTime,
    required this.closingTime,
    required this.subscriptionStatus,
    required this.planName,
    required this.averageRating,
    required this.allTimeAvailability,
    required this.media,
  });

  factory MyServiceModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final provider = _toMap(json["provider"]);
    final subscriptionInfo =
    _toMap(provider["subscriptionInfo"]);
    final serviceCategory =
    _toMap(json["service_category"]);

    final mediaData = json["media"];

    return MyServiceModel(
      id: json["_id"]?.toString() ?? "",
      serviceName:
      json["service_name"]?.toString() ?? "",
      providerName:
      json["provider_name"]?.toString() ??
          provider["name"]?.toString() ??
          "",
      providerEmail:
      provider["email"]?.toString() ?? "",
      companyLogo:
      json["company_logo"]?.toString() ?? "",
      categoryName:
      serviceCategory["name"]?.toString() ?? "",
      serviceAddress:
      json["service_address"]?.toString() ?? "",
      phone: json["phone"]?.toString() ?? "",
      about: json["about"]?.toString() ?? "",
      websiteLink:
      json["website_link"]?.toString() ?? "",
      openingTime:
      json["openingTime"]?.toString() ?? "",
      closingTime:
      json["closingTime"]?.toString() ?? "",
      subscriptionStatus:
      json["subscriptionStatus"]?.toString() ?? "",
      planName:
      subscriptionInfo["planName"]?.toString() ??
          "",
      averageRating:
      _toDouble(json["averageRating"]),
      allTimeAvailability:
      json["allTimeAvailability"] == true,
      media: mediaData is List
          ? mediaData
          .map((item) => item.toString())
          .where((item) => item.isNotEmpty)
          .toList()
          : [],
    );
  }

  static Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? "",
    ) ??
        0;
  }
}