import 'dart:ui';

import 'package:covid_smart_app/models/trip.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../logic/fire.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

final _fire = Fire();

class TripData extends StatefulWidget {
  @override
  _TripDataState createState() => _TripDataState();
}

class _TripDataState extends State<TripData> {
  String tripId;

  Future<void> setTripId(String email) async {
    String id = await _fire.getTripId(email);
    tripId = id;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Center(
              child: Text("Trip Report",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 42,
                      fontWeight: FontWeight.w400))),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 2 - 20,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          tripId == ""
                              ? NAText()
                              : StreamBuilder(
                                  stream: _fire.streamTrip(tripId),
                                  builder: (context, snapshot) {
                                    Trip trip = snapshot.data;
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Container();
                                    }
                                    return Text(
                                      trip.encounters.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 80,
                                          fontWeight: FontWeight.w300),
                                    );
                                  }),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Trip Total",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.pink[200],
                      borderRadius: BorderRadius.circular(30)),
                ),
                Container(
                  height: MediaQuery.of(context).size.width / 2 - 20,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          tripId == ""
                              ? NAText()
                              : StreamBuilder(
                                  stream: _fire.streamTrip(tripId),
                                  builder: (context, snapshot) {
                                    Trip trip = snapshot.data;
                                    return Text(
                                      "1",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 80,
                                          fontWeight: FontWeight.w300),
                                    );
                                  }),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("High Risk Trips",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(30)),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 2 - 20,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Tracy",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 80,
                                  fontWeight: FontWeight.w300)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Hot Spot",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.purple[200],
                      borderRadius: BorderRadius.circular(30)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 2 - 20,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          tripId == ""
                              ? NAText()
                              : StreamBuilder(
                                  stream: _fire.streamTrip(tripId),
                                  builder: (context, snapshot) {
                                    Trip trip = snapshot.data;
                                    int time = trip == null
                                        ? 0
                                        : DateTime.now()
                                            .difference(trip.start)
                                            .inMinutes;

                                    return Text(
                                      time.toString() + 'm',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 80,
                                          fontWeight: FontWeight.w300),
                                    );
                                  },
                                ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Time",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.orange[300],
                      borderRadius: BorderRadius.circular(30)),
                ),
                Container(
                  height: MediaQuery.of(context).size.width / 2 - 20,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          tripId == ""
                              ? NAText()
                              : StreamBuilder(
                                  stream: _fire.streamTrip(tripId),
                                  builder: (context, snapshot) {
                                    return Text(
                                      "7",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 80,
                                          fontWeight: FontWeight.w300),
                                    );
                                  },
                                ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Rating",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.lightGreen[400],
                      borderRadius: BorderRadius.circular(30)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NAText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'NA',
      style: TextStyle(
          color: Colors.white, fontSize: 80, fontWeight: FontWeight.w300),
    );
  }
}
