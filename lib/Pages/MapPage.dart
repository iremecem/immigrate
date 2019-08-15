import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Pages/ChatScreen.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  FirebaseController _controller = new FirebaseController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("users").onValue,
        builder: (context, snapshot) {
          Map data = snapshot.data.snapshot.value;
          List<Marker> markers = [];
          if (data != null) {
            data.forEach((k, v) {
              if (k != user.id &&
                  (v["lat"] - user.lat < 3 || v["lat"] - user.lat > 3) &&
                  (v["lon"] - user.lon < 3 || v["lon"] - user.lon > 3) &&
                  user.from == v["from"] &&
                  user.to == v["to"]) {
                markers.add(
                  new Marker(
                    builder: (_) => InkWell(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(v["profilePic"]),
                      ),
                      onTap: () async {
                        await _controller
                            .createChatSpace(
                          senderName: user.name,
                          senderUid: user.id,
                          recieverName: v["name"],
                          recieverUid: k,
                        )
                            .then((onValue) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(),
                            ),
                          );
                        });
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
        },
      ),
    );
  }
}
