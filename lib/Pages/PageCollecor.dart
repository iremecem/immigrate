import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immigrate/Pages/ChatPage.dart';
import 'package:immigrate/Pages/MapPage.dart';
import 'package:immigrate/Pages/WallPage.dart';

class PageCollector extends StatefulWidget {
  @override
  _PageCollectorState createState() => _PageCollectorState();
}

class _PageCollectorState extends State<PageCollector> {
  Key k = new Key("DrawerKey");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => AboutDialog(
                  applicationName: "Immigrate",
                  applicationVersion: "v 0.1",
                  children: <Widget>[
                    Center(
                      child: Text(
                          "Developed by Etam Software Ltd. in Turkey/Ankara"),
                    ),
                  ],
                ),
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MapPage(),
                  ),
                ),
            child: Container(
              child: Icon(
                Icons.map,
                size: 50,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatPage(),
                  ),
                ),
            child: Container(
              child: Icon(
                Icons.message,
                size: 50,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WallPage(),
                  ),
                ),
            child: Container(
              child: Icon(
                FontAwesomeIcons.globeEurope,
                size: 50,
              ),
            ),
          ),
        ],
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        padding: EdgeInsets.all(4),
      ),
      drawer: Drawer(
        key: k,
      ),
    );
  }
}
