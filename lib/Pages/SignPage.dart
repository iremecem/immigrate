import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class SignPage extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  TextEditingController _mailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
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
                  _auth.signInWithEmailAndPassword(
                    email: _mailController.text,
                    password: _passwordController.text,
                  );
                }else{
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
