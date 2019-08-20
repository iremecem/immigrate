import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Pages/SignInPage.dart';
import 'package:simple_design/simple_design.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final FirebaseController _controller = new FirebaseController();
  TextEditingController _mailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 30,
            ),
            Image(
              image: AssetImage("assets/images/dummy-imm.png"),
              height: 300,
              width: 300,
            ),
            Container(
              height: 30,
            ),
            SDCard(
              title: "Login to Countryman App",
              content: Center(
                child: FormBuilder(
                  key: _fbKey,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: "email",
                        validators: [
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
                          labelStyle: TextStyle(color: Colors.lightGreen),
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.unlockAlt,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 30,
            ),
            FlatButton(
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 25,
                ),
              ),
              onPressed: () async {
                _fbKey.currentState.save();
                if (_fbKey.currentState.validate()) {
                  print(_fbKey.currentState.value);
                  _controller.loginUser(
                    context: context,
                    email: _mailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
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
            Container(
              height: 25,
            ),
            Text(
              "Don't have an account?",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            FlatButton(
              child: Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.lightGreen,
                ),
              ),
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => SignInPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
