import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immigrate/Pages/LoginPage.dart';
import 'package:immigrate/Pages/SetupPage.dart';
import 'package:nice_button/NiceButton.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  TextEditingController _mailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _secondaryController = new TextEditingController();

  void authUser(String email, String password, BuildContext ctx) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      var response = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      response.sendEmailVerification();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => SetupPage(),
        ),
      );
    } catch (exc) {
      if (exc is PlatformException) {
        if (exc.code == "ERROR_EMAIL_ALREADY_IN_USE") {
          Flushbar(
            backgroundColor: Colors.red,
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            message: "Email is already in use!",
            isDismissible: true,
            duration: Duration(seconds: 10),
            mainButton: FlatButton(
              child: Text("Login"),
              onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => LoginPage(),
                    ),
                  ),
            ),
          )..show(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      backgroundColor: Colors.lightGreen.shade400,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _fbKey,
                autovalidate: false,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                    ),
                    Container(
                      child: Image.asset("assets/images/dummy-imm.png"),
                      height: MediaQuery.of(context).size.height / 4,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.lightGreen.shade300,
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                          )
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: FormBuilderTextField(
                          attribute: "email",
                          validators: [
                            FormBuilderValidators.email(),
                            FormBuilderValidators.required(),
                          ],
                          controller: _mailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "example@anymail.com",
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.lightGreen),
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.lightGreen,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.lightGreen.shade300,
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                          )
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: FormBuilderTextField(
                          attribute: "password",
                          validators: [
                            FormBuilderValidators.minLength(6),
                            FormBuilderValidators.required(),
                          ],
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.lightGreen),
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.unlockAlt,
                              color: Colors.lightGreen,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.lightGreen.shade300,
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                          )
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: FormBuilderTextField(
                          attribute: "password",
                          validators: [
                            FormBuilderValidators.minLength(6),
                            FormBuilderValidators.required(),
                          ],
                          obscureText: true,
                          controller: _secondaryController,
                          decoration: InputDecoration(
                            labelText: "Password Again...",
                            labelStyle: TextStyle(color: Colors.lightGreen),
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.unlockAlt,
                              color: Colors.lightGreen,
                            ),
                          ),
                        ),
                      ),
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
                  text: "Sign Up",
                  background: Colors.lightGreen,
                  onPressed: () {
                    _fbKey.currentState.save();
                    if (_fbKey.currentState.validate() &&
                        _passwordController.text == _secondaryController.text) {
                      print(_fbKey.currentState.value);
                      authUser(_mailController.text, _passwordController.text,
                          context);
                    } else {
                      Flushbar(
                        backgroundColor: Colors.red,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        message:
                            "Passwords are not same or empty, please re-enter!",
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
              FlatButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => LoginPage(),
                      ),
                    ),
                child: Text(
                  "Already signed in?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
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
