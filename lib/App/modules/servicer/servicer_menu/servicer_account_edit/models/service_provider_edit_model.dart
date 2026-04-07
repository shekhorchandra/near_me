import '../../../servicer_highlight/servicer_highlights_page/model/servicer_highlight_model.dart';

class ServiceProviderEditModel {
  String serviceName;
  String category;
  List<String> selectedServices;
  String contactNumber;
  String about;
  String address;
  String website;
  List<String> images;
  String logo;
  bool is24Hours;
  List<ServiceItem> highlights;

  ServiceProviderEditModel({
    this.serviceName = '',
    this.category = '',
    this.selectedServices = const [],
    this.contactNumber = '',
    this.about = '',
    this.address = '',
    this.website = '',
    this.images = const [],
    this.logo = '',
    this.is24Hours = false,
    this.highlights = const [],
  });

  /// From JSON
  factory ServiceProviderEditModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderEditModel(
      serviceName: json['serviceName'] ?? '',
      category: json['category'] ?? '',
      selectedServices: json['selectedServices'] != null
          ? List<String>.from(json['selectedServices'])
          : [],
      contactNumber: json['contactNumber'] ?? '',
      about: json['about'] ?? '',
      address: json['address'] ?? '',
      website: json['website'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      logo: json['logo'] ?? '',
      is24Hours: json['is24Hours'] ?? false,
      highlights: json['highlights'] != null
          ? List<ServiceItem>.from(
          json['highlights'].map((x) => ServiceItem.fromJson(x)))
          : [],
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceName,
      'category': category,
      'selectedServices': selectedServices,
      'contactNumber': contactNumber,
      'about': about,
      'address': address,
      'website': website,
      'images': images,
      'logo': logo,
      'is24Hours': is24Hours,
      'highlights': highlights.map((e) => e.toJson()).toList(),
    };
  }
}