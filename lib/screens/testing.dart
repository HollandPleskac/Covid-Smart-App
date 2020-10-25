import 'package:flutter/material.dart';

import '../logic/fire.dart';
import '../models/encounter.dart';
import '../models/trip.dart';

final _fire = Fire();

class Testing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('testing'),
      ),
      body: StreamBuilder(
        stream: _fire.streamEncounters('WEO634lStSi5H5cgkVmx'),
        builder: (context, snapshot) {
          print(snapshot);
          List<Encounter> encounters = snapshot.data;
          return ListView(
            children: encounters
                .map((encounter) => Text(encounter.time.toString()))
                .toList(),
          );
        },
      ),
    );
  }
}

class StreamTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('testing'),
      ),
      body: StreamBuilder(
        stream: _fire.streamTrip('WEO634lStSi5H5cgkVmx'),
        builder: (context, snapshot) {
          print(snapshot);
          Trip trip = snapshot.data;
          return Text(trip.toString());
        },
      ),
    );
  }
}
