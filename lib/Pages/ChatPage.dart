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
              return StreamBuilder(
                stream: FirebaseDatabase.instance.reference().child("chatRooms").onValue,
                
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
