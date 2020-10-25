import 'dart:ui';

import 'package:covid_smart_app/screens/tripdata.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:async';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  bool searching = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: RotatedBox(
                  quarterTurns: 0,
                  child: Center(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 20.0,
                          sigmaY: 20.0,
                        ),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Center(
                                    child: Expanded(
                                      child: Container(
                                        child: Center(
                                            child: Text(
                                          "Encounters: 25",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        )),
                                        constraints: BoxConstraints(minWidth: 100, maxWidth: 210),
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.grey[700]),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Center(
                                    child: Expanded(
                                      child: Container(
                                        child: Center(
                                            child: Text(
                                          "Trip Time: 420min",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        )),
                                        constraints: BoxConstraints(minWidth: 100, maxWidth: 210),
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.grey[700]),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Center(
                                        child: Container(
                                          child: Center(
                                              child: Text(
                                            "End Trip",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 20),
                                          )),
                                          width: MediaQuery.of(context).size.width *
                                                  0.75 /
                                                  2 -
                                              15,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.red[300]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Center(
                                        child: Container(
                                          child: Center(
                                              child: Text(
                                            "Pause Trip",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 20),
                                          )),
                                          width: MediaQuery.of(context).size.width *
                                                  0.75 /
                                                  2 -
                                              15,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.deepOrange[300]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 130,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(0.7)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: RotatedBox(
                  quarterTurns: 0,
                  child: Center(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 20.0,
                          sigmaY: 20.0,
                        ),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Center(
                                  child: Container(
                                    child: Center(
                                        child: Text(
                                      "User Stats",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                                    width: MediaQuery.of(context).size.width *
                                            0.75 /
                                            2 -
                                        15,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.purple[200]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TripData()),
  );
                                    },
                                    child: Container(
                                      child: Center(
                                          child: Text(
                                        "View Log",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )),
                                      width: MediaQuery.of(context).size.width *
                                              0.75 /
                                              2 -
                                          15,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.green[200]),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              color: Colors.black.withOpacity(0.7)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      //floatingActionButton: FloatingActionButton.extended(
      //  onPressed: _goToTheLake,
      //  label: Text('To the lake!'),
      //  icon: Icon(Icons.directions_boat),
      //),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
