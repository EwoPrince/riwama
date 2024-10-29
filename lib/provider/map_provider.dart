import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final mapProvider =
    ChangeNotifierProvider<MapProviders>((ref) => MapProviders());

class MapProviders extends ChangeNotifier {
  Position? _position;

  Position? get position => _position;

  Future<bool> fetchLocation() async {
    // Check and request location permission
    if (await Permission.location.isGranted) {
      try {
        Position xposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
        );

        LatLng latLngPosition = LatLng(xposition.latitude, xposition.longitude);
        print(latLngPosition);

        _position = xposition;

        notifyListeners();
      } catch (e) {
        print("Error getting location: $e");
      }
      return true;
    } else {
      // Request the location permission
      PermissionStatus status = await Permission.location.request();
      if (status.isGranted) {
        // Permission granted, fetch the location again
        await fetchLocation();
      } else {
        print("Location permission not granted.");
        // Handle the case when the user denies the permission request.
      }
      return false;
    }
  }
}
