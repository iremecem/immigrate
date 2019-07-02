import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:immigrate/Pages/PageCollector.dart';
import 'package:immigrate/Pages/SignInPage.dart';
import 'package:nice_button/NiceButton.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  TextEditingController _mailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  void checkUser(String email, String password, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => PageCollector(),
        ),
      );
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == "ERROR_INVALID_EMAIL" ||
            e.code == "ERROR_WRONG_PASSWORD") {
          Flushbar(
            backgroundColor: Colors.red,
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            message: "Email or password is not correct!",
            isDismissible: true,
            duration: Duration(seconds: 5),
          )..show(context);
        }
        if (e.code == "ERROR_USER_NOT_FOUND") {
          Flushbar(
            backgroundColor: Colors.red,
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            message: "User not found, please sign up.",
            isDismissible: true,
            duration: Duration(seconds: 5),
            mainButton: FlatButton(
              child: Text("Sign Up"),
              onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => SignInPage(),
                    ),
                  ),
            ),
          )..show(context);
        }
        if (e.code == "ERROR_USER_DISABLED") {
          Flushbar(
            backgroundColor: Colors.red,
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            message: "You have been banned from server Please contact for more information!",
            isDismissible: true,
            duration: Duration(seconds: 5),
          )..show(context);
        }
        if (e.code == "ERROR_TOO_MANY_REQUESTS") {
          Flushbar(
            backgroundColor: Colors.red,
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            message: "Too many request tries, please comeback in 10 minutes!",
            isDismissible: true,
            duration: Duration(seconds: 5),
          )..show(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
                  text: "Login",
                  background: Colors.lightGreen,
                  onPressed: () {
                    _fbKey.currentState.save();
                    if (_fbKey.currentState.validate()) {
                      print(_fbKey.currentState.value);
                      checkUser(_mailController.text, _passwordController.text,
                          context);
                    } else {
                      Flushbar(
                        backgroundColor: Colors.red,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        message: "Email or password is not correct!",
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
                child: Text(
                  "Or create an account",
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 25,
                  ),
                ),
                onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => SignInPage(),
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
