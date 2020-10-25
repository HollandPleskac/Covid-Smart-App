import 'dart:ui';

import 'package:covid_smart_app/screens/list.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:quiver/async.dart';

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
  Location location = new Location();
  CameraPosition cameraPosition;

  Future<void> setTripId(String email) async {
    String id = await _fire.getTripId(email);
    tripId = id;
  }

  Future<void> getLocation() async {
    LocationData _locationData = await location.getLocation();
    cameraPosition = CameraPosition(
      target: LatLng(_locationData.latitude, _locationData.longitude),
      zoom: 14.4746,
    );
  }

  void endTrip() async {
    String tripIdPrevious= tripId;
    await _fire.endTrip(_firebaseAuth.currentUser.email, tripId);
    tripId = await _fire.getTripId(_firebaseAuth.currentUser.email);
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripData(tripIdPrevious),
      ),
    );
  }

  void startTrip() async {
    await _fire.startTrip(_firebaseAuth.currentUser.email);
    
    var currentTripId = await _fire.getTripId(_firebaseAuth.currentUser.email);
    _blue.scan(_firebaseAuth.currentUser.email,currentTripId);
    setState(() {});
  }

  @override
  void initState() {
    //  location.onLocationChanged.listen((result) {
    //   setState(() {
    //     print('New Location : '+result.toString());
    //     currentLocation = result;
    //   });
    // });

    setTripId(_firebaseAuth.currentUser.email).then((_) {
      getLocation().then((_) {
        setState(() {
          print('TRIP ID : ' + tripId.toString());
          print('Camera Position : ' + cameraPosition.toString());
        });
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
          LiveMap(tripId, cameraPosition),
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

class TripActions extends StatefulWidget {
  final String tripId;
  final Function endTrip;

  TripActions(this.tripId, this.endTrip);

  @override
  _TripActionsState createState() => _TripActionsState();
}

class _TripActionsState extends State<TripActions> {
  Timer _timer;
  int _start = 0;
  void startTimer() {
    const oneMin = const Duration(minutes: 1);
    _timer = new Timer.periodic(
      oneMin,
      (Timer timer) => setState(
        () {
          _start = _start + 1;
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _fire.streamTrip(widget.tripId),
      builder: (context, snapshot) {
        Trip trip = snapshot.data;
        int encounters = trip.encounters == null ? 0 : trip.encounters;
        print('start trip : ' +
            DateTime.now().difference(trip.start).inSeconds.toString());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                          child: Container(
                            child: Center(
                                child: Text(
                              "Encounters: " + encounters.toString(),
                                overflow: TextOverflow.fade,
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            )),
                            
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[700]),
                          )),
                          Padding(
                      padding: const EdgeInsets.only(left: 10),
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
                          onTap: () async => await widget.endTrip(),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                        child: Container(
                          child: Center(
                              child: Text(
                            "Trip Time: " + _start.toString() + "min",
                                overflow: TextOverflow.fade,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[700]),
                        ),
                      ),
                      Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Center(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogView(widget.tripId)),
                            );
                        },
                        child: Container(
                          child: Center(
                              child: Text(
                            "View Log",
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
                  ),
                
                ],
              )
            ],
          ),
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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          child: Text(
            'Start',
            style: TextStyle(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.w400),
          ),
          color: Colors.blue[200],
          onPressed: () async => await startTrip(),
        ),
      ),
    );
  }
}

class LiveMap extends StatelessWidget {
  final String tripId;
  final CameraPosition cameraPosition;

  LiveMap(this.tripId, this.cameraPosition);

  final Completer<GoogleMapController> _controller = Completer();

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _fire.streamEncounters(tripId),
      builder: (context, snapshot) {
        List<Encounter> encounters = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return cameraPosition == null
            ? Container()
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
                      padding: const EdgeInsets.only(right: 0),
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
                    /*
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
                    */
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.4-5,
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
