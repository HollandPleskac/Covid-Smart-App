import 'package:covid_smart_app/screens/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './all_map.dart';
import '../logic/auth.dart';

import 'package:covid_smart_app/screens/map.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final _auth = Auth();

class UserStats extends StatefulWidget {
  @override
  _UserStatsState createState() => _UserStatsState();
}

class _UserStatsState extends State<UserStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "User Stats",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 42,
                      fontWeight: FontWeight.w400),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.map,
                  color: Colors.blue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllMap(),
                    ),
                  );
                },
              ),
              IconButton(
                  icon: Icon(Icons.login),
                  onPressed: () {
                    _auth.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  }),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
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
                          Text("San Joaquin",
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 55,
                                  fontWeight: FontWeight.w300)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Most Encounters",
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
                      color: Colors.green[400],
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
                          Text("A",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 80,
                                  fontWeight: FontWeight.w300)),
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
                      color: Colors.purple[200],
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
                          StreamBuilder(
                            stream: _firestore
                                .collection('Trips')
                                .where('email',
                                    isEqualTo: _firebaseAuth.currentUser.email)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              }
                              return Text(
                                snapshot.data.docs.length.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 80,
                                    fontWeight: FontWeight.w300),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Total Trips",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.deepOrange[200],
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
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          StreamBuilder(
                            stream: _firestore
                                .collection('Trips')
                                .where('email',
                                    isEqualTo: _firebaseAuth.currentUser.email)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              }
                              return Text(snapshot.data.docs.length.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 80,
                                      fontWeight: FontWeight.w300));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Todays Trips",
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
                          StreamBuilder(
                            stream: _firestore
                                .collection('Logs')
                                .where('email',
                                    isEqualTo: _firebaseAuth.currentUser.email)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Container();
                              }
                              return Text(
                                snapshot.data.docs.length.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 80,
                                    fontWeight: FontWeight.w300),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Total Encounters",
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapScreen()),
          );
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}
