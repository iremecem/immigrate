import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Pages/ImageShowroomScreen.dart';

class PostEditorButtons extends StatefulWidget {
  final TextEditingController controller;
  final BuildContext context;
  PostEditorButtons({@required this.controller, @required this.context});
  @override
  _PostEditorButtonsState createState() => _PostEditorButtonsState();
}

class _PostEditorButtonsState extends State<PostEditorButtons> {
  final FirebaseController _controller = new FirebaseController();

  File imageToSend;
  DateTime date = DateTime.now();

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              imageToSend == null
                  ? Container()
                  : InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(imageToSend),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.red.shade100,
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
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImageShowroomScreen(
                            image: imageToSend,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 15,
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.image,
                      color: Colors.red.shade300,
                      size: 30,
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
                                      style:
                                          TextStyle(color: Colors.red.shade200),
                                    ),
                                    onPressed: getImageCamera,
                                  ),
                                  FlatButton(
                                    child: Text("Gallery",
                                        style: TextStyle(
                                            color: Colors.red.shade200)),
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
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () async {
                      if (widget.controller.text.trim().length != 0 ||
                          imageToSend != null) {
                        await _controller.sendPost(
                          content: widget.controller.text.trim(),
                          from: user.from,
                          to: user.to,
                          image: imageToSend,
                          senderId: user.id,
                          senderName: user.name,
                        );
                        Navigator.pop(context);
                        Flushbar(
                          animationDuration: Duration(milliseconds: 400),
                          backgroundColor: Colors.green,
                          flushbarStyle: FlushbarStyle.FLOATING,
                          flushbarPosition: FlushbarPosition.BOTTOM,
                          message: "Post has successfully uploaded...",
                          isDismissible: true,
                          duration: Duration(seconds: 5),
                        )..show(widget.context);
                      } else {
                        Flushbar(
                          animationDuration: Duration(milliseconds: 400),
                          backgroundColor: Colors.red,
                          flushbarStyle: FlushbarStyle.FLOATING,
                          flushbarPosition: FlushbarPosition.BOTTOM,
                          message: "Description or image can not be empty!",
                          isDismissible: true,
                          duration: Duration(seconds: 5),
                        )..show(context);
                      }
                    },
                    icon: Icon(
                      FontAwesomeIcons.paperPlane,
                      color: Colors.red.shade300,
                      size: 25,
                    ),
                  ),
                  Container(
                    width: 15,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
