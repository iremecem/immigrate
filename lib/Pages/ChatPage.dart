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
            .child("users")
            .child(user.id)
            .child("rooms")
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            Map data = snapshot.data.snapshot.value;
            if (data != null) {
              print(data);
              print(data.keys.toList()[0]);
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.id == data[data.keys.toList()[index]]["user1"]
                          ? NetworkImage(
                              _controller.getUserPic(data[data.keys.toList()[index]]["user2"]))
                          : NetworkImage(
                              _controller.getUserPic(data[data.keys.toList()[index]]["user1"])),
                    ),
                    onTap: () async {
                      String token = await _controller.retrieveChatToken(
                          user1Uid: user.id, user2Uid: data[index]);
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
                        "${data[data.keys.toList()[index]]["name1"] == user.name ? data[data.keys.toList()[index]]["name2"] : data[data.keys.toList()[index]]["name1"]}"),
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
