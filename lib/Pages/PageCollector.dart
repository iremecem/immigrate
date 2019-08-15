import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immigrate/Pages/ChatPage.dart';
import 'package:immigrate/Pages/MapPage.dart';
import 'package:immigrate/Pages/WallPage.dart';
import 'package:simple_design/simple_design.dart';

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
          child: SDAppBar(
            title: Text(
              "Countryman",
              style: TextStyle(
                color: Colors.lightGreen,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.user,
                  color: Colors.lightGreen,
                ),
                onPressed: () {},
              )
            ],
            bottom: TabBar(
              isScrollable: false,
              indicatorColor: Colors.lightGreen,
              indicatorWeight: 3,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    "Wall",
                    style: TextStyle(
                      color: Colors.lightGreen,
                    ),
                  ),
                  icon: Icon(
                    FontAwesomeIcons.globeAmericas,
                    color: Colors.lightGreen,
                  ),
                ),
                Tab(
                  child: Text(
                    "Discover",
                    style: TextStyle(
                      color: Colors.lightGreen,
                    ),
                  ),
                  icon: Icon(
                    FontAwesomeIcons.map,
                    color: Colors.lightGreen,
                  ),
                ),
                Tab(
                  child: Text(
                    "Chat",
                    style: TextStyle(
                      color: Colors.lightGreen,
                    ),
                  ),
                  icon: Icon(
                    FontAwesomeIcons.comment,
                    color: Colors.lightGreen,
                  ),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(130),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
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
