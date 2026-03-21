

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

  // NEW: Highlights list
  List<ServiceItem>? highlights;

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
    this.highlights,
  });
}