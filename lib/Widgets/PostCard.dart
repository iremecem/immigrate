import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Models/Post.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final Animation animation;
  final String postKey;

  PostCard(
      {@required this.post, @required this.animation, @required this.postKey});
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final FirebaseController _controller = new FirebaseController();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      margin: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: Colors.red.shade200,
                    backgroundImage: widget.post.profilePicUrl != null
                        ? NetworkImage(widget.post.profilePicUrl)
                        : AssetImage("assets/images/sample.jpg"),
                  ),
                  Container(
                    width: 10,
                  ),
                  RichText(
                      text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: (" ${widget.post.name} "),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: ("· from " + "${widget.post.from}"),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey.shade200,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              Row(
                children: <Widget>[
                  widget.post.senderId == user.id
                      ? IconButton(
                          icon: Icon(
                            FontAwesomeIcons.trashAlt,
                            color: Colors.red.shade300,
                            size: 18,
                          ),
                          onPressed: () async {
                            if (Platform.isIOS) {
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
                                        Navigator.pop(context);
                                        await _controller.deletePost(
                                          postId: widget.post.postId,
                                          to: user.to,
                                          absolutePath:
                                              widget.post.absolutePAth,
                                          userId: user.id,
                                        );
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text("Cancel"),
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context, "Cancel");
                                      },
                                    ),
                                  ],
                                  title: Text("Delete"),
                                  content: Text(
                                      "This post will be deleted permanently!"),
                                ),
                              );
                            } else if (Platform.isAndroid) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await _controller.deletePost(
                                          postId: widget.post.postId,
                                          to: user.to,
                                          absolutePath:
                                              widget.post.absolutePAth,
                                          userId: user.id,
                                        );
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context, "Cancel");
                                      },
                                    ),
                                  ],
                                  title: Text("Delete"),
                                  content: Text(
                                      "This post will be deleted permanently!"),
                                ),
                              );
                            }
                          },
                        )
                      : Container(),
                  Container(
                    width: 8,
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 8,
          ),
          widget.post.photoURL != null
              ? Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 10,
                      height: MediaQuery.of(context).size.width - 10,
                      alignment: Alignment(5, 5),
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: NetworkImage(widget.post.photoURL),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 13,
                    ),
                    widget.post.description != ""
                        ? Container(
                            width: MediaQuery.of(context).size.width - 35,
                            child: Text(
                              widget.post.description,
                              style: TextStyle(
                                color: Colors.blueGrey.shade900,
                                fontSize: 14.5,
                              ),
                            ),
                          )
                        : Container(),
                    widget.post.description != ""
                        ? Container(
                            height: 10,
                          )
                        : Container(),
                    Container(
                      width: MediaQuery.of(context).size.width - 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            DateFormat("HH : mm")
                                    .format(DateTime.parse(widget.post.date)) +
                                " · " +
                                DateFormat("dd / MMMM / yyyy")
                                    .format(DateTime.parse(widget.post.date)),
                            style: TextStyle(
                                color: Colors.blueGrey.shade500, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    Container(
                      height: 3,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 35,
                      child: Text(
                        widget.post.description,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Container(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            DateFormat("HH : mm")
                                    .format(DateTime.parse(widget.post.date)) +
                                " · " +
                                DateFormat("dd / MMMM / yyyy")
                                    .format(DateTime.parse(widget.post.date)),
                            style: TextStyle(
                                color: Colors.blueGrey.shade500, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
