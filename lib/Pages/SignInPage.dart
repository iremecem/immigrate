import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Pages/LoginPage.dart';
import 'package:simple_design/simple_design.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final FirebaseController _controller = new FirebaseController();
  TextEditingController _mailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _secondaryController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.all(12),
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
              title: "Sign Up to Countryman App",
              content: Center(
                child: FormBuilder(
                  key: _fbKey,
                  autovalidate: false,
                  child: Column(
                    children: <Widget>[
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
              height: 25,
            ),
            FlatButton(
              onPressed: () async {
                _fbKey.currentState.save();
                if (_fbKey.currentState.validate() &&
                    _passwordController.text == _secondaryController.text) {
                  print(_fbKey.currentState.value);
                  await _controller.authUser(
                    ctx: context,
                    email: _mailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
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
              child: Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 20
                ),
              ),
            ),
            Container(
              height: 25,
            ),
            Text("Already signed in?"),
            FlatButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => LoginPage(),
                ),
              ),
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.lightGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
