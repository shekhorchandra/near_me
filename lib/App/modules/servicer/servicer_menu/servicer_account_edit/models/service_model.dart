// class ServiceModel {
//   final String id;
//   final String name;
//   final String address;
//   final String about;
//   final String website;
//   final String logo;
//   final List<String> media;
//
//   ServiceModel({
//     required this.id,
//     required this.name,
//     required this.address,
//     required this.about,
//     required this.website,
//     required this.logo,
//     required this.media,
//   });
//
//   factory ServiceModel.fromJson(Map<String, dynamic> json) {
//     return ServiceModel(
//       id: json['_id'] ?? '',
//       name: json['service_name'] ?? '',
//       address: json['service_address'] ?? '',
//       about: json['about'] ?? '',
//       website: json['website_link'] ?? '',
//       logo: json['company_logo'] ?? '',
//       media: (json['media'] as List?)?.cast<String>() ?? [],
//     );
//   }
// }