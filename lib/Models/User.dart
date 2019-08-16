class User{
  String name;
  String id;
  String profilePic;
  String from;
  String to;
  double lat;
  double lon;

  User({this.id, this.name, this.profilePic, this.from, this.to, this.lat, this.lon});

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