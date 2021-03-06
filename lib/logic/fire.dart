import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:random_string/random_string.dart';

import '../models/encounter.dart';
import '../models/trip.dart';
import './blue.dart';

final _blue = Blue();

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Fire {
  Future<void> startTrip(String email) async {
    String id = randomAlphaNumeric(10);
    await _firestore.collection("Trips").doc(id).set({
      'start': DateTime.now(),
      'end': DateTime.now(),
      'encounters': 0,
      'email':email,
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
      'end': DateTime.now(),
    });
  }

  Future<void> logEncounter({
    @required String county,
    @required String email,
    @required DateTime time,
    @required double lat,
    @required double lng,
    @required String tripId,
  }) async {
    await _firestore.collection("Logs").doc().set({
      'coords': {'lat': lat, 'lng': lng},
      'county': county,
      'email': email,
      'time': time,
      'trip id':tripId,
      'street': 'street name',
    });

    await _firestore.collection("Trips").doc(tripId).update({"encounters":FieldValue.increment(1)});
  }

  Stream<List<Encounter>> streamEncounters(String tripId) {
    var ref = _firestore.collection("Logs").where('trip id', isEqualTo: tripId);

    return ref.snapshots().map(
          (list) => list.docs
              .map(
                (doc) => Encounter.fromMap(doc, doc.id),
              )
              .toList(),
        );
  }

  Stream<List<Encounter>> streamAllEncounters(String email) {
    var ref = _firestore.collection("Logs").where('email', isEqualTo: email);

    return ref.snapshots().map(
      (list) {
        print('LIST : '+list.docs.toString());
        return list.docs
            .map(
              (doc) => Encounter.fromMap(doc, doc.id),
            )
            .toList();
      },
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
