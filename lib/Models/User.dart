import 'package:flutter/material.dart';

class User{
  String name;
  String mail;
  String id;
  String profilePic;
  String nationality;
  // String place; TODO: THİS WİLL CHANGE

  User({@required this.id, @required this.name, @required this.profilePic, @required this.mail, @required this.nationality});
}