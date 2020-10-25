import 'dart:ui';

import 'package:covid_smart_app/screens/map.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Trip Encounters",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w400),),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapScreen()),
                            );
        },
        child: Icon(Icons.arrow_back_ios,color: Colors.white,),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: _fire.streamEncounters(widget.tripId),
        builder: (context, snapshot) {
          List<Encounter> encounters = snapshot.data;
          print('encounter dataa + '+encounters.toString());
          if (encounters == null || encounters.length == 0) {
            return Center(child: Text('no encounters'));
          }
          return Padding(
            padding: EdgeInsets.only(top:20,left: 20),
                      child: ListView(
              children: encounters
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.county,style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w400),),
                          SizedBox(height: 5,),
                          Text(e.time.toString(),style: TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w400)),
                        ],
                      ),
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
