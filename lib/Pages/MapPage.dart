import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user.lat == null
          ? Center(
              child: FlatButton(
                child: Padding(
                  child: Text(
                      "To see people around you, press here and enable location services"),
                  padding: EdgeInsets.all(40),
                ),
                onPressed: () async {
                  try {
                    var location = new Location();
                    var currentLocation = await location.getLocation();
                    user.lat = currentLocation.latitude;
                    user.lon = currentLocation.longitude;
                    await _controller.setUserLocation(
                      userId: user.id,
                      long: user.lon,
                      lat: user.lat,
                    );
                  } on PlatformException catch (e) {
                    if (e.code == 'PERMISSION_DENIED') {
                      print('Permission denied');
                    }
                  }
                  setState(() {});
                },
              ),
            )
          : Center(
              child: StreamBuilder(
                builder: (context, snapshot) {
                  List<User> userList = [];
                  Set<Marker> markerSet = {};
                  Map users = snapshot.data.snapshot.value;
                  if (users != null) {
                    users.forEach((k, v) {
                      userList.add(
                        User(
                          lat: v["lat"],
                          lon: v["lon"],
                          name: v["name"],
                          profilePic: v["profilePic"],
                          from: v["from"],
                        ),
                      );
                    });
                  }
                  if(userList != null){
                    userList.forEach((user){
                      print(user.name);
                      markerSet.add(Marker(
                        markerId: MarkerId(user.name),
                        onTap: (){
                          //TODO: IMPLEMENT CHAT MESSAGE
                        },
                        position: LatLng(user.lat, user.lon),
                        visible: true,
                        draggable: false,
                      ));
                    });
                  }
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(user.lat, user.lon),
                      zoom: 11.5
                    ),
                    compassEnabled: true,
                    mapToolbarEnabled: false,
                    indoorViewEnabled: true,
                    myLocationEnabled: true,
                    markers: markerSet,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                  );
                },
                stream: FirebaseDatabase.instance
                    .reference()
                    .child("users")
                    .onValue,
              ),
            ),
    );
  }
}
