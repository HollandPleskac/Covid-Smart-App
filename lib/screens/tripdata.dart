import 'dart:ui';

import 'package:covid_smart_app/models/trip.dart';
import 'package:covid_smart_app/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../logic/fire.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

final _fire = Fire();

class TripData extends StatefulWidget {
  final String tripId;

  TripData(this.tripId);

  @override
  _TripDataState createState() => _TripDataState();
}

class _TripDataState extends State<TripData> {
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
                          widget.tripId == ""
                              ? NAText()
                              : StreamBuilder(
                                  stream: _fire.streamTrip(widget.tripId),
                                  builder: (context, snapshot) {
                                    Trip trip = snapshot.data;
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
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
                          widget.tripId == ""
                              ? NAText()
                              : StreamBuilder(
                                  stream: _fire.streamTrip(widget.tripId),
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
                          widget.tripId == ""
                              ? NAText()
                              : StreamBuilder(
                                  stream: _fire.streamTrip(widget.tripId),
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
                          widget.tripId == ""
                              ? NAText()
                              : StreamBuilder(
                                  stream: _fire.streamTrip(widget.tripId),
                                  builder: (context, snapshot) {
                                    Trip trip = snapshot.data;
                                    int tripenounters =
                                        trip.encounters.toInt();
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    }
                                    if (tripenounters == 0) {
                                      return Text(
                                        "S",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 80,
                                            fontWeight: FontWeight.w300),
                                      );  
                                    }else if ( 5 > tripenounters  && tripenounters > 0) {
                                      return Text(
                                        "A",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 80,
                                            fontWeight: FontWeight.w300),
                                      );  
                                    }
                                    else if ( 9 > tripenounters  && tripenounters > 4) {
                                      return Text(
                                        "B",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 80,
                                            fontWeight: FontWeight.w300),
                                      );  
                                    }
                                    else if ( 15 > tripenounters  && tripenounters > 8) {
                                      return Text(
                                        "C",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 80,
                                            fontWeight: FontWeight.w300),
                                      );  
                                    }
                                    else {
                                      return Text(
                                        "D",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 80,
                                            fontWeight: FontWeight.w300),
                                      );  
                                    }

                                    
                                  }),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapScreen()),
                            );
        },
        child: Icon(Icons.arrow_back_ios,color: Colors.white,),
        backgroundColor: Colors.black,
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
