
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:immigrate/Pages/LoginPage.dart';
import 'package:immigrate/Pages/PageCollector.dart';

void main() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  runApp(
    MaterialApp(
      home: user == null ? LoginPage() : PageCollector(),
    ),
  );
}
