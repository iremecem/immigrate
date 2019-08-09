import 'package:flutter/material.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Pages/LoginPage.dart';
import 'package:immigrate/Pages/PageCollector.dart';
import 'package:immigrate/Pages/SetupPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String userId = _prefs.getString("id");
  String userName = _prefs.getString("name");
  String to = _prefs.getString("to");
  String profilePic = _prefs.getString("profilePic");
  user.id = userId;
  user.name = userName;
  user.to = to;
  user.profilePic = profilePic;

  Widget _selectScreen({String userId, String to}) {
    if (userId == null) {
      return LoginPage();
    }
    if (userId != null && to == null) {
      return SetupPage();
    }
    if (userId != null && to != null) {
      return PageCollector();
    }
    return LoginPage();
  }

  runApp(
    MaterialApp(
      home: _selectScreen(
        userId: user.id,
        to: user.to,
      ),
    ),
  );
}
