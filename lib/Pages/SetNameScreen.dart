import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:simple_design/simple_design.dart';

class SetNameScreen extends StatefulWidget {
  final String value;
  SetNameScreen({@required this.value});
  @override
  _SetNameScreenState createState() => _SetNameScreenState();
}

class _SetNameScreenState extends State<SetNameScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final FirebaseController _controller = new FirebaseController();
  final TextEditingController _editingController = new TextEditingController();
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
      body: FormBuilder(
        child: Column(
          children: <Widget>[
            Container(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("    Current Name:"),
                  Text("${widget.value}    "),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              child: FormBuilder(
                child: Row(
                  children: <Widget>[
                    Text("    New Name:    "),
                    Container(
                      width: MediaQuery.of(context).size.width - 200,
                      child: FormBuilderTextField(
                        controller: _editingController,
                        validators: [FormBuilderValidators.required()],
                        attribute: "name",
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "${widget.value}",
                        ),
                      ),
                    ),
                  ],
                ),
                key: _fbKey,
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
                  _controller.changeUserName(
                    newName: _editingController.text.trim(),
                  );
                  Navigator.pop(context);
                  Flushbar(
                    animationDuration: Duration(milliseconds: 400),
                    backgroundColor: Colors.green,
                    flushbarStyle: FlushbarStyle.FLOATING,
                    flushbarPosition: FlushbarPosition.BOTTOM,
                    message: "Name edited...",
                    isDismissible: true,
                    duration: Duration(seconds: 5),
                  )..show(context);
                }else{
                  print("Validation failed");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
