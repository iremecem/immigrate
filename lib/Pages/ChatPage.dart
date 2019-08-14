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
      body: FirebaseAnimatedList(
        defaultChild: Center(
          child: Padding(
            padding: EdgeInsets.all(50),
            child: Text(
                "Look to the map for people nearby to start messaging...."),
          ),
        ),
        itemBuilder: (context, snapshot, anim, index) {
          if (snapshot.value != null) {
            Map keys = snapshot.value;
            keys.forEach((k, v) {
              return ListTile(
                contentPadding: EdgeInsets.all(8),
                enabled: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        recieverId: v["recieverId"],
                        recieverName: v["recieverName"],
                      ),
                    ),
                  );
                },
                title: v["reciever"],
                subtitle: Text("Tap to coonnect to the private chat..."),
              );
            });
          }
          return Container();
        },
        query: FirebaseDatabase.instance
            .reference()
            .child("users")
            .child(user.id)
            .child("messageKeys"),
      ),
    );
  }
}
