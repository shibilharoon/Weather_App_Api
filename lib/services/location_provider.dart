import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_final/services/location_service.dart';

class LocationProvider with ChangeNotifier {
  Position? currentPosition;
  final LocationService locationService = LocationService();
  Placemark? currentLocationName;

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      currentPosition = null;
      notifyListeners();
       return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        currentPosition = null;
        notifyListeners();
         return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      currentPosition = null;
      notifyListeners();
       return;
    }
    currentPosition = await Geolocator.getCurrentPosition();
    print(currentPosition);
    currentLocationName =
        await locationService.getLocationName(currentPosition);
    print(currentLocationName);
    notifyListeners();
  }
}
