import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:simple_design/simple_design.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String value;
  final BuildContext context;
  ChangePasswordScreen({@required this.value, @required this.context});
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final FirebaseController _controller = new FirebaseController();
  final TextEditingController _originalController = new TextEditingController();
  final TextEditingController _editingController = new TextEditingController();
  final TextEditingController _reController = new TextEditingController();
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SDAppBar(
        title: Text(
          "Edit",
          style: TextStyle(
            color: Colors.amber.shade200,
            fontSize: 35,
          ),
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     MaterialIcons.getIconData("arrow-back"),
        //     color: Colors.amber.shade200,
        //   ),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _fbKey,
          child: Column(
            children: <Widget>[
              Container(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    Text("    Enter current password:    "),
                    Container(
                      width: MediaQuery.of(context).size.width - 250,
                      child: FormBuilderTextField(
                        controller: _originalController,
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(6),
                        ],
                        attribute: "pass1",
                        obscureText: obscure,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Tap here to add...",
                          suffixIcon: IconButton(
                            icon: Icon(FontAwesomeIcons.eyeSlash),
                            onPressed: () {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    Text("    Enter new password:    "),
                    Container(
                      width: MediaQuery.of(context).size.width - 250,
                      child: FormBuilderTextField(
                        obscureText: obscure,
                        controller: _editingController,
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(6),
                        ],
                        attribute: "pass2",
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Tap here to add...",
                          suffixIcon: IconButton(
                            icon: Icon(FontAwesomeIcons.eyeSlash),
                            onPressed: () {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    Text("    Enter new password again:    "),
                    Container(
                      width: MediaQuery.of(context).size.width - 250,
                      child: FormBuilderTextField(
                        obscureText: obscure,
                        controller: _reController,
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(6),
                        ],
                        attribute: "pass3",
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Tap here to add...",
                          suffixIcon: IconButton(
                            icon: Icon(FontAwesomeIcons.eyeSlash),
                            onPressed: () {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 30,
              ),
              FlatButton(
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      colors: [
                        Colors.amberAccent.shade100,
                        Colors.amber.shade600
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text("Continue"),
                  ),
                ),
                onPressed: () async {
                  _fbKey.currentState.save();
                  if (_fbKey.currentState.validate()) {
                    if (widget.value != _editingController.text.trim()) {
                      if (_editingController.text.trim() ==
                          _reController.text.trim()) {
                        if (_editingController.text.trim() !=
                            _originalController.text.trim()) {
                          await _controller.changePassword(
                            context: widget.context,
                            password: _editingController.text.trim(),
                          );
                          //TODO: SOLVE HERE
                          Flushbar(
                            animationDuration: Duration(milliseconds: 400),
                            backgroundColor: Colors.green,
                            flushbarStyle: FlushbarStyle.FLOATING,
                            flushbarPosition: FlushbarPosition.BOTTOM,
                            message: "Password edited...",
                            isDismissible: true,
                            duration: Duration(seconds: 5),
                          )..show(widget.context);
                          Navigator.pop(context);
                          Navigator.pop(this.context);
                        } else {
                          Flushbar(
                            animationDuration: Duration(milliseconds: 400),
                            backgroundColor: Colors.red,
                            flushbarStyle: FlushbarStyle.FLOATING,
                            flushbarPosition: FlushbarPosition.BOTTOM,
                            message: "Old password area and re-entered password area are same...",
                            isDismissible: true,
                            duration: Duration(seconds: 5),
                          )..show(context);
                        }
                      } else {
                        Flushbar(
                          animationDuration: Duration(milliseconds: 400),
                          backgroundColor: Colors.red,
                          flushbarStyle: FlushbarStyle.FLOATING,
                          flushbarPosition: FlushbarPosition.BOTTOM,
                          message:
                              "New and re-entered passwords does not match!",
                          isDismissible: true,
                          duration: Duration(seconds: 5),
                        )..show(context);
                      }
                    } else {
                      Flushbar(
                        animationDuration: Duration(milliseconds: 400),
                        backgroundColor: Colors.red,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        message: "Old password is not true!",
                        isDismissible: true,
                        duration: Duration(seconds: 5),
                      )..show(context);
                    }
                  } else {
                    print("Validation failed");
                  }
                },
              ),
              Container(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
