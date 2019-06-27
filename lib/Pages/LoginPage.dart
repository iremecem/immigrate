import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immigrate/Models/DatabaseHelper.dart';
import 'dart:io';
import 'package:immigrate/Models/User.dart';
import 'package:immigrate/Pages/SignPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  int selectedRegion = 0;

  File profilePic;

  SharedPreferences _preferences;

  DatabaseHelper _helper;

  var flagList = [
    DropdownMenuItem(
      child: Text("🇹🇷 Turkey"),
    ),
    DropdownMenuItem(
      child: Text("🇬🇧 United Kingdom"),
    ),
    DropdownMenuItem(
      child: Text("🇫🇷 France"),
    ),
    DropdownMenuItem(
      child: Text("🇮🇹 Italy"),
    ),
    DropdownMenuItem(
      child: Text("🇩🇪 Germany"),
    ),
    DropdownMenuItem(
      child: Text("🇷🇺 Russia"),
    ),
    DropdownMenuItem(
      child: Text("🇺🇸 United States"),
    ),
    DropdownMenuItem(
      child: Text("🇦🇪 United Arab Emirties"),
    )
  ];

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

  Future<Uri> uploadPic(File file) async {
    //Get the file from the image picker and store it
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child("images/");

    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(file);

    // Waits till the file is uploaded then stores the download url
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();

    //returns the download url
    return dowurl;
  }

  @override
  void initState() async {
    _preferences = await SharedPreferences.getInstance();
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
                child: Column(
                  children: <Widget>[
                    profilePic == null
                        ? Center(
                            child: CircleAvatar(
                              child: Image.asset(
                                  "assets/images/empty_profile.png"),
                            ),
                          )
                        : Center(
                            child: Image.file(profilePic),
                          ),
                    Row(
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
              Container(
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Enter your name here...",
                  ),
                ),
              ),
              Container(
                child: TextField(
                  controller: _mailController,
                  decoration: InputDecoration(
                    hintText: "Enter your e-mail here...",
                  ),
                ),
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
              Container(
                child: Column(
                  children: <Widget>[
                    Center(
                      child:
                          Text("Would you like to tell us where are you from?"),
                    ),
                    DropdownButton(
                      value: selectedRegion,
                      items: flagList,
                      onChanged: (value) {
                        setState(() {
                          selectedRegion = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              FlatButton.icon(
                icon: Icon(Icons.done),
                label: Text("Create my profile"),
                onPressed: () {
                  if (_mailController.text.trim().length != 0 &&
                      _nameController.text.trim().length != 0 &&
                      _passwordController.text.trim().length != 0) {
                    var uriProfile = uploadPic(profilePic);
                    _preferences.setBool("logged", true);
                    _preferences.setString("mail", _mailController.text);
                    _preferences.setString("password", _passwordController.text);
                    _auth.createUserWithEmailAndPassword(email: _mailController.text, password: _passwordController.text);
                    User user = new User(
                      id: Uuid().v4(),
                      mail: _mailController.text,
                      name: _nameController.text,
                      nationality:
                          flagList.elementAt(selectedRegion).toString(),
                      profilePic: uriProfile.toString(),
                    );
                    _helper.saveEvent(user);
                  } else {
                    Flushbar(
                      message:
                          "Name, email and password cannot be empty, please check the areas!",
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
                      isDismissible: false,
                      duration: Duration(seconds: 4),
                      icon: Icon(
                        Icons.warning,
                        color: Colors.greenAccent,
                      ),
                    )..show(context);
                  }
                },
              ),
              FlatButton(
                child: Text("Already signed in ? Press here to login up"),
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
