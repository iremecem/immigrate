import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OthersProfileInfoPage extends StatefulWidget {
  final String id;
  OthersProfileInfoPage({Key key, @required this.id}) : super(key: key);

  _OthersProfileInfoPageState createState() => _OthersProfileInfoPageState();
}

class _OthersProfileInfoPageState extends State<OthersProfileInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseDatabase.instance
            .reference()
            .child("users")
            .child(widget.id)
            .onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              Map userData = snapshot.data.snapshot.value;
              String to = userData["to"];
              switch (to) {
                case "tr":
                  to = "Turkey";
                  break;
                case "gb":
                  to = "United Kingdom";
                  break;
                case "fr":
                  to = "France";
                  break;
                case "it":
                  to = "Italy";
                  break;
                case "de":
                  to = "Germany";
                  break;
                case "rs":
                  to = "Russia";
                  break;
                case "us":
                  to = "United States";
                  break;
                case "ae":
                  to = "Arab Emirates";
                  break;
              }
              return Column(
                children: <Widget>[
                  Container(
                    height: 30,
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 125,
                      backgroundColor: Colors.lightGreen.shade200,
                      backgroundImage: userData["profilePic"] == null
                          ? AssetImage("assets/images/sample.jpg")
                          : NetworkImage(userData["profilePic"]),
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
                    child: Text("   User Info"),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      border: Border.all(color: Colors.lightGreen.shade200),
                    ),
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Name:    ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "${userData["name"]}    ",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      border: Border.all(color: Colors.lightGreen.shade200),
                    ),
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Email:    ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "${userData["mail"]}    ",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      border: Border.all(color: Colors.lightGreen.shade200),
                    ),
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Living in:    ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "$to    ",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      border: Border.all(color: Colors.lightGreen.shade200),
                    ),
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Age:    ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "${userData["age"]}    ",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      border: Border.all(color: Colors.lightGreen.shade200),
                    ),
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Profession:    ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "${userData["profession"]}    ",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      border: Border.all(color: Colors.lightGreen.shade200),
                    ),
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Gender:    ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "${userData["gender"]}    ",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
