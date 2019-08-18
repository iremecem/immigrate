import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:simple_design/simple_design.dart';

class SetEmailScreen extends StatefulWidget {
  final String value;
  final BuildContext context;
  SetEmailScreen({@required this.value, @required this.context});
  @override
  _SetEmailScreenState createState() => _SetEmailScreenState();
}

class _SetEmailScreenState extends State<SetEmailScreen> {
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
      body: Column(
        children: <Widget>[
          FormBuilder(
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
                      Text("    Current E-Mail:"),
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
                        Text("    New E-Mail:    "),
                        Container(
                          width: MediaQuery.of(context).size.width - 200,
                          child: FormBuilderTextField(
                            controller: _editingController,
                            validators: [
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                            ],
                            attribute: "mail",
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
                      await _controller.changeUserMail(
                        context: widget.context,
                        newMail: _editingController.text.trim(),
                      );
                      Flushbar(
                        animationDuration: Duration(milliseconds: 400),
                        backgroundColor: Colors.green,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        message: "E-mail edited...",
                        isDismissible: true,
                        duration: Duration(seconds: 5),
                      )..show(context);
                      Navigator.pop(this.context);
                      Navigator.pop(context);
                    } else {
                      print("Validation failed");
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
