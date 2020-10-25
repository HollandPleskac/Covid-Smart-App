import 'package:flutter/material.dart';
import '../logic/fire.dart';
import '../models/encounter.dart';

final _fire = Fire();

class LogView extends StatefulWidget {
  final String tripId;

  LogView(this.tripId);
  @override
  _LogViewState createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _fire.streamEncounters(widget.tripId),
        builder: (context, snapshot) {
          List<Encounter> encounters = snapshot.data;
          print('encounter dataa + '+encounters.toString());
          if (encounters == null || encounters.length == 0) {
            return Center(child: Text('no encounters'));
          }
          return Padding(
            padding: EdgeInsets.only(top:20),
                      child: ListView(
              children: encounters
                  .map(
                    (e) => Column(
                      children: [
                        Text(e.county),
                        Text(e.time.toString()),
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
