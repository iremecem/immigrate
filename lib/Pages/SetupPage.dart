import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Pages/PageCollector.dart';
import 'package:simple_design/simple_design.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController _nameController = new TextEditingController();
  FirebaseController _controller = new FirebaseController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                height: 30,
              ),
              InkWell(
                child: _profilePic == null
                    ? Center(
                        child: Text(
                          "Tap here to setup profile picture",
                          style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: 15,
                          ),
                        ),
                      )
                    : Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(_profilePic),
                            fit: BoxFit.cover,
                          ),
                        ),
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
              SDCard(
                title: "Setup Your Account",
                content: FormBuilder(
                  key: _fbKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        attribute: "name",
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Tap to add name",
                          hintText: "Name Surname",
                          border: InputBorder.none,
                          labelStyle: TextStyle(color: Colors.lightGreen),
                          icon: Icon(
                            FontAwesomeIcons.signature,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ),
                      SDDivider(),
                      Container(
                        height: 10,
                      ),
                      Text(
                        "Where are you coming from?",
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 15,
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: FormBuilderDropdown(
                          attribute: "from",
                          items: [
                            DropdownMenuItem(
                              child: Text(
                                "🇹🇷 Turkey",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "tr",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇬🇧 United Kingdom",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "gb",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇫🇷 France",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "fr",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇮🇹 Italy",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "it",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇩🇪 Germany",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "de",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇷🇺 Russia",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "rs",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇺🇸 United States",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "us",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇦🇪 United Arab Emirates",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
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
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        "Where are you now?",
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 15,
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: FormBuilderDropdown(
                          attribute: "to",
                          items: [
                            DropdownMenuItem(
                              child: Text(
                                "🇹🇷 Turkey",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "tr",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇬🇧 United Kingdom",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "gb",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇫🇷 France",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "fr",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇮🇹 Italy",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "it",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇩🇪 Germany",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "de",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇷🇺 Russia",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "rs",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇺🇸 United States",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              value: "us",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "🇦🇪 United Arab Emirates",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
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
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 25,
              ),
              FlatButton(
                onPressed: () async {
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
                      await _controller.setupUser(
                        name: _nameController.text.trim(),
                        from: dropDownValueFrom,
                        to: dropDownValueTo,
                        image: _profilePic,
                      );
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
                child: Text(
                  "Create Profile",
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
