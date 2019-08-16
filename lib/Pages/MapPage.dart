import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Pages/ChatScreen.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  FirebaseController _controller = new FirebaseController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user.lat == null
          ? Center(
              child: FlatButton(
                child: Text(
                  "Location permissions needed, press here",
                  style: TextStyle(
                    color: Colors.lightGreen,
                  ),
                ),
                onPressed: () async {
                  var loc = Location();
                  var acxcxepted = await loc.requestPermission();
                  if (acxcxepted == true) {
                    var locData = await loc.getLocation();
                    _controller.setUserLocation(
                      lat: user.lat,
                      long: user.lon,
                      userId: user.id,
                    );
                    setState(() {
                      user.lat = locData.latitude;
                      user.lon = locData.longitude;
                    });
                  }
                },
              ),
            )
          : StreamBuilder(
              stream:
                  FirebaseDatabase.instance.reference().child("users").onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  Map data = snapshot.data.snapshot.value;
                  List<Marker> markers = [];
                  if (data != null) {
                    data.forEach((k, v) {
                      if (k != user.id &&
                          v["lat"] != null &&
                          v["lon"] != null &&
                          (v["lat"] - user.lat < 5 ||
                              v["lat"] - user.lat > 5) &&
                          (v["lon"] - user.lon < 5 ||
                              v["lon"] - user.lon > 5) &&
                          user.from == v["from"] &&
                          user.to == v["to"]) {
                        markers.add(
                          new Marker(
                            builder: (_) => InkWell(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(v["profilePic"]),
                              ),
                              onTap: () async {
                                bool hasConnection = await _controller
                                    .checkUserHasConnectionWith(
                                  userUid: user.id,
                                  otherUid: k,
                                );
                                if (hasConnection == true) {
                                  await _controller
                                      .retrieveChatToken(
                                    user1Uid: user.id,
                                    user2Uid: k,
                                  )
                                      .then((onValue) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChatScreen(
                                          roomKey: onValue,
                                          recieverId: k,
                                          recieverName: v["name"],
                                          recieverProfilePic: v["profilePic"],
                                        ),
                                      ),
                                    );
                                  });
                                } else {
                                  await _controller
                                      .createToken()
                                      .then((onValue) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChatScreen(
                                          roomKey: onValue,
                                          recieverId: k,
                                          recieverName: v["name"],
                                          recieverProfilePic: v["profilePic"],
                                        ),
                                      ),
                                    );
                                  });
                                }
                              },
                            ),
                            height: 50,
                            width: 50,
                            point: LatLng(
                              v["lat"],
                              v["lon"],
                            ),
                          ),
                        );
                      }
                    });
                  }
                  if (snapshot.hasData && !snapshot.hasError) {
                    return FlutterMap(
                      options: MapOptions(
                        center: LatLng(user.lat, user.lon),
                        zoom: 12,
                        //interactive: false,
                        minZoom: 12,
                        maxZoom: 15,
                      ),
                      layers: [
                        TileLayerOptions(
                          urlTemplate: "https://api.tiles.mapbox.com/v4/"
                              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                          additionalOptions: {
                            "accessToken":
                                "pk.eyJ1IjoiYXBwbGljYXRpb24tY291bnRyeW1hbiIsImEiOiJjanpjamgwMnYwNjgyM21wN3BhbG5kdG16In0.Cht2ln2Zj_EWlX8hyPY0Zg",
                            "id": "mapbox.streets-basic",
                          },
                        ),
                        MarkerLayerOptions(markers: markers),
                      ],
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
    );
  }
}
