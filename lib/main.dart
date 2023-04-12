import 'package:flutter/material.dart';
import 'package:googlemapsapp/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapsapp/places.dart';
// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Demo',
      home: Home(),
    );
  }
}
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Map Demo',
//       home: MapScreen(
//         startLocation: LatLng(37.4220, -122.0841),
//         endLocation: LatLng(37.7749, -122.4194),
//       ),
//     );
//   }
// }
