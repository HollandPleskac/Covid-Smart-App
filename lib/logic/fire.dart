import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/encounter.dart';
import '../models/trip.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Fire {
  Future<void> startTrip(String email) async {
    String id = DateTime.now().toString();
    await _firestore.collection("Trips").doc(id).set({
      'start': DateTime.now(),
      'end': null,
      'encounters': 0,
    });

   await _firestore.collection("Users").doc(email).update(
      {'current trip': id},
    );
  }

  Future<void> endTrip(String email, String tripId) async {
    await _firestore.collection('Users').doc(email).update({
      'current trip': '',
    });

    await _firestore.collection('Trips').doc(tripId).update({
      'end trip': DateTime.now(),
    });
  }

  Future<void> logEncounter({
    String county,
    String email,
    DateTime time,
    double lat,
    double lng,
  }) async {
    await _firestore.collection("Logs").doc().set({
      'coords': {'lat': lng, 'lng': lat},
      'county': county,
      'email': email,
      'time': time,
    });
  }

  Stream<List<Encounter>> streamEncounters(String tripId) {
    var ref = _firestore.collection("Logs").where('trip id', isEqualTo: tripId);

    return ref.snapshots().map(
          (list) => list.docs.map((doc) =>
            
            Encounter.fromMap(doc, doc.id),
          ).toList(),
        );
  }

  Stream<List<Encounter>> streamAllEncounters() {
    var ref = _firestore.collection("Logs");

    return ref.snapshots().map(
          (list) => list.docs.map((doc) =>
            
            Encounter.fromMap(doc, doc.id),
          ).toList(),
        );
  }

  Stream<Trip> streamTrip(String tripId) {
    return _firestore.collection('Trips').doc(tripId).snapshots().map((snap) {
      return Trip.fromMap(snap.data(), snap.id);
    });
  }

  Future<String> getTripId(String email) async {
    return await _firestore.collection('Users').doc(email).get().then(
          (snap) => snap['current trip'],
        );
  }
}
