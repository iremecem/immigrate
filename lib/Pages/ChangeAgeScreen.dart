import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:simple_design/simple_design.dart';

class ChangeAgeScreen extends StatefulWidget {
  final String value;
  final BuildContext context;
  ChangeAgeScreen({@required this.value, @required this.context});
  @override
  _ChangeAgeScreenState createState() => _ChangeAgeScreenState();
}

class _ChangeAgeScreenState extends State<ChangeAgeScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final FirebaseController _controller = new FirebaseController();
  final TextEditingController _editingController = new TextEditingController();
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SDAppBar(
        title: Text(
          "Edit",
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
                    Text("  Enter Age:    "),
                    Container(
                      width: MediaQuery.of(context).size.width - 250,
                      child: FormBuilderTextField(
                        controller: _editingController,
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ],
                        attribute: "pass2",
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Tap here to add...",
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
                  child: Center(
                    child: Text("Continue"),
                  ),
                ),
                onPressed: () async {
                  _fbKey.currentState.save();
                  if (_fbKey.currentState.validate()) {
                    if (_editingController.text.trim().length != 0) {
                      _controller.setAge(
                        userID: user.id,
                        age: _editingController.text.trim(),
                      );
                      Flushbar(
                        animationDuration: Duration(milliseconds: 400),
                        backgroundColor: Colors.green,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        message: "Age edited...",
                        isDismissible: true,
                        duration: Duration(seconds: 5),
                      )..show(widget.context);
                      Navigator.pop(context);
                      Navigator.pop(this.context);
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
