import 'package:flutter/material.dart';

import '../logic/fire.dart';
import '../models/encounter.dart';

final _fire = Fire();

class Testing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('testing'),
      ),
      body: StreamBuilder(
        stream: _fire.streamEncounters(),
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
