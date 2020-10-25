import 'package:cloud_firestore/cloud_firestore.dart';

class Encounter {
  String id;
  String email;
  String county;
  DateTime time;
  Map coords;

  Encounter({this.id, this.email, this.county, this.time, this.coords});

  factory Encounter.fromMap(DocumentSnapshot snapshot, String id) {
    return Encounter(
      id: id ?? '',
      email: snapshot['email'] ?? '',
      county: snapshot['county'] ?? '',
      time: DateTime.parse(snapshot['time'].toDate().toString()) ?? DateTime.now(),
      coords: snapshot['coords'] ?? {},
    );
  }
}
