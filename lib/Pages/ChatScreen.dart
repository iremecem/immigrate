import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Pages/MailWritingScreen.dart';
import 'package:immigrate/Pages/OthersProfilePage.dart';
import 'package:immigrate/Widgets/ChatMessage.dart';
import 'package:simple_design/simple_design.dart';

class ChatScreen extends StatefulWidget {
  final String recieverName;
  final String recieverId;
  final String recieverProfilePic;
  final String roomKey;
  ChatScreen(
      {Key key,
      this.recieverName,
      this.recieverId,
      this.recieverProfilePic,
      @required this.roomKey})
      : super(key: key);
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatController = new TextEditingController();
  final FirebaseController _controller = new FirebaseController();
  File imageToSend;
  bool isSending = false;
  Future getImageCamera() async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        imageToSend = image;
      }
    });
  }

  Future getImageGallery() async {
    Navigator.pop(context);
    var image = await FilePicker.getFilePath(type: FileType.IMAGE);
    setState(() {
      if (image != null) {
        imageToSend = File(image);
      }
    });
  }

  Future<void> _handleSubmit({String text, File image}) async {
    bool hasConnection = await _controller.checkUserHasConnectionWith(
        userUid: user.id, otherUid: widget.recieverId);
    print(hasConnection);
    if (hasConnection == false) {
      await _controller.createChatSpace(
        recieverName: widget.recieverName,
        recieverUid: widget.recieverId,
        roomToken: widget.roomKey,
        senderName: user.name,
        senderUid: user.id,
        user1ProfPic: user.profilePic,
        user2ProfPic: widget.recieverProfilePic,
      );
      _chatController.clear();
    }
    String check = text.trim();
    if (check.length != 0 || imageToSend != null) {
      if (imageToSend == null) {
        await _controller.sendMessage(
          text: text,
          sender: user.id,
          token: widget.roomKey,
        );
      } else if (check.length == 0 && imageToSend != null) {
        await _controller.sendMessage(
          text: "",
          sender: user.id,
          token: widget.roomKey,
          image: image,
        );
      }
    }
    _chatController.clear();
    imageToSend = null;
  }

  Widget _chatEnvironment() {
    return Column(
      children: <Widget>[
        imageToSend != null
            ? InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(imageToSend),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.lightGreen,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        spreadRadius: 3.0,
                      )
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  height: 100,
                  width: 100,
                ),
                onLongPress: () {
                  setState(() {
                    imageToSend = null;
                  });
                },
              )
            : Container(),
        IconTheme(
          data: new IconThemeData(
            color: Colors.lightGreen,
          ),
          child: new Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: Container(
                    child: new TextField(
                      decoration: new InputDecoration.collapsed(
                        hintText: "Write here...",
                      ),
                      controller: _chatController,
                      maxLines: null,
                    ),
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ),
                  child: new IconButton(
                    icon: new Icon(
                      Icons.camera,
                      color: Colors.lightGreen,
                    ),
                    onPressed: () {
                      if (Platform.isAndroid) {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Pick an Image"),
                                content: Text(
                                    "You can either select an image from camera or gallery"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      "Camera",
                                      style: TextStyle(
                                        color: Colors.lightGreen,
                                      ),
                                    ),
                                    onPressed: getImageCamera,
                                  ),
                                  FlatButton(
                                    child: Text(
                                      "Gallery",
                                      style: TextStyle(
                                        color: Colors.lightGreen,
                                      ),
                                    ),
                                    onPressed: getImageGallery,
                                  ),
                                ],
                              );
                            });
                      } else if (Platform.isIOS) {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            title: Text("Pick an image"),
                            message: Text(
                                "You can either select an image from camera or gallery"),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                child: Text("Camera"),
                                onPressed: getImageCamera,
                              ),
                              CupertinoActionSheetAction(
                                child: Text("Gallery"),
                                onPressed: getImageGallery,
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text("Cancel"),
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context, "Cancel");
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ),
                  child: new IconButton(
                      icon: new Icon(
                        Icons.send,
                        color: Colors.lightGreen,
                      ),
                      onPressed: isSending == true
                          ? null
                          : () async {
                              setState(() {
                                isSending = true;
                              });
                              await _handleSubmit(
                                text: _chatController.text.trim(),
                                image: imageToSend,
                              );
                              if (imageToSend != null) {
                                Flushbar(
                                  animationDuration:
                                      Duration(milliseconds: 400),
                                  backgroundColor: Colors.green,
                                  flushbarStyle: FlushbarStyle.FLOATING,
                                  flushbarPosition: FlushbarPosition.BOTTOM,
                                  message: "Sending media, please wait...",
                                  isDismissible: true,
                                  duration: Duration(seconds: 5),
                                )..show(context);
                                await _handleSubmit(
                                  text: _chatController.text.trim(),
                                  image: imageToSend,
                                );
                              } else {
                                await _handleSubmit(
                                  text: _chatController.text.trim(),
                                  image: imageToSend,
                                );
                              }
                              setState(() {
                                isSending = false;
                              });
                            }),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const List<Choice> choices = const <Choice>[
      // const Choice(title: 'Block', icon: Icons.block),
      const Choice(title: 'Report', icon: Icons.report),
    ];
    return Scaffold(
      appBar: SDAppBar(
        actions: <Widget>[
          PopupMenuButton<Choice>(
            itemBuilder: (_) {
              return choices.map((f) {
                return PopupMenuItem<Choice>(
                  value: f,
                  child: Text(f.title),
                );
              }).toList();
            },
            onSelected: (coice) async {
              if (coice.title == "Report") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MailWritingScreen(),
                  ),
                );
              } else {
                await _controller.blockUser(
                  otherUserID: widget.recieverId,
                  userID: user.id,
                  roomID: widget.roomKey,
                );
                Navigator.pop(context);
              }
            },
          ),
        ],
        title: SizedBox(
          width: double.infinity,
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                left: 0,
                top: 13,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.recieverProfilePic),
                  radius: 15,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            OthersProfilePage(id: widget.recieverId),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 50,
                top: 20,
                child: Text(
                  "${widget.recieverName}",
                  style: TextStyle(
                    fontSize: 17.5,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Flexible(
              child: new FirebaseAnimatedList(
                defaultChild: Center(
                  child: Text(
                    "No messages found, be the first and send a message...",
                  ),
                ),
                query: FirebaseDatabase.instance
                    .reference()
                    .child("chatRooms")
                    .child(widget.roomKey)
                    .child("messages"),
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                sort: (a, b) => b.value["date"].compareTo(a.value["date"]),
                itemBuilder: (_, DataSnapshot messageSnapshot,
                    Animation<double> animation, index) {
                  return new ChatMessage(
                    messageSnapshot: messageSnapshot,
                    messageKey: messageSnapshot.value["messageKey"],
                    animation: animation,
                    roomKey: widget.roomKey,
                  );
                },
              ),
            ),
            Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _chatEnvironment(),
            )
          ],
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
