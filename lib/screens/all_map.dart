import 'dart:async';

import 'package:covid_smart_app/models/encounter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

import '../logic/fire.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final _fire = Fire();

class AllMap extends StatefulWidget {
  @override
  _AllMapState createState() => _AllMapState();
}

class _AllMapState extends State<AllMap> {
  CameraPosition cameraPosition;

  Future<void> getLocation() async {
    Location location = new Location();
    LocationData _locationData = await location.getLocation();
    cameraPosition = CameraPosition(
      target: LatLng(_locationData.latitude, _locationData.longitude),
      zoom: 14.4746,
    );
  }

  @override
  void initState() {
    getLocation().then((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LiveMap(cameraPosition),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LiveMap extends StatelessWidget {
  CameraPosition cameraPosition;

  LiveMap(this.cameraPosition);
  final Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _fire.streamAllEncounters(_firebaseAuth.currentUser.email),
      builder: (context, snapshot) {
        List<Encounter> encounters = snapshot.data;
        print('ENCOUNTER DATA : '+encounters.toString());

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return cameraPosition == null
            ? Container
            : GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                circles: Set.from(
                  encounters.map(
                    (encounter) {
                      print(encounter.coords);
                      return Circle(
                          circleId: CircleId(encounter.id),
                          center: LatLng(
                            encounter.coords['lat'],
                            encounter.coords['lng'],
                          ),
                          radius: 50,
                          fillColor: Colors.red.withOpacity(0.5),
                          strokeWidth: 0,
                          visible: true);
                    },
                  ),
                ),
              );
      },
    );
  }
}
