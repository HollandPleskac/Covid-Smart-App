import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String id;
  String email;
  DateTime start;
  int encounters;

  Trip({
    this.id,
    this.email,
    this.start,
    this.encounters,
  });

  factory Trip.fromMap(Map data, String id) {
    return Trip(
      id: id ?? '',
      email: data['email'] ?? '',
      start: DateTime.parse(data['start'].toDate().toString()) ?? DateTime.now(),
      encounters: data['encounters'] ?? 0,
    );
  }
}
