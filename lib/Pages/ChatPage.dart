import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  DatabaseReference _chatDb = FirebaseDatabase.instance.reference().child("messages");
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}