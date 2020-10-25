import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Fire {
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
}
