import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:immigrate/Pages/LoginPage.dart';
import 'package:immigrate/Pages/PageCollecor.dart';

void main() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  runApp(
    MaterialApp(
      home: _auth.currentUser() == null ? LoginPage() : PageCollector(),
    ),
  );
}
