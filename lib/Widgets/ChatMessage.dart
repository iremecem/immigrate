import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  final FirebaseController _controller = new FirebaseController();
  final DataSnapshot messageSnapshot;
  final Animation animation;
  final String messageKey;
  final String roomKey;
  ChatMessage({
    this.messageSnapshot,
    this.messageKey,
    this.animation,
    this.roomKey,
  });

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(top: 2.0),
              child: messageSnapshot.value['photoUrl'] != null
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            spreadRadius: 3.0,
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(
                            messageSnapshot.value["photoUrl"],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 200,
                      width: 200,
                    )
                  : Container(),
            ),
            Container(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: new Text(
                messageSnapshot.value['message'],
                style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              height: 5,
            ),
            Container(
              child: new Text(
                DateFormat("HH : mm").format(
                  DateTime.parse(
                    messageSnapshot.value['date'],
                  ),
                ),
                style: new TextStyle(
                  fontSize: 9,
                  color: Colors.black,
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 5),
            ),
          ],
        ),
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: new CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              backgroundColor: Colors.teal.shade300,
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: new CircleAvatar(
              child: Text(
                messageSnapshot.value["sender"][0],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.teal.shade300,
            ),
          ),
        ],
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(top: 2.0),
              child: messageSnapshot.value['photoUrl'] != null
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            spreadRadius: 3.0,
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(
                            messageSnapshot.value["photoUrl"],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 200,
                      width: 200,
                    )
                  : Container(),
            ),
            Container(
              height: 15,
            ),
            Container(
              //margin: EdgeInsets.symmetric(horizontal: 5),
              child: new Text(
                messageSnapshot.value['message'],
                style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              height: 5,
            ),
            Container(
              child: new Text(
                DateFormat("HH : mm").format(
                  DateTime.parse(
                    messageSnapshot.value['date'],
                  ),
                ),
                style: new TextStyle(
                  fontSize: 9,
                  color: Colors.black,
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 5),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: new SizeTransition(
        sizeFactor:
            new CurvedAnimation(parent: animation, curve: Curves.decelerate),
        child: new Container(
          child: new Row(
            children: user.id == messageSnapshot.value['sender']
                ? getSentMessageLayout()
                : getReceivedMessageLayout(),
          ),
        ),
      ),
      onLongPress: () async {
        if (Platform.isAndroid) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
              actions: <Widget>[
                FlatButton(
                    child: Text("Delete"),
                    onPressed: () async {
                      await _controller.deleteMessage(
                        messageKey: messageKey,
                        token: roomKey,
                      );
                    }),
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              content: Text("The message will be deleted..."),
              title: Text("Delete Message"),
            ),
          );
        } else if (Platform.isIOS) {
          showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              actions: <Widget>[
                CupertinoDialogAction(
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      await _controller.deleteMessage(
                        messageKey: messageKey,
                        token: roomKey,
                      );
                    }),
                CupertinoDialogAction(
                  child: Text("Cancel"),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, "Cancel");
                  },
                ),
              ],
              title: Text("Delete Message"),
              content: Text("This message will be deleted!"),
            ),
          );
        }
      },
    );
  }
}
