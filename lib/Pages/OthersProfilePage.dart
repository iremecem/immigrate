import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immigrate/Pages/OthersProfileInfo.dart';
import 'package:immigrate/Pages/ProfilePage.dart';
import 'package:simple_design/simple_design.dart';

class OthersProfilePage extends StatefulWidget {
  final String id;
  OthersProfilePage({Key key, @required this.id}) : super(key: key);

  _OthersProfilePageState createState() => _OthersProfilePageState();
}

class _OthersProfilePageState extends State<OthersProfilePage> {
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
                    "Info",
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
            ProfilePage(id: widget.id,),
            OthersProfileInfoPage(id: widget.id),
          ],
        ),
      ),
    );
  }
}