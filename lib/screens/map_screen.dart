import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapsScreens extends StatefulWidget {
  const MapsScreens({super.key});

  @override
  State<MapsScreens> createState() => _MapsScreensState();
}

class _MapsScreensState extends State<MapsScreens> {
  GoogleMapController? mapController;
  LatLng? userLocation;
  final TextEditingController _searchController = TextEditingController();
  final List<PlacePrediction> _predictions = [];
  @override
  void initState() {
    super.initState();
    getUserLocation();
    // Show the bottom sheet when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet(context);
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            SizedBox(
              height: 30,
            ),
            //Text('Find Address'),
            Padding(
              padding: const EdgeInsets.only(top: 68.0, left: 18, right: 18.0),
              child: TextField(
                controller: _searchController,
                onChanged: (input) {
                  if (input.isNotEmpty) {
                    searchPlaces(input);
                  } else {
                    setState(() {
                      _predictions.clear();
                    });
                  }
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  hintText: 'Find address',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_predictions[index].description),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
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
        title: Text('My Location'),
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

  Future<void> searchPlaces(String query) async {
    const apiKey = 'AIzaSyD6ysBfnoOV7B28zqb5Ukr7Q-GnmBx2ud4';
    final apiUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey');

    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final predictions = data['predictions'] as List<dynamic>;
        setState(() {
          _predictions.clear();
          for (var prediction in predictions) {
            _predictions.add(PlacePrediction.fromJson(prediction));
          }
        });
      }
    } else {
      throw Exception('Failed to fetch place predictions');
    }
  }
}

class PlacePrediction {
  final String description;

  PlacePrediction({required this.description});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(description: json['description']);
  }
}
