import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:immigrate/Controllers/Globals.dart' as prefix0;

class ChatScreen extends StatefulWidget {
  final String recieverName;
  final String recieverId;
  ChatScreen({Key key, this.recieverName, this.recieverId}) : super(key: key);
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("$widget.recieverName"),
        backgroundColor: Colors.lightGreen,
        elevation: 1,
      ),
      body: DashChat(
        user: ChatUser(
          avatar: prefix0.user.profilePic,
          color: Colors.lightGreen,
          name: prefix0.user.name,
          containerColor: Colors.lightGreen,
          uid: prefix0.user.id,
        ),
        messages: [ChatMessage(text: "lele", user: ChatUser()),ChatMessage(text: "lele", user: ChatUser()),ChatMessage(text: "lele", user: ChatUser())],
        onSend: (message){},
      ),
    );
  }
}