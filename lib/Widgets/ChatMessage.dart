import 'dart:io';

import 'package:bubble/bubble.dart';
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
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 5),
            //   child: new Text(
            //     messageSnapshot.value['message'],
            //     style: new TextStyle(
            //       fontSize: 14.0,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            Bubble(
              child: Text(
                messageSnapshot.value["message"],
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 13),
              ),
              nip: BubbleNip.rightTop,
              alignment: Alignment.topRight,
              color: Colors.lightGreen.shade100,
              radius: Radius.circular(10),
              margin: BubbleEdges.only(top: 5, left: 100),
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
                  fontSize: 8,
                  color: Colors.grey.shade500,
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 5),
            ),
          ],
        ),
      ),
      // new Column(
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   children: <Widget>[
      //     new Container(
      //       margin: const EdgeInsets.only(left: 8.0),
      //       child: new CircleAvatar(
      //         backgroundImage: NetworkImage(user.profilePic),
      //         backgroundColor: Colors.teal.shade300,
      //       ),
      //     ),
      //   ],
      // ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // new Container(
          //   margin: const EdgeInsets.only(right: 8.0),
          //   child: new CircleAvatar(
          //     child: Text(
          //       messageSnapshot.value["sender"][0],
          //       style: TextStyle(
          //         color: Colors.white,
          //       ),
          //     ),
          //     backgroundColor: Colors.teal.shade300,
          //   ),
          // ),
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
            // Container(
            //   height: 15,
            // ),
            // Container(
            //   //margin: EdgeInsets.symmetric(horizontal: 5),
            //   child: new Text(
            //     messageSnapshot.value['message'],
            //     style: new TextStyle(
            //       fontSize: 14.0,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            Bubble(
              child: Text(
                messageSnapshot.value["message"],
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 13),
              ),
              nip: BubbleNip.leftTop,
              alignment: Alignment.topLeft,
              color: Colors.brown.shade50,
              radius: Radius.circular(10),
              margin: BubbleEdges.only(top: 10, right: 100),
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
                  fontSize: 8,
                  color: Colors.grey.shade500,
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
    );
  }
}
