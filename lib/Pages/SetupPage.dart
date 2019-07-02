import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immigrate/Models/DatabaseHelper.dart';
import 'package:immigrate/Models/User.dart';
import 'package:immigrate/Pages/PageCollector.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController _nameController = new TextEditingController();
  FirebaseStorage _storage = FirebaseStorage.instance;

  File _profilePic;
  String dropDownValueFrom = "tr";
  String dropDownValueTo = "tr";

  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _profilePic = image;
    });
  }

  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilePic = image;
    });
  }

  Future<String> uploadPic(File image) async {
    FirebaseUser fu = await FirebaseAuth.instance.currentUser();
    String userId = fu.uid;
    StorageReference reference = _storage.ref().child(userId);
    StorageUploadTask uploadTask = reference.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    Uri location = taskSnapshot.uploadSessionUri;
    return location.toString();
  }

  void setupUser(String name, String from, String to, File image) async {
    FirebaseUser fu = await FirebaseAuth.instance.currentUser();
    String userId = fu.uid;
    String profileUriToString = await uploadPic(image);
    DatabaseHelper helper = new DatabaseHelper();
    final database = FirebaseDatabase.instance.reference();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = new User(
      from: from,
      id: userId,
      name: name,
      to: to,
      profilePic: profileUriToString,
    );
    helper.saveEvent(user);
    database.child(userId).set(
      {
        "name": name,
        "from": from,
        "to": to,
        "profilePic": profileUriToString,
      },
    );
    prefs.setString("id", userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setup Your Account"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              InkWell(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 300,
                        height: 350,
                        child: _profilePic == null
                            ? Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors.white54,
                                  radius: 150,
                                  child: Text(
                                    "Tap here to setup profile picture",
                                    style: TextStyle(
                                      color: Colors.lightGreen,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors.white54,
                                  radius: 150,
                                  child: Image.file(
                                    _profilePic,
                                    fit: BoxFit.cover,
                                    width: 300,
                                    height: 350,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Pick a picture"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                "From Camera",
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontSize: 15,
                                ),
                              ),
                              onPressed: () {
                                getImageCamera();
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                "From Gallery",
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontSize: 15,
                                ),
                              ),
                              onPressed: () {
                                getImageGallery();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
              Divider(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              FormBuilderTextField(
                attribute: "name",
                validators: [
                  FormBuilderValidators.required(),
                ],
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Name Surname",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              FormBuilder(
                key: _fbKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        "Where are you coming from?",
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    FormBuilderDropdown(
                      attribute: "from",
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
                      initialValue: dropDownValueFrom,
                      onChanged: (value) {
                        setState(() {
                          dropDownValueFrom = value;
                        });
                      },
                      elevation: 10,
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                      iconSize: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Where are you now?",
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    FormBuilderDropdown(
                      attribute: "to",
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
                      initialValue: dropDownValueTo,
                      onChanged: (value) {
                        setState(() {
                          dropDownValueTo = value;
                        });
                      },
                      elevation: 10,
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                      iconSize: 40,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Center(
                child: NiceButton(
                  width: 255,
                  elevation: 8.0,
                  radius: 52.0,
                  text: "Create Profile",
                  background: Colors.lightGreen,
                  onPressed: () {
                    _fbKey.currentState.save();
                    if (_fbKey.currentState.validate()) {
                      print(_fbKey.currentState.value);
                      if (dropDownValueFrom == dropDownValueTo) {
                        Flushbar(
                          backgroundColor: Colors.red,
                          flushbarStyle: FlushbarStyle.FLOATING,
                          flushbarPosition: FlushbarPosition.BOTTOM,
                          message:
                              "You can't select your nationality and destination as same value!",
                          isDismissible: true,
                          duration: Duration(seconds: 5),
                        )..show(context);
                      } else if (_profilePic == null) {
                        Flushbar(
                          backgroundColor: Colors.red,
                          flushbarStyle: FlushbarStyle.FLOATING,
                          flushbarPosition: FlushbarPosition.BOTTOM,
                          message: "You must select a profile picture!",
                          isDismissible: true,
                          duration: Duration(seconds: 5),
                        )..show(context);
                      } else {
                        setupUser(_nameController.text, dropDownValueFrom,
                            dropDownValueTo, _profilePic);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageCollector(),
                          ),
                        );
                      }
                    } else {
                      Flushbar(
                        backgroundColor: Colors.red,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        message: "Name can not be empty!",
                        isDismissible: true,
                        duration: Duration(seconds: 5),
                      )..show(context);
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
