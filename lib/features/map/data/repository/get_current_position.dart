import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentPosition() async {
  bool serviceEnebled;
  LocationPermission permission;

  serviceEnebled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnebled) {
    return Future.error("Location services are disabled");
  }
  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error('Location permisson denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permisson denied forewer');
  }

  Position posistion = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  return posistion;
}
