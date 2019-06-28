import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:immigrate/Models/User.dart';

class SignPage extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  TextEditingController _mailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.reference().child("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: TextField(
              controller: _mailController,
              decoration: InputDecoration(
                hintText: "Enter your e-mail here...",
              ),
            ),
          ),
          Container(
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "Enter your password here...",
              ),
              obscureText: true,
            ),
          ),
          FlatButton.icon(
            icon: Icon(Icons.done),
            label: Text("Log Me In"),
            onPressed: () {
              if (_auth.currentUser() == null) {
                if (_mailController.text.trim().length != 0 &&
                    _passwordController.text.trim().length != 0) {
                  _database.once().then((onValue) {
                    Map<dynamic, dynamic> users = new Map();
                    users.forEach((k, v) {
                      if (k["mail"] == _mailController.text) {
                        if (k["password" == _passwordController.text]) {
                          User u = new User(
                            goes: k["goes"],
                            id: k,
                            mail: k["mail"],
                            name: k["name"],
                            nationality: k["nationality"],
                            password: k["password"],
                            profilePic: k["profilePic"],
                          );
                        } else {
                          Flushbar(
                            message:
                                "Email and password does not matches, please check the areas!",
                            flushbarPosition: FlushbarPosition.TOP,
                            flushbarStyle: FlushbarStyle.FLOATING,
                            reverseAnimationCurve: Curves.decelerate,
                            forwardAnimationCurve: Curves.elasticOut,
                            backgroundColor: Colors.red,
                            boxShadows: [
                              BoxShadow(
                                  color: Colors.blue[800],
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0)
                            ],
                            backgroundGradient: LinearGradient(
                                colors: [Colors.red, Colors.white]),
                            isDismissible: false,
                            duration: Duration(seconds: 4),
                            icon: Icon(
                              Icons.warning,
                              color: Colors.greenAccent,
                            ),
                          )..show(context);
                        }
                      } else {
                        Flushbar(
                          message:
                              "Email does not found in system, please check the areas or sign in!",
                          flushbarPosition: FlushbarPosition.TOP,
                          flushbarStyle: FlushbarStyle.FLOATING,
                          reverseAnimationCurve: Curves.decelerate,
                          forwardAnimationCurve: Curves.elasticOut,
                          backgroundColor: Colors.red,
                          boxShadows: [
                            BoxShadow(
                                color: Colors.blue[800],
                                offset: Offset(0.0, 2.0),
                                blurRadius: 3.0)
                          ],
                          backgroundGradient: LinearGradient(
                              colors: [Colors.red, Colors.white]),
                          isDismissible: false,
                          duration: Duration(seconds: 4),
                          icon: Icon(
                            Icons.warning,
                            color: Colors.greenAccent,
                          ),
                        )..show(context);
                      }
                    });
                  });
                } else {
                  Flushbar(
                    message:
                        "Email and password cannot be empty, please check the areas!",
                    flushbarPosition: FlushbarPosition.TOP,
                    flushbarStyle: FlushbarStyle.FLOATING,
                    reverseAnimationCurve: Curves.decelerate,
                    forwardAnimationCurve: Curves.elasticOut,
                    backgroundColor: Colors.red,
                    boxShadows: [
                      BoxShadow(
                          color: Colors.blue[800],
                          offset: Offset(0.0, 2.0),
                          blurRadius: 3.0)
                    ],
                    backgroundGradient:
                        LinearGradient(colors: [Colors.red, Colors.white]),
                    isDismissible: false,
                    duration: Duration(seconds: 4),
                    icon: Icon(
                      Icons.warning,
                      color: Colors.greenAccent,
                    ),
                  )..show(context);
                }
              }
            },
          )
        ],
      ),
    );
  }
}
