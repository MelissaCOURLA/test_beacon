import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<RangingResult> _streamRanging;
  final _beacons = <Beacon>[];
  
  @override
  void initState() {
    super.initState();

    initBeacon();
  }

  initBeacon() async {
    try {
      await flutterBeacon.initializeScanning;
      print('Beacon scanner initialized');
    } on PlatformException catch (e) {
      print(e);
    }

    final regions = <Region>[];

    if (Platform.isIOS) {
      regions.add(
        Region(
            identifier: 'Cubeacon',
            proximityUUID: 'CB10023F-A318-3394-4199-A8730C7C1AEC'),
      );
      regions.add(Region(
          identifier: 'Apple Airlocate',
          proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));
    } else {
      regions.add(Region(identifier: 'com.beacon'));
    }


    _streamRanging = flutterBeacon.ranging(regions).listen((result) {
    result.beacons.forEach((b) {
    print(b.major);
    _beacons.sort(_compareParameters);
  });
});

  }

  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }


    return compare;
  }

  @override
  void dispose() {
    if (_streamRanging != null) {
      _streamRanging.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      home: Scaffold
      (
        appBar: AppBar
        (
          title: const Text('Test détection balises'),
        ),
        
      ),
    );
  }
}
