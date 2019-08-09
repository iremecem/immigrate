import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Pages/LoginPage.dart';
import 'package:immigrate/Pages/PageCollector.dart';
import 'package:immigrate/Pages/SetupPage.dart';
import 'package:immigrate/Pages/SignInPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseController {
  DatabaseReference _userRef =
      FirebaseDatabase.instance.reference().child("users");
  DatabaseReference _postsRef =
      FirebaseDatabase.instance.reference().child("posts");
  DatabaseReference _chatRef =
      FirebaseDatabase.instance.reference().child("chatRooms");
  FirebaseStorage _storageRef = FirebaseStorage.instance;

  Future authUser({String email, String password, BuildContext ctx}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      var response = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      response.sendEmailVerification();
      Navigator.of(ctx).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => SetupPage(),
        ),
      );
    } catch (exc) {
      if (exc is PlatformException) {
        if (exc.code == "ERROR_EMAIL_ALREADY_IN_USE") {
          Flushbar(
            backgroundColor: Colors.red,
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            message: "Email is already in use!",
            isDismissible: true,
            duration: Duration(seconds: 10),
            mainButton: FlatButton(
              child: Text("Login"),
              onPressed: () => Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => LoginPage(),
                ),
              ),
            ),
          )..show(ctx);
        }
      }
    }
  }

  Future loginUser({
    String email,
    String password,
    BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      var userAuth = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _userRef.child(userAuth.uid).once().then((onValue) {
        user.name = onValue.value["name"];
        user.to = onValue.value["to"];
        user.id = userAuth.uid;
        user.profilePic = onValue.value["profilePic"];
        _prefs.setString("name", user.name);
        _prefs.setString("to", user.to);
        _prefs.setString("id", user.id);
        _prefs.setString("profilePic", user.profilePic);
      }).then((onValue) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => PageCollector(),
          ),
        );
      });
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == "ERROR_INVALID_EMAIL" ||
            e.code == "ERROR_WRONG_PASSWORD") {
          Flushbar(
            backgroundColor: Colors.red,
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            message: "Email or password is not correct!",
            isDismissible: true,
            duration: Duration(seconds: 5),
          )..show(context);
        }
        if (e.code == "ERROR_USER_NOT_FOUND") {
          Flushbar(
            backgroundColor: Colors.red,
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            message: "User not found, please sign up.",
            isDismissible: true,
            duration: Duration(seconds: 5),
            mainButton: FlatButton(
              child: Text("Sign Up"),
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => SignInPage(),
                ),
              ),
            ),
          )..show(context);
        }
        if (e.code == "ERROR_USER_DISABLED") {
          Flushbar(
            backgroundColor: Colors.red,
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            message:
                "You have been banned from server Please contact for more information!",
            isDismissible: true,
            duration: Duration(seconds: 5),
          )..show(context);
        }
        if (e.code == "ERROR_TOO_MANY_REQUESTS") {
          Flushbar(
            backgroundColor: Colors.red,
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            message: "Too many request tries, please comeback in 10 minutes!",
            isDismissible: true,
            duration: Duration(seconds: 5),
          )..show(context);
        }
      }
    }
  }

  Future uploadProfilePic(File image) async {
    FirebaseUser fu = await FirebaseAuth.instance.currentUser();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String userId = fu.uid;
    StorageReference reference =
        _storageRef.ref().child(userId).child("profilePic");
    var dir = await getTemporaryDirectory();
    var targetPath = dir.absolute.path + randomAlphaNumeric(20);
    var result = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      targetPath,
      quality: 50,
    );
    reference.putFile(result);
    await reference.getDownloadURL().then((onValue) {
      _userRef.child(userId).child("profilePic").set(onValue);
      _prefs.setString("profilePic", onValue);
    });
  }

  void setupUser({String name, String from, String to}) async {
    FirebaseUser fu = await FirebaseAuth.instance.currentUser();
    String userId = fu.uid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userRef.child(userId).set(
      {
        "name": name,
        "from": from,
        "to": to,
      },
    );
    prefs.setString("id", userId);
    prefs.setString("name", name);
    prefs.setString("to", to);
  }
}
