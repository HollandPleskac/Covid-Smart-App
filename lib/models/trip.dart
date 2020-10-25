import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String id;
  String email;
  int time;
  int encounters;

  Trip({
    this.id,
    this.email,
    this.time,
    this.encounters,
  });

  factory Trip.fromMap(Map data, String id) {
    return Trip(
      id: id ?? '',
      email: data['email'] ?? '',
      time: data['time'] ?? 0,
      encounters: data['encounters'] ?? 0,
    );
  }
}
