import 'package:flutter/material.dart';

class User{
  String name;
  String mail;
  String id;
  String profilePic;
  String nationality;
  String password;
  String goes;
  // String place; TODO: THİS WİLL CHANGE

  User({@required this.id, @required this.name, @required this.profilePic, @required this.mail, @required this.nationality, @required this.password, @required this.goes});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      name: json["name"],
      id: json["id"],
      mail: json["mail"],
      nationality: json["nationality"],
      goes: json["goes"],
      profilePic: json["profilePic"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "mail": mail,
      "id": id,
      "nationality" : nationality,
      "profilePic" : profilePic,
      "password" : password,
      "goes" : goes,
    };
  }
}