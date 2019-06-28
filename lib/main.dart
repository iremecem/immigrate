
import 'package:flutter/material.dart';
import 'package:immigrate/Pages/LoginPage.dart';
import 'package:immigrate/Pages/PageCollecor.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final prefs = await SharedPreferences.getInstance();
  //TODO: ADD AUTH CHECK FOR FIREBASE
  runApp(
    MaterialApp(
      home: PageCollector(),
    ),
  );
}
