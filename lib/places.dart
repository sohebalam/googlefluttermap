import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:googlemapsapp/map.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String googleApikey =
      "AIzaSyCY8J7h0Q-5Q1UDP9aY0EOy_WZBPESNBBg"; //replace with your own Google API key
  GoogleMapController? mapController; //controller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(27.6602292, 85.308027);
  String sourceLocation = "Search Source Location";
  String destinationLocation = "Search Destination Location";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Place Search Autocomplete Google Map"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Stack(children: [
          // GoogleMap(
          //   //Map widget from google_maps_flutter package
          //   zoomGesturesEnabled: true, //enable Zoom in, out on map
          //   initialCameraPosition: CameraPosition(
          //     //initial position in map
          //     target: startLocation, //initial position
          //     zoom: 14.0, //initial zoom level
          //   ),
          //   mapType: MapType.normal, //map type
          //   onMapCreated: (controller) {
          //     //method called when map is created
          //     setState(() {
          //       mapController = controller;
          //     });
          //   },
          // ),

          //search autocomplete inputs
          Positioned(
              //source input bar
              top: 10,
              left: 10,
              child: InkWell(
                  onTap: () async {
                    var place = await PlacesAutocomplete.show(
                        context: context,
                        apiKey: googleApikey,
                        mode: Mode.overlay,
                        types: [],
                        strictbounds: false,
                        components: [Component(Component.country, 'uk')],
                        //google_maps_webservice package
                        onError: (err) {
                          print(err);
                        });

                    if (place != null) {
                      setState(() {
                        sourceLocation = place.description.toString();
                      });

                      //get details of the selected place
                      final plist = GoogleMapsPlaces(
                        apiKey: googleApikey,
                        apiHeaders: await GoogleApiHeaders().getHeaders(),
                        //google_api_headers package
                      );
                      String placeid = place.placeId ?? "0";
                      final detail = await plist.getDetailsByPlaceId(placeid);
                      final geometry = detail.result.geometry!;
                      final lat = geometry.location.lat;
                      final lang = geometry.location.lng;
                      var source = LatLng(lat, lang);

                      //move map camera to selected place with animation
                      mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: source, zoom: 17)));
                      print('Source Location: $sourceLocation');
                      print('Source Location: $source');
                      // print('Source Location Lat: ${geometry.location.lat}');
                      // print('Source Location Lng: ${geometry.location.lng}');
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width / 2 - 25,
                          child: ListTile(
                            title: Text(
                              sourceLocation,
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: Icon(Icons.search),
                            dense: true,
                          )),
                    ),
                  ))),

          Positioned(
              //destination input bar
              top: 10,
              right: 10,
              child: InkWell(
                  onTap: () async {
                    var place = await PlacesAutocomplete.show(
                        context: context,
                        apiKey: googleApikey,
                        mode: Mode.overlay,
                        types: [],
                        strictbounds: false,
                        components: [Component(Component.country, 'uk')],
                        onError: (err) {
                          print(err);
                        });

                    if (place != null) {
                      setState(() {
                        destinationLocation = place.description.toString();
                      });

                      //get details of the selected place
                      final plist = GoogleMapsPlaces(
                        apiKey: googleApikey,
                        apiHeaders: await GoogleApiHeaders().getHeaders(),
                      );
                      String placeid = place.placeId ?? "0";
                      final detail = await plist.getDetailsByPlaceId(placeid);
                      final geometry = detail.result.geometry!;
                      final lat = geometry.location.lat;
                      final lang = geometry.location.lng;
                      var destination = LatLng(lat, lang);

                      //move map camera to selected place with animation
                      mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: destination, zoom: 17)));

                      print('Destination Location: $destinationLocation');
                      print('Destination Location: $destination');
                      // print(
                      //     'Destination Location Lat: ${geometry.location.lat}');
                      // print(
                      //     'Destination Location Lng: ${geometry.location.lng}');
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width / 2 - 25,
                          child: ListTile(
                            title: Text(
                              destinationLocation,
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: Icon(Icons.search),
                            dense: true,
                          )),
                    ),
                  ))),
        ]));
  }
}
