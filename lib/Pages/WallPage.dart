import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Models/Post.dart';
import 'package:immigrate/Pages/PostCreationScreen.dart';
import 'package:immigrate/Widgets/PostCard.dart';

class WallPage extends StatefulWidget {
  @override
  _WallPageState createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  @override
  Widget build(BuildContext context) {
    String filterQueue = user.to;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostCreationScreen(),
            ),
          );
        },
        child: Icon(FontAwesomeIcons.penFancy),
        isExtended: true,
      ),
      body: FirebaseAnimatedList(
        defaultChild: Center(
          child: Text("No posts found, be the first one"),
        ),
        padding: EdgeInsets.all(8),
        shrinkWrap: true,
        sort: (a, b) => b.value["date"].compareTo(a.value["date"]),
        query: FirebaseDatabase.instance
            .reference()
            .child("posts")
            .child(filterQueue)
            .limitToFirst(20),
        itemBuilder: (context, snapshot, anim, index) {
          if (snapshot.value != null) {
            Map data = snapshot.value;
            return PostCard(
              animation: anim,
              post: Post(
                date: data["date"],
                description: data["content"],
                from: data["from"],
                name: data["senderName"],
                photoURL: data["imageUrl"],
                profilePicUrl: data["profilePicUrl"],
                senderId: data["senderId"],
                to: data["to"],
                postId: data.keys.elementAt(index),
                absolutePAth: data["absolutePath"],
              ),
              postKey: data.keys.elementAt(index),
            );
          } else {
            return Center(
              child: Text("No posts found, be the first one"),
            );
          }
        },
      ),
    );
  }
}
