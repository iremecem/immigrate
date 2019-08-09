import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Models/User.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _completer = Completer();
  FirebaseController _controller = new FirebaseController();
  List<User> userLocations = [];
  Set<Marker> markers = {};

  Future getUserLocations() async {
    userLocations = await _controller.getNearUsersLocation();
  }

  @override
  void initState() {
    Future.wait([getUserLocations()]).then((onValue) {
      userLocations.forEach((User user) {
        markers.add(Marker(
          markerId: MarkerId(user.id),
          onTap: (){
            //TODO: SENDS CHAT SCREEN
          },
          draggable: false,
          position: LatLng(user.lat, user.lon),
          visible: true,
        ));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GoogleMap(
          onMapCreated: (controller) {
            _completer.complete(controller);
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(
              user.lat,
              user.lon,
            ),
            zoom: 11.5,
          ),
          compassEnabled: true,
          mapToolbarEnabled: true,
          indoorViewEnabled: true,
          myLocationEnabled: true,
          markers: markers,
          rotateGesturesEnabled: false,
          scrollGesturesEnabled: false,
          tiltGesturesEnabled: false,
          zoomGesturesEnabled: false,
        ),
      ),
    );
  }
}
