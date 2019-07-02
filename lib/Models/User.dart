import 'package:flutter/material.dart';

class User{
  String name;
  String id;
  String profilePic;
  String from;
  String to;
  // String place; TODO: THİS WİLL CHANGE

  User({@required this.id, @required this.name, @required this.profilePic, @required this.from, @required this.to});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      name: json["name"],
      id: json["id"],
      from: json["fromi"],
      to: json["toi"],
      profilePic: json["profilePic"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
      "fromi" : from,
      "profilePic" : profilePic,
      "toi" : to,
    };
  }
}