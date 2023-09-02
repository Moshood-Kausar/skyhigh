import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:skyhigh/screens/map_screen.dart';

class SearchLocation extends StatefulWidget {
 
  const SearchLocation({Key? key, }) : super(key: key);

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  LatLng? userLocation;
  final TextEditingController _searchController = TextEditingController();
  final List<PlacePrediction> _predictions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
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
                   
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapsScreens(
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
          //_predictions.clear();
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
