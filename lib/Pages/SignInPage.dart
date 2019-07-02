import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
      //backgroundColor: Colors.lightGreen.shade400,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _fbKey,
                autovalidate: false,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    FormBuilderTextField(
                      attribute: "email",
                      validators: [
                        FormBuilderValidators.email(),
                        FormBuilderValidators.required(),
                      ],
                      controller: _mailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "example@anymail.com",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    FormBuilderTextField(
                      attribute: "password",
                      validators: [
                        FormBuilderValidators.minLength(6),
                        FormBuilderValidators.required(),
                      ],
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    FormBuilderTextField(
                      attribute: "password",
                      validators: [
                        FormBuilderValidators.minLength(6),
                        FormBuilderValidators.required(),
                      ],
                      obscureText: true,
                      controller: _secondaryController,
                      decoration: InputDecoration(
                        labelText: "Password Again...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
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
                    color: Colors.lightGreen,
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
