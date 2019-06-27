import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:immigrate/Models/User.dart';
import 'package:uuid/uuid.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _mailController = new TextEditingController();

  int selectedRegion = 0;
  File profilePic;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text("Would you like to tell us your name?"),
                  ),
                  TextField(
                    controller: _nameController,
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text("Could you write your email, please?"),
                  ),
                  TextField(
                    controller: _mailController,
                  ),
                ],
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
            Container(
              child: Column(
                children: <Widget>[
                  profilePic == null
                      ? Center(
                          child: Text("Provide a profile picture of you"),
                        )
                      : Image.file(profilePic),
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
            FlatButton.icon(
              icon: Icon(Icons.done),
              label: Text("Create my profile"),
              onPressed: () {
                //TODO: UPLOAD PROFILE PIC TO FIREBASE STORAGE, DATABASE STORAGE AND WHILE PATH DOES NOT EXISTS, DOWNLOAD IT FROM DATABASE AND SAVE TO LOCAL STORAGE
                //TODO: ADD IF ELSE CHECKED STATEMENTS AND FLUSHBAR
                //TODO: SAVE USER TO THE SHARED PREFS AND DATABASE
                User user = new User(id: Uuid().v4(), mail: _mailController.text, name: _nameController.text, nationality: flagList.elementAt(selectedRegion).toString(),profilePic: profilePic.path);
              },
            )
          ],
        ),
      ),
    );
  }
}
