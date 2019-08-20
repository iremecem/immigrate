import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Models/Post.dart';
import 'package:immigrate/Widgets/PostCard.dart';

class ProfilePage extends StatefulWidget {
  final String id;
  ProfilePage({@required this.id});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirebaseAnimatedList(
        defaultChild: Center(
          child: Text("No posts found, be the first one"),
        ),
        padding: EdgeInsets.all(8),
        shrinkWrap: true,
        sort: (a, b) => b.value["date"].compareTo(a.value["date"]),
        query: FirebaseDatabase.instance
            .reference()
            .child("users")
            .child(widget.id)
            .child("posts"),
        itemBuilder: (context, snapshot, anim, index) {
          Map data = snapshot.value;
          if (data.length != 0) {
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
              child: Text(user.id == widget.id ? "No posts found, send a new post..." : "This user has not send any posts yet..."),
            );
          }
        },
      ),
    );
  }
}
