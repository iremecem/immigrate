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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AboutDialog(
                    applicationName: "Immigrate",
                    applicationVersion: "v 0.1",
                    children: <Widget>[
                      Center(
                        child: Text(
                            "Developed by Etam Software Ltd. in Turkey/Ankara"),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
        title: Text("Immigrate"),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WallPage(),
                  ),
                ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.map,
                    size: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.all(4),
                  ),
                  Text("Discover"),
                  Padding(
                    padding: EdgeInsets.all(4),
                  )
                ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.message,
                    size: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.all(4),
                  ),
                  Text("Chat"),
                  Padding(
                    padding: EdgeInsets.all(4),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MapPage(),
                  ),
                ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.globeEurope,
                    size: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.all(4),
                  ),
                  Text("Map"),
                  Padding(
                    padding: EdgeInsets.all(4),
                  )
                ],
              ),
            ),
          ),
        ],
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        padding: EdgeInsets.all(4),
      ),
    );
  }
}
