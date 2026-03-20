// class HomeServiceModel {
//   final String id;
//   final String title;
//   final double rating;
//   final double distance;
//   final bool available;
//   final double lat;
//   final double lng;
//   final String servicer_highlight;
//
//   HomeServiceModel({
//     required this.id,
//     required this.title,
//     required this.rating,
//     required this.distance,
//     required this.available,
//     required this.lat,
//     required this.lng,
//     required this.servicer_highlight,
//   });
//
//   factory HomeServiceModel.fromJson(Map<String, dynamic> json) {
//     return HomeServiceModel(
//       id: json['_id'],
//       title: json['title'],
//       rating: (json['rating'] ?? 0).toDouble(),
//       distance: (json['distance'] ?? 0).toDouble(),
//       available: json['available'] ?? false,
//       lat: json['lat'],
//       lng: json['lng'],
//       servicer_highlight: '',
//     );
//   }
// }