import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              List<ListTile> tiles = [];
              print(data);
              data.forEach((k, v) {
                tiles.add(new ListTile(
                  trailing: IconButton(
                    icon: Icon(FontAwesomeIcons.chevronRight),
                    onPressed: null,
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "${v["pic1"] == user.profilePic ? v["pic2"] : v["pic1"]}"),
                  ),
                  title: Text(
                      "${v["name1"] == user.name ? v["name2"] : v["name1"]}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          roomKey: k,
                          recieverId:
                              "${v["user1"] == user.id ? v["user2"] : v["user1"]}",
                          recieverName:
                              "${v["name1"] == user.name ? v["name2"] : v["name1"]}",
                          recieverProfilePic:
                              "${v["pic1"] == user.profilePic ? v["pic2"] : v["pic1"]}",
                        ),
                      ),
                    );
                  },
                ));

              });
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey,
                  endIndent: 10,
                  indent: 10,
                ),
                itemCount: tiles.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        tiles[index],
                      ],
                    ),
                  );
                },

                // children: tiles,
                // padding: EdgeInsets.all(8),
                // shrinkWrap: true,

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
