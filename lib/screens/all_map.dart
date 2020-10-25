import 'dart:async';

import 'package:covid_smart_app/models/encounter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../logic/fire.dart';

final _fire = Fire();

class AllMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LiveMap(),
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
  final Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _fire.streamAllEncounters(),
      builder: (context, snapshot) {
        List<Encounter> encounters = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
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
