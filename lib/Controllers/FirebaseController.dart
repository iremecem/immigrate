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
      var response = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _userRef.child(response.uid).once().then((onValue) {
        user.name = onValue.value["name"];
        user.to = onValue.value["to"];
        user.id = onValue.value;
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
    reference.putFile(result).onComplete.then((onValue) async {
      await reference.getDownloadURL().then((onalue) {
        _userRef.child(userId).child("profilePic").set(onalue);
        _prefs.setString("profilePic", onalue);
      });
    });
  }

  Future setupUser({String name, String from, String to, File image}) async {
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
    await uploadProfilePic(image);
    prefs.setString("id", userId);
    prefs.setString("name", name);
    prefs.setString("to", to);
    prefs.setString("from", from);
    user.id = userId;
    user.name = name;
    user.to = to;
  }

  Future setUserLocation({String userId, double lat, double long}) async {
    await _userRef.child(userId).child("lat").set(lat);
    await _userRef.child(userId).child("lon").set(long);
  }

  Future<String> createToken() async {
    String token = randomAlphaNumeric(20);
    return await _chatRef.once().then((onValue) {
      Map<dynamic, dynamic> values = onValue.value;
      if (values != null && values.keys.contains(token)) {
        do {
          token = randomAlphaNumeric(20);
        } while (values.keys.contains(token));
      }
      return token;
    });
  }

  Future createChatSpace({
    String senderName,
    String senderUid,
    String recieverName,
    String recieverUid,
    String user1ProfPic,
    String user2ProfPic,
    String roomToken,
  }) async {
    await _chatRef.child(roomToken).set({
      "user1": senderUid,
      "user2": recieverUid,
      "name1": senderName,
      "name2": recieverName,
      "pic1": user1ProfPic,
      "pic2": user2ProfPic,
    });
    await _userRef.child(senderUid).child("rooms").child(roomToken).set({
      "user1": senderUid,
      "user2": recieverUid,
      "name1": senderName,
      "name2": recieverName,
      "pic1": user1ProfPic,
      "pic2": user2ProfPic,
    });
    await _userRef.child(recieverUid).child("rooms").child(roomToken).set({
      "user1": senderUid,
      "user2": recieverUid,
      "name1": senderName,
      "name2": recieverName,
      "pic1": user1ProfPic,
      "pic2": user2ProfPic,
    });
  }

  Future<bool> checkUserHasConnectionWith(
      {String userUid, String otherUid}) async {
    return await _userRef
        .child(userUid)
        .child("rooms")
        .once()
        .then((onValue) async {
      if (onValue != null) {
        Map data = onValue.value;
        bool contains = false;
        if (data != null) {
          data.forEach((k, v) {
            if (v["user1"] == otherUid || v["user2"] == otherUid) {
              contains = true;
              print("Contains 1: " + contains.toString());
            }
          });
          print("Contains 2: " + contains.toString());
          return contains;
        } else {
          return contains;
        }
      } else {
        return false;
      }
    });
  }

  Future<String> retrieveChatToken({String user1Uid, String user2Uid}) async {
    return await _userRef
        .child(user1Uid)
        .child("rooms")
        .once()
        .then((onValue) async {
      if (onValue.value != null) {
        Map data = onValue.value;
        String roomToken = "";
        data.forEach((k, v) {
          if ((v["user1"] == user1Uid && v["user2"] == user2Uid) ||
              (v["user1"] == user2Uid && v["user2"] == user1Uid)) {
            roomToken = k;
          }
        });
        return roomToken;
      } else {
        return "";
      }
    });
  }

  Future sendMessage({String text, String token, String sender}) async {
    String path = randomAlphaNumeric(30);
    await _chatRef.child(token).child("messages").child(path).set({
      "message": text,
      "date": DateTime.now().toIso8601String(),
      "sender": sender,
      "messageKey": path,
    });
  }

  Future deleteMessage({String messageKey, String token}) async {
    await _chatRef.child(token).child("messages").child(messageKey).remove();
  }

  Future sendPost({
    String senderName,
    String senderId,
    String content,
    File image,
    String to,
    String from,
  }) async {
    if (image != null) {
      StorageReference reference = _storageRef.ref().child("postImages");
      var dir = await getTemporaryDirectory();
      var targetPath = dir.absolute.path + randomAlphaNumeric(20);
      var result = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        targetPath,
        quality: 50,
      );
      var absPath = randomAlphaNumeric(40);
      reference.child(absPath).putFile(result).onComplete.then((onValue) async {
        await reference.child(absPath).getDownloadURL().then((onalue) async {
          await _postsRef.child(to).child(randomAlphaNumeric(30)).set(
            {
              "senderId": senderId,
              "senderName": senderName,
              "content": content,
              "imageUrl": onalue,
              "date": DateTime.now().toIso8601String(),
              "to": to,
              "from": from,
              "profilePicUrl": user.profilePic,
              "absolutePath": absPath,
            },
          );
          await _userRef.child(senderId).child("posts").child(absPath).set(
            {
              "senderId": senderId,
              "senderName": senderName,
              "content": content,
              "imageUrl": onalue,
              "date": DateTime.now().toIso8601String(),
              "to": to,
              "from": from,
              "profilePicUrl": user.profilePic,
              "absolutePath": absPath,
            },
          );
        });
      });
    } else {
      var absPath = randomAlphaNumeric(30);
      await _postsRef.child(to).child(randomAlphaNumeric(30)).set(
        {
          "senderId": senderId,
          "senderName": senderName,
          "content": content,
          "date": DateTime.now().toIso8601String(),
          "to": to,
          "from": from,
          "profilePicUrl": user.profilePic,
          "absolutePath": absPath,
        },
      );
      await _userRef.child(senderId).child("posts").child(absPath).set(
        {
          "senderId": senderId,
          "senderName": senderName,
          "content": content,
          "date": DateTime.now().toIso8601String(),
          "to": to,
          "from": from,
          "profilePicUrl": user.profilePic,
          "absolutePath": absPath,
        },
      );
    }
  }

  Future deletePost(
      {String postId, String to, String absolutePath, String userId}) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("postImages");
    await storageReference.child(absolutePath).delete();
    await _postsRef.child(to).child(postId).remove();
    await _userRef.child(userId).child("posts").child(absolutePath).remove();
  }
}
