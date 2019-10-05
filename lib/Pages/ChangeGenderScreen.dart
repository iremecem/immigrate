import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gender_selector/gender_selector.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:simple_design/simple_design.dart';

class ChangeGenderScreen extends StatefulWidget {
  final String value;
  final BuildContext context;
  ChangeGenderScreen({@required this.value, @required this.context});
  @override
  _ChangeGenderScreenState createState() => _ChangeGenderScreenState();
}

class _ChangeGenderScreenState extends State<ChangeGenderScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final FirebaseController _controller = new FirebaseController();
  Gender _gender = Gender.MALE;
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
                child: GenderSelector(
                  selectedGender: _gender,
                  onChanged: (gender) {
                    setState(() {
                      _gender = gender;
                    });
                  },
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
                  String gender = "";
                  switch (_gender.index) {
                    case 0:
                      gender = "Male";
                      break;
                    case 1:
                      gender = "Female";
                      break;
                    case 2:
                      gender = "None";
                      break;
                  }
                  await _controller.setGender(
                    userID: user.id,
                    gender: gender,
                  );
                  Navigator.pop(context);
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
