import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
Future<Position> getCurrentLocation(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // AppFunction.showAlert(
    //     context, 'Location services are disabled. Please enable the services',
    //     type: AlertType.error);

    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // AppFunction.showAlert(context, 'Location permissions are denied',
      //     type: AlertType.error);

      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // if (!context.mounted) return;
    // AppFunction.showAlert(context,
    //     'Location permissions are permanently denied, we cannot request permissions.',
    //     type: AlertType.error);

    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
    // forceAndroidLocationManager: true,
  );
}

  