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

// commented
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
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      var response = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      response.sendEmailVerification();
      _prefs.setString("mail", email);
      _prefs.setString("password", password);
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

        _prefs.setString("mail", email);
        _prefs.setString("password", password);
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
        "mail": fu.email,
        "password": prefs.getString("password"),
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

  Future signOut() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove("id");
    _prefs.remove("to");
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

  Future sendMessage(
      {String text, String token, String sender, File image}) async {
    if (image != null) {
      StorageReference reference =
          _storageRef.ref().child(token).child(randomAlphaNumeric(40));
      var dir = await getTemporaryDirectory();
      var targetPath = dir.absolute.path + randomAlphaNumeric(20);
      var result = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        targetPath,
        quality: 50,
      );
      await reference.putFile(result).onComplete.then((onValue) async {
        await reference.getDownloadURL().then((onalue) async {
          String path = randomAlphaNumeric(30);
          await _chatRef.child(token).child("messages").child(path).set({
            "message": text,
            "date": DateTime.now().toIso8601String(),
            "sender": sender,
            "messageKey": path,
            "photoUrl": onalue,
          });
        });
      });
    } else {
      String path = randomAlphaNumeric(30);
      await _chatRef.child(token).child("messages").child(path).set({
        "message": text,
        "date": DateTime.now().toIso8601String(),
        "sender": sender,
        "messageKey": path,
      });
    }
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
          await _postsRef.child(to).child(absPath).set(
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
      await _postsRef.child(to).child(absPath).set(
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

  Future deletePost({
    String postId,
    String to,
    String absolutePath,
    String userId,
  }) async {
    try {
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child("postImages");
      await storageReference.child(absolutePath).delete().then((onValue) async {
        await _postsRef
            .child(to)
            .child(absolutePath)
            .remove()
            .then((onValue) async {
          await _userRef
              .child(userId)
              .child("posts")
              .child(absolutePath)
              .remove();
        });
      });
    } on PlatformException catch (exc) {
      print(exc.details);
      await _postsRef
          .child(to)
          .child(absolutePath)
          .remove()
          .then((onValue) async {
        await _userRef
            .child(userId)
            .child("posts")
            .child(absolutePath)
            .remove();
      });
    }
  }

  Future changeUserName({String newName}) async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("name", newName);
    await _userRef.child(_user.uid).child("name").set(newName);
  }

  Future changeCountry({String newCountry}) async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("to", newCountry);
    await _userRef.child(_user.uid).child("to").set(newCountry);
  }

  Future changeUserMail({String newMail, BuildContext context}) async {
    try {
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      await _user.updateEmail(newMail);
      await _user.sendEmailVerification();
      _prefs.setString("mail", newMail);
      await _userRef.child(_user.uid).child("mail").set(newMail);
    } on PlatformException catch (exc) {
      if (exc.code == "ERROR_INVALID_CREDENTIAL") {
        Flushbar(
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: Colors.red,
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.BOTTOM,
          message:
              "The new email has been malformed! Please try another one...",
          isDismissible: true,
          duration: Duration(seconds: 5),
        )..show(context);
      }
      if (exc.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        Flushbar(
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: Colors.red,
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.BOTTOM,
          message: "The new mail address has been used!",
          isDismissible: true,
          duration: Duration(seconds: 5),
        )..show(context);
      }
      if (exc.code == "ERROR_USER_DISABLED") {
        Flushbar(
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: Colors.red,
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.BOTTOM,
          message:
              "The new mail has been banned from server, please contact with an administirator!",
          isDismissible: true,
          duration: Duration(seconds: 5),
        )..show(context);
      }
      if (exc.code == "ERROR_USER_NOT_FOUND") {
        Flushbar(
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: Colors.red,
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.BOTTOM,
          message:
              "It looks like you have been deleted from the server, please contact with an administirator!",
          isDismissible: true,
          duration: Duration(seconds: 5),
        )..show(context);
      }
      if (exc.code == "ERROR_REQUIRES_RECENT_LOGIN") {
        Flushbar(
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: Colors.red,
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.BOTTOM,
          message:
              "It looks like you have not been logged to server for a long time, please login again to continue!",
          isDismissible: true,
          duration: Duration(seconds: 8),
          mainButton: FlatButton(
            child: Text("Login Again"),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LoginPage(),
              ),
            ),
          ),
        )..show(context);
      }
      if (exc.code == "ERROR_OPERATION_NOT_ALLOWED") {
        Flushbar(
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: Colors.red,
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.BOTTOM,
          message:
              "You have not been verified your recent email yet, please verify and try again!",
          isDismissible: true,
          duration: Duration(seconds: 5),
        )..show(context);
      }
    }
  }

  Future changePassword({String password, BuildContext context}) async {
    try {
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      await _user.updatePassword(password);
      _prefs.setString("password", password);
      _userRef.child(_user.uid).child("password").set(password);
    } on PlatformException catch (exc) {
      print(exc.code);
      if (exc.code == "ERROR_WEAK_PASSWORD") {
        Flushbar(
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: Colors.red,
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.BOTTOM,
          message: "The new password is not strong enough, please try again!",
          isDismissible: true,
          duration: Duration(seconds: 5),
        )..show(context);
      }
      if (exc.code == "ERROR_USER_DISABLED") {
        Flushbar(
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: Colors.red,
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.BOTTOM,
          message:
              "The new mail has been banned from server, please contact with an administirator!",
          isDismissible: true,
          duration: Duration(seconds: 5),
        )..show(context);
      }
      if (exc.code == "ERROR_USER_NOT_FOUND") {
        Flushbar(
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: Colors.red,
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.BOTTOM,
          message:
              "It looks like you have been deleted from the server, please contact with an administirator!",
          isDismissible: true,
          duration: Duration(seconds: 5),
        )..show(context);
      }
      if (exc.code == "ERROR_REQUIRES_RECENT_LOGIN") {
        Flushbar(
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: Colors.red,
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.BOTTOM,
          message:
              "It looks like you have not been logged to server for a long time, please login again to continue!",
          isDismissible: true,
          duration: Duration(seconds: 8),
          mainButton: FlatButton(
            child: Text("Login Again"),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LoginPage(),
              ),
            ),
          ),
        )..show(context);
      }
      if (exc.code == "ERROR_OPERATION_NOT_ALLOWED") {
        Flushbar(
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: Colors.red,
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.BOTTOM,
          message:
              "You have not been verified your recent email yet, please verify and try again!",
          isDismissible: true,
          duration: Duration(seconds: 5),
        )..show(context);
      }
    }
  }

  Future blockUser({String userID, String otherUserID, String roomID}) async {
    await _chatRef.child(roomID).remove();
    await _userRef.child(userID).child("rooms").child(roomID).remove();
    await _userRef.child(otherUserID).child("rooms").child(roomID).remove();
    await _userRef.child(userID).child("blockedUsers").push().set(otherUserID);
    await _userRef.child(otherUserID).child("blockedUsers").push().set(userID);
  }

  Future setAge({String userID, String age}) async {
    await _userRef.child(userID).child("age").set(age);
  }

  Future setProffession({String userID, String proffession}) async {
    await _userRef.child(userID).child("proffession").set(proffession);
  }

  Future setGender({String userID, String gender}) async {
    await _userRef.child(userID).child("gender").set(gender);
  }
}
