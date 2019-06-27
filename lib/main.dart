import 'package:flutter/material.dart';
import 'package:immigrate/Pages/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loggedIn = prefs.getBool("logged");
  runApp(
    MaterialApp(
      home: loggedIn == false ? LoginPage() : PageController(),
    ),
  );
}
