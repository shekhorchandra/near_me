import 'LocationModel.dart';

class ServiceProviderModel {

  String planId;
  String serviceName;
  String category;
  List<String> selectedServices;
  String contactNumber;
  String about;
  String address;
  String website;
  LocationModel location;
  List<String> images;
  String logo;
  String openingTime;
  String closingTime;
  bool is24Hours;
  String subscriptionPlan;
  double subscriptionPrice;

  ServiceProviderModel({

    this.planId = '',
    this.serviceName = '',
    this.category = '',
    this.selectedServices = const [],
    this.contactNumber = '',
    this.about = '',
    this.address = '',
    this.website = '',
    this.location = const LocationModel(),
    this.images = const [],
    this.logo = '',
    this.openingTime = '',
    this.closingTime = '',
    this.is24Hours = false,
    this.subscriptionPlan = 'Free Plan (£0/month)',
    this.subscriptionPrice = 0.0,
  });
}