import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Pages/ProfilePage.dart';
import 'package:immigrate/Pages/ProfileSettings.dart';
import 'package:simple_design/simple_design.dart';

class ProfileCollector extends StatefulWidget {
  @override
  _ProfileCollectorState createState() => _ProfileCollectorState();
}

class _ProfileCollectorState extends State<ProfileCollector> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          child: SDAppBar(
            title: Text(
              "Profile",
              style: TextStyle(
                color: Colors.lightGreen,
              ),
            ),
            // actions: <Widget>[
            //   IconButton(
            //     icon: Icon(
            //       FontAwesomeIcons.user,
            //       color: Colors.lightGreen,
            //     ),
            //     onPressed: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProfilePage()));
            //     },
            //   )
            // ],
            bottom: TabBar(
              isScrollable: false,
              indicatorColor: Colors.lightGreen,
              indicatorWeight: 2,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    "Posts",
                    style: TextStyle(
                      color: Colors.lightGreen,
                    ),
                  ),
                  icon: Icon(
                    FontAwesomeIcons.hashtag,
                    color: Colors.lightGreen,
                  ),
                ),
                Tab(
                  child: Text(
                    "Info & Settings",
                    style: TextStyle(
                      color: Colors.lightGreen,
                    ),
                  ),
                  icon: Icon(
                    FontAwesomeIcons.edit,
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
            ProfilePage(id: user.id,),
            ProfileSettings(),
          ],
        ),
      ),
    );
  }
}