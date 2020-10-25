import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/tripdata.dart';
import '../screens/userstats.dart';
import '../logic/fire.dart';
import '../logic/blue.dart';
import '../models/trip.dart';
import '../models/encounter.dart';

import 'dart:async';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

final _fire = Fire();
final _blue = Blue();

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  String tripId;

  Future<void> setTripId(String email) async {
    String id = await _fire.getTripId(email);
    tripId = id;
  }

  void endTrip() async {
    await _fire.endTrip(_firebaseAuth.currentUser.email, tripId);
    tripId = await _fire.getTripId(_firebaseAuth.currentUser.email);
    setState(() {
      
    });
  }

  void startTrip() async {
    await _fire.startTrip(_firebaseAuth.currentUser.email);
    _blue.scan(_firebaseAuth.currentUser.email);
    tripId = await _fire.getTripId(_firebaseAuth.currentUser.email);

    setState(() {});
  }

  @override
  void initState() {
    setTripId(_firebaseAuth.currentUser.email).then((_) {
      setState(() {
        print('TRIP ID : ' + tripId.toString());
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          // google map
          LiveMap(tripId),
          // overlay over the google map
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
                          child: tripId == ""
                              ? StartTrip(() => startTrip())
                              : TripActions(tripId, () => endTrip()),
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
              BottomNav(),
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
}

class TripActions extends StatelessWidget {
  final String tripId;
  final Function endTrip;

  TripActions(this.tripId, this.endTrip);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _fire.streamTrip(tripId),
      builder: (context, snapshot) {
        Trip trip = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return Row(
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
                            "Encounters: " + trip.encounters.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                          constraints:
                              BoxConstraints(minWidth: 100, maxWidth: 210),
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
                            "Trip Time: " +
                                DateTime.now()
                                    .difference(trip.start)
                                    .inDays
                                    .toString() +
                                "min",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                          constraints:
                              BoxConstraints(minWidth: 100, maxWidth: 210),
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
                      child: GestureDetector(
                        child: Container(
                          child: Center(
                            child: Text(
                              "End Trip",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          width:
                              MediaQuery.of(context).size.width * 0.75 / 2 - 15,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red[300]),
                        ),
                        onTap: () async => await endTrip(),
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
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                        width:
                            MediaQuery.of(context).size.width * 0.75 / 2 - 15,
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
        );
      },
    );
  }
}

class StartTrip extends StatelessWidget {
  Function startTrip;

  StartTrip(this.startTrip);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: FlatButton(
        child: Text('Start'),
        color: Colors.blue[300],
        onPressed:() async => await startTrip(),
      ),
    );
  }
}

class LiveMap extends StatelessWidget {
  final String tripId;

  LiveMap(this.tripId);

  final Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _fire.streamEncounters(tripId),
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

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserStats()),
                            );
                          },
                          child: Container(
                            child: Center(
                                child: Text(
                              "User Stats",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                            width:
                                MediaQuery.of(context).size.width * 0.75 / 2 -
                                    15,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.purple[200]),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TripData()),
                            );
                          },
                          child: Container(
                            child: Center(
                                child: Text(
                              "View Log",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                            width:
                                MediaQuery.of(context).size.width * 0.75 / 2 -
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
    );
  }
}
