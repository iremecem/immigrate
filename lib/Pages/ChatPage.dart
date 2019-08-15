import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Pages/ChatScreen.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirebaseController _controller = new FirebaseController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child(user.id)
            .child("rooms")
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            Map data = snapshot.data.snapshot.value;
            if (data != null) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: data[index]["profilePic"],
                    ),
                    onTap: () async {
                      String token = await _controller.retrieveChatToken(user1Uid: user.id, user2Uid: data[index]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            roomKey: token,
                            recieverId: data[index],
                            recieverName: data[index]["name"],
                            recieverProfilePic: data[index]["profilePic"],
                          ),
                        ),
                      );
                    },
                    title: Text(
                        "${data[index]["name1"] == user.name ? data[index]["name2"] : data[index]["name1"]}"),
                  );
                },
              );
            } else {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    "Look for countrymans nearby in discover to start a chat section...",
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
