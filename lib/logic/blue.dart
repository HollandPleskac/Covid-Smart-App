import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'fire.dart';

final _flutterBlue = FlutterBlue.instance;
final _fire = Fire();

class Blue {
  void scan(String email, String tripId) {
    List deviceids = [];

    // Start scanning
    _flutterBlue.startScan(
        timeout: Duration(days: 1000000000000000), allowDuplicates: false);

    // Listen to scan results
    _flutterBlue.scanResults.listen((results) async {
      Location location = new Location();

      // do something with scan results
      for (ScanResult r in results) {
        if (deviceids.contains('${r.device.id}')) {
          print("encounter already logged");
        } else {
          LocationData _locationData = await location.getLocation();
          if (r.rssi > -70) {
            HapticFeedback.vibrate();
            deviceids.add('${r.device.id}');
            // log
            _fire.logEncounter(
              county: 'San Joaquin County',
              email: email,
              time: DateTime.now(),
              lat: _locationData.latitude,
              lng: _locationData.longitude,
              tripId: tripId,
            );

            print('${r.device.id} found! rssi: ${r.rssi}');
          } else {
            print("Ingore");
          }
        }
      }
    });
  }


   Future<String> getStreet() async {
    Position position = await Geolocator.getCurrentPosition();

    print('location: ${position.latitude}, ${position.longitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
   var first = addresses.first;
   
    print("${first.featureName} : ${first.addressLine}");

    print("City : ${first.locality}");

   

    var location = first.addressLine;

    var street = location.substring(0, location.indexOf(','));

    return street;
 
  }
}
