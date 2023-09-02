import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:skyhigh/screens/charts.dart';
import 'package:skyhigh/screens/dashboard.dart';

Position? userPosition;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .then((value) {
    log(value.toString(), name: 'position');
    userPosition = value;
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider<ChartProvider>(
        create: (context) => ChartProvider(),
        child: const DashBoard()),
    );
  }
}
