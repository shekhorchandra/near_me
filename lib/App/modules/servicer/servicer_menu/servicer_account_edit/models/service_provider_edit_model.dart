// import 'dart:io';
// import '../../../servicer_highlight/servicer_highlights_page/model/servicer_highlight_model.dart';
//
// class ServiceProviderEditModel {
//   String serviceName;
//   String category;
//   List<String> selectedServices;
//   String contactNumber;
//   String about;
//   String address;
//   String website;
//   List<String> images;
//   String logo;
//   bool is24Hours;
//   List<ServiceItem> highlights;
//
//   ServiceProviderEditModel({
//     this.serviceName = '',
//     this.category = '',
//     this.selectedServices = const [],
//     this.contactNumber = '',
//     this.about = '',
//     this.address = '',
//     this.website = '',
//     this.images = const [],
//     this.logo = '',
//     this.is24Hours = false,
//     this.highlights = const [],
//   });
//
//   factory ServiceProviderEditModel.fromApi(Map<String, dynamic> json) {
//     final data = json['data'];
//
//     return ServiceProviderEditModel(
//       serviceName: data['service_name'] ?? '',
//       category: data['service_category']?['name'] ?? '',
//
//       selectedServices: (data['offer_services'] as List?)
//           ?.map((e) => e['name'].toString())
//           .toList() ??
//           [],
//
//       contactNumber: data['phone']?.toString() ?? '',
//       about: data['about'] ?? '',
//       address: data['location']?['address'] ?? '',
//       website: data['website_link'] ?? '',
//
//       images: (data['media'] as List?)?.cast<String>() ?? [],
//       logo: data['company_logo'] ?? '',
//
//       is24Hours: data['allTimeAvailability'] ?? false,
//     );
//   }
// }
//
// // class ServiceModel {
// //   final String id;
// //   final String serviceName;
// //   final String serviceAddress;
// //   final String about;
// //   final String websiteLink;
// //   final String companyLogo;
// //   final List<String> media;
// //   final String openingTime;
// //   final String closingTime;
// //
// //   ServiceModel({
// //     required this.id,
// //     required this.serviceName,
// //     required this.serviceAddress,
// //     required this.about,
// //     required this.websiteLink,
// //     required this.companyLogo,
// //     required this.media,
// //     required this.openingTime,
// //     required this.closingTime,
// //   });
// //
// //   factory ServiceModel.fromJson(Map<String, dynamic> json) {
// //     return ServiceModel(
// //       id: json['_id'],
// //       serviceName: json['service_name'] ?? '',
// //       serviceAddress: json['service_address'] ?? '',
// //       about: json['about'] ?? '',
// //       websiteLink: json['website_link'] ?? '',
// //       companyLogo: json['company_logo'] ?? '',
// //       media: List<String>.from(json['media'] ?? []),
// //       openingTime: json['openingTime'] ?? '',
// //       closingTime: json['closingTime'] ?? '',
// //     );
// //   }
// // }
// //
// // class CategoryNode {
// //   final String id;
// //   final String name;
// //   final List<CategoryNode> children;
// //
// //   CategoryNode({
// //     required this.id,
// //     required this.name,
// //     required this.children,
// //   });
// //
// //   factory CategoryNode.fromJson(Map<String, dynamic> json) {
// //     return CategoryNode(
// //       id: json['_id'],
// //       name: json['name'],
// //       children: (json['children'] as List)
// //           .map((e) => CategoryNode.fromJson(e))
// //           .toList(),
// //     );
// //   }
// // }