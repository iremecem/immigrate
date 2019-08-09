import 'package:flutter/material.dart';
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
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.lightGreen,
            title: Text("Immgirate"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.user),
                onPressed: () {},
              )
            ],
            bottom: TabBar(
              indicatorColor: Colors.black,
              indicatorWeight: 3,
              tabs: <Widget>[
                Tab(
                  child: Text("Wall"),
                  icon: Icon(FontAwesomeIcons.globeAmericas),
                ),
                Tab(
                  child: Text("Discover"),
                  icon: Icon(FontAwesomeIcons.map),
                ),
                Tab(
                  child: Text("Chat"),
                  icon: Icon(FontAwesomeIcons.comment),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(130),
        ),
        body: TabBarView(
          children: <Widget>[
            WallPage(),
            MapPage(),
            ChatPage(),
          ],
        ),
      ),
    );
  }
}
