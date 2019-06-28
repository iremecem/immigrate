import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immigrate/Models/DatabaseHelper.dart';
import 'dart:io';
import 'package:immigrate/Models/User.dart';
import 'package:immigrate/Pages/PageCollecor.dart';
import 'package:immigrate/Pages/SignPage.dart';
import 'package:uuid/uuid.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _mailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  final _database = FirebaseDatabase.instance.reference();

  String selectedRegion = "tr";
  String goes = "tr";

  File profilePic;

  String profileUrl = "";

  DatabaseHelper _helper;

  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      profilePic = image;
    });
  }

  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      profilePic = image;
    });
  }

  Future<String> uploadPic(File file) async {
    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child("images/");
    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(file);
    // Waits till the file is uploaded then stores the download url
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    //returns the download url
    setState(() {
      profileUrl = dowurl;
    });
    return dowurl;
  }

  @override
  void initState() {
    _helper = DatabaseHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 300,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    profilePic == null
                        ? Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 100,
                              child: Image.asset(
                                  "assets/images/empty_profile.png"),
                            ),
                          )
                        : Center(
                            child: Image.file(profilePic, fit: BoxFit.fill,),
                          ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.camera),
                          onPressed: getImageCamera,
                        ),
                        IconButton(
                          icon: Icon(Icons.image),
                          onPressed: getImageGallery,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
              ),
              Container(
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Enter your name here...",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
              ),
              Container(
                child: TextField(
                  controller: _mailController,
                  decoration: InputDecoration(
                    hintText: "Enter your e-mail here...",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
              ),
              Container(
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter your password here...",
                  ),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Center(
                      child:
                          Text("Would you like to tell us where are you from?"),
                    ),
                    DropdownButton(
                      value: selectedRegion,
                      items: [
                        DropdownMenuItem(
                          child: Text("🇹🇷 Turkey"),
                          value: "tr",
                        ),
                        DropdownMenuItem(
                          child: Text("🇬🇧 United Kingdom"),
                          value: "gb",
                        ),
                        DropdownMenuItem(
                          child: Text("🇫🇷 France"),
                          value: "fr",
                        ),
                        DropdownMenuItem(
                          child: Text("🇮🇹 Italy"),
                          value: "it",
                        ),
                        DropdownMenuItem(
                          child: Text("🇩🇪 Germany"),
                          value: "ge",
                        ),
                        DropdownMenuItem(
                          child: Text("🇷🇺 Russia"),
                          value: "rs",
                        ),
                        DropdownMenuItem(
                          child: Text("🇺🇸 United States"),
                          value: "us",
                        ),
                        DropdownMenuItem(
                          child: Text("🇦🇪 United Arab Emirates"),
                          value: "ae",
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedRegion = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                          "Could you tell us where are you going or living?"),
                    ),
                    DropdownButton(
                      value: goes,
                      items: [
                        DropdownMenuItem(
                          child: Text("🇹🇷 Turkey"),
                          value: "tr",
                        ),
                        DropdownMenuItem(
                          child: Text("🇬🇧 United Kingdom"),
                          value: "gb",
                        ),
                        DropdownMenuItem(
                          child: Text("🇫🇷 France"),
                          value: "fr",
                        ),
                        DropdownMenuItem(
                          child: Text("🇮🇹 Italy"),
                          value: "it",
                        ),
                        DropdownMenuItem(
                          child: Text("🇩🇪 Germany"),
                          value: "ge",
                        ),
                        DropdownMenuItem(
                          child: Text("🇷🇺 Russia"),
                          value: "rs",
                        ),
                        DropdownMenuItem(
                          child: Text("🇺🇸 United States"),
                          value: "us",
                        ),
                        DropdownMenuItem(
                          child: Text("🇦🇪 United Arab Emirates"),
                          value: "ae",
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          goes = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
              ),
              FlatButton.icon(
                icon: Icon(Icons.done, color: Colors.lightGreen,),
                label: Text("Create my profile", style: TextStyle(color: Colors.lightGreen),),
                onPressed: () async {
                  if (_mailController.text.trim().length != 0 &&
                      _nameController.text.trim().length != 0 &&
                      _passwordController.text.trim().length >= 0 &&
                      goes != selectedRegion) {
                    var uriProfile = uploadPic(profilePic);
                    var id = Uuid().v4();
                    _auth.createUserWithEmailAndPassword(
                        email: _mailController.text,
                        password: _passwordController.text);
                    _database.child(id).set({
                      "password": _passwordController.text,
                      "nationality": selectedRegion,
                      "goes": goes,
                      "profilePic": profileUrl,
                      "mail": _mailController.text,
                      "name": _nameController.text,
                    });
                    User user = new User(
                      id: id,
                      mail: _mailController.text,
                      name: _nameController.text,
                      nationality: selectedRegion,
                      profilePic: profileUrl,
                      password: _passwordController.text,
                      goes: goes,
                    );
                    _helper.saveEvent(user);
                  } else {
                    Flushbar(
                      message:
                          "Name, email and password cannot be empty, and password must be equal or longer than 6 characters and you can't select same nationalities, please check the areas!",
                      flushbarPosition: FlushbarPosition.TOP,
                      flushbarStyle: FlushbarStyle.FLOATING,
                      reverseAnimationCurve: Curves.decelerate,
                      forwardAnimationCurve: Curves.elasticOut,
                      backgroundColor: Colors.red,
                      boxShadows: [
                        BoxShadow(
                            color: Colors.blue[800],
                            offset: Offset(0.0, 2.0),
                            blurRadius: 3.0)
                      ],
                      backgroundGradient:
                          LinearGradient(colors: [Colors.red, Colors.white]),
                      isDismissible: true,
                      duration: Duration(seconds: 10),
                      icon: Icon(
                        Icons.warning,
                        color: Colors.greenAccent,
                      ),
                    )..show(context);
                  }
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => new PageCollector()));
                },
              ),
              FlatButton(
                child: Text(
                  "Already signed in ? Press here to login up",
                  style: TextStyle(color: Colors.lightGreen),
                ),
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignPage(),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
