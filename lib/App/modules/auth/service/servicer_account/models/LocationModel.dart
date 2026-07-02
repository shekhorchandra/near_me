class LocationModel {
  final String type;
  final List<double> coordinates;
  final String address;

  const LocationModel({
    this.type = '',
    this.coordinates = const [],
    this.address = '',
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
          const [],
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates,
    "address": address,
  };
}