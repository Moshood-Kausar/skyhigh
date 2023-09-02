import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../main.dart';

class MapsScreens extends StatefulWidget {
  const MapsScreens({
    Key? key,
  }) : super(key: key);

  @override
  State<MapsScreens> createState() => _MapsScreensState();
}

class _MapsScreensState extends State<MapsScreens> {
  GoogleMapController? mapController;
  LatLng? userLocation;
  @override
  void initState() {
    super.initState();
    if (userPosition == null) {
      getUserLocation();
    } else {
      userLocation = LatLng(userPosition!.latitude, userPosition!.longitude);
    }
  }

  void getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Location'),
      ),
      body: Center(
        child: userLocation == null
            ? const CircularProgressIndicator()
            : GoogleMap(
                onMapCreated: (controller) {
                  setState(() {
                    mapController = controller;
                  });
                },
                initialCameraPosition: CameraPosition(
                  target: userLocation!,
                  zoom: 15.0,
                ),
                markers: <Marker>{
                  Marker(
                    markerId: const MarkerId('userLocation'),
                    position: userLocation!,
                    infoWindow: const InfoWindow(
                      title: 'Your Location',
                    ),
                  ),
                },
              ),
      ),
    );
  }
}
