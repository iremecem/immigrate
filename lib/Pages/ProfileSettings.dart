import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("users").onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data.snapshot.value[roomData.creator];
            return StreamBuilder(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child("rooms")
                  .child(roomData.token)
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map room = snapshot.data.snapshot.value;
                  return SingleChildScrollView(
                    child: FormBuilder(
                      key: _fbKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 30,
                          ),
                          Center(
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () async {
                                if (Platform.isAndroid) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (_) => AlertDialog(
                                      title: Text("Pick an Image"),
                                      content: Text(
                                          "You can either select an image from camera or gallery"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            "Camera",
                                            style: TextStyle(
                                                color: Colors.cyan.shade200),
                                          ),
                                          onPressed: getImageCamera,
                                        ),
                                        FlatButton(
                                          child: Text(
                                            "Gallery",
                                            style: TextStyle(
                                                color: Colors.cyan.shade200),
                                          ),
                                          onPressed: getImageGallery,
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (Platform.isIOS) {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => CupertinoActionSheet(
                                      title: Text("Add an image"),
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
                              child: CircleAvatar(
                                radius: 125,
                                backgroundColor: Colors.cyan.shade200,
                                backgroundImage: room["profilePic"] == null
                                    ? AssetImage("assets/images/sample.jpg")
                                    : NetworkImage(room["profilePic"]),
                              ),
                            ),
                          ),
                          Container(
                            height: 30,
                          ),
                          Divider(
                            endIndent: 15,
                            indent: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              "   Relationship Info",
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              border: Border.all(color: Colors.cyan.shade200),
                            ),
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Room Token",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("${roomData.token}    "),
                                    Icon(
                                      AntDesign.getIconData("key"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (_) {
                                  print(data["relationshipDate"]);
                                  return new SetRelationshipDateScreen(
                                    value: room["relationshipDate"] == null
                                        ? DateTime.now()
                                        : DateTime.parse(
                                            room["relationshipDate"]),
                                  );
                                },
                              ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                border: Border.all(color: Colors.cyan.shade200),
                              ),
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Relationship Start Date:    ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                          "${room['relationshipDate'] == null ? 'Press to Specify' : rsd}    "),
                                      Icon(
                                        FontAwesomeIcons.chevronRight,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            endIndent: 15,
                            indent: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text("   User Info"),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (_) => SetNameScreen(
                                    value: data["name"],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                border: Border.all(color: Colors.cyan.shade200),
                              ),
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Name:    ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("${data["name"]}    "),
                                      Icon(
                                        Ionicons.getIconData(
                                            "ios-arrow-forward"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SetEmailScreen(
                                    value: data["mail"],
                                    context: context,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                border: Border.all(color: Colors.cyan.shade200),
                              ),
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Email:    ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("${data["mail"]}    "),
                                      Icon(
                                        FontAwesomeIcons.chevronRight,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangePasswordScreen(
                                    value: data["password"],
                                    context: context,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                border: Border.all(color: Colors.cyan.shade200),
                              ),
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Change Password",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.chevronRight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            endIndent: 15,
                            indent: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text("   Options"),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) => AlertDialog(
                                  title: Text("Sign Out"),
                                  content: Text(
                                      "Are you sure you want to sign out ?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    FlatButton(
                                      child: Text("Sign Out"),
                                      onPressed: () async {
                                        await _controller
                                            .signOut()
                                            .then((onValue) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    RegisterScreen(),
                                              ),
                                              (route) => false);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                border: Border.all(color: Colors.cyan.shade200),
                              ),
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Sign Out",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.chevronRight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) => AlertDialog(
                                  title: Text(":("),
                                  content: Text(
                                      "We are sorry to hear that, but you need to know that we will delete your token from server and you will no longer access the data. Are you sure you want to continue ?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    FlatButton(
                                      child: Text("I'm sure..."),
                                      onPressed: () async {
                                        SharedPreferences _prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        await _controller.removeFromRoom(
                                            token: roomData.token);
                                        await _prefs
                                            .remove("roomToken")
                                            .then((onValue) {
                                          roomData.token = null;
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    RoomCreatorPage(),
                                              ),
                                              (route) => false);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                border: Border.all(color: Colors.cyan.shade200),
                              ),
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "We broke up...",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade300,
                                    ),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.chevronRight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            endIndent: 15,
                            indent: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text("   About"),
                          ),
                          InkWell(
                            onTap: () {
                              if (Platform.isAndroid) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AboutDialog(
                                    applicationName: "Valentines App",
                                    applicationVersion: "v0.1 Beta",
                                    children: <Widget>[
                                      Text(
                                          "Thank you for using our application, we wish you have a happy togetherness..."),
                                      Text(
                                          "\nDeveloped in Connected2Me studios at Ankara/Bilkent, Turkey by İrem Ecem Yelkanat and Ali Taha Dinçer.")
                                    ],
                                  ),
                                );
                              } else if (Platform.isIOS) {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: Text("View Licenses"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          showLicensePage(
                                            context: context,
                                            applicationName: "Valentines App",
                                            applicationVersion: "v0.1 Beta",
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
                                    title: Text("Valentines App"),
                                    content: Text(
                                        "\nThank you for using our application, we wish you have a happy togetherness..." +
                                            "\n\nDeveloped in Connected2Me studios at Ankara/Bilkent, Turkey by İrem Ecem Yelkanat and Ali Taha Dinçer."),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                border: Border.all(color: Colors.cyan.shade200),
                              ),
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "About Us",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.chevronRight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MailWritingScreen(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                border: Border.all(color: Colors.cyan.shade200),
                              ),
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Contact Us",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.chevronRight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //TODO: ADD CHANGER
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                border: Border.all(color: Colors.cyan.shade200),
                              ),
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Terms Of Use",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.chevronRight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
