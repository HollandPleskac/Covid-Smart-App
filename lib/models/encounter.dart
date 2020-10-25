import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Encounter {
  String id;
  String email;
  String county;
  DateTime time;
  Map coords;
  String tripId;
  
  

  Encounter({this.id, this.email, this.county, this.time, this.coords, this.tripId});

  factory Encounter.fromMap(DocumentSnapshot snapshot, String id) {
    return Encounter(
      id: id ?? '',
      email: snapshot['email'] ?? '',
      county: snapshot['county'] ?? '',
      time: DateTime.parse(snapshot['time'].toDate().toString()) ?? DateTime.now(),
      coords: snapshot['coords'] ?? {},
      tripId: snapshot['trip id'] ?? '',
     
    );
  }
}
