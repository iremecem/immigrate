import 'package:firebase_database/firebase_database.dart';
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
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("posts")
            .child(user.to)
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            Map data = snapshot.data.snapshot.value;
            print(data);
            if (data != null) {
              List<Widget> posts = [];
              posts.add(
                Container(
                  height: 30,
                ),
              );
              data.forEach((k, v) {
                posts.add(new PostCard(
                  animation: null,
                  post: Post(
                    date: v["date"],
                    description: v["content"],
                    from: v["from"],
                    name: v["senderName"],
                    senderId: v["senderId"],
                    to: v["to"],
                    postId: k,
                    photoURL: v["imageUrl"],
                    profilePicUrl: v["profilePicUrl"],
                  ),
                  postKey: k,
                ));
              });
              return SingleChildScrollView(
                child: Column(
                  children: posts,
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          } else {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(64),
                child:
                    Text("No posts have been posted so far, be the first one!"),
              ),
            );
          }
        },
      ),
    );
  }
}
