import 'package:geolocator/geolocator.dart';

Future<Position?> getCurrentLocation() async {
  print("📍 LOCATION FUNCTION STARTED");

  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  print("Service Enabled: $serviceEnabled");

  if (!serviceEnabled) {
    print('❌ Location services are disabled.');
    return null;
  }

  permission = await Geolocator.checkPermission();
  print("Current Permission: $permission");

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    print("After Request Permission: $permission");

    if (permission == LocationPermission.denied) {
      print('❌ Location permissions are denied');
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('❌ Location permissions are permanently denied.');
    return null;
  }

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  print("✅ LOCATION FETCHED");
  print("LAT: ${position.latitude}");
  print("LNG: ${position.longitude}");

  return position;
}