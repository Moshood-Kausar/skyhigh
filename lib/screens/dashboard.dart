import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skyhigh/screens/charts.dart';
import 'package:skyhigh/screens/lat_long.dart';
import 'package:skyhigh/screens/map_screen.dart';
import 'package:skyhigh/screens/search_location.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final List<Widget> screens = [
    const ChartScreen(),
    (SearchLocation()),
  ];

  Position? userLocation;
  int currentIndex = 0;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (value) => setState(() {
          currentIndex = value;
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Charts'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: 'Location'),
        ],
      ),
    );
  }
}
