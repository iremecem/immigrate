import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:simple_design/simple_design.dart';

class ChangeLivingScreen extends StatefulWidget {
  final String value;
  final String absoulteValue;
  final BuildContext context;
  ChangeLivingScreen({Key key, this.value, this.context, this.absoulteValue}) : super(key: key);

  _ChangeLivingScreenState createState() => _ChangeLivingScreenState();
}

class _ChangeLivingScreenState extends State<ChangeLivingScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  var dropDownValue;
  @override
  void initState() {
    dropDownValue = widget.value;
    super.initState();
  }

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
                  Text("    Current Country:"),
                  Text("${widget.absoulteValue}    "),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              child: FormBuilder(
                child: DropdownButtonHideUnderline(
                  child: FormBuilderDropdown(
                    attribute: "from",
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "🇹🇷 Turkey",
                          style: TextStyle(color: Colors.lightGreen),
                        ),
                        value: "tr",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "🇬🇧 United Kingdom",
                          style: TextStyle(color: Colors.lightGreen),
                        ),
                        value: "gb",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "🇫🇷 France",
                          style: TextStyle(color: Colors.lightGreen),
                        ),
                        value: "fr",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "🇮🇹 Italy",
                          style: TextStyle(color: Colors.lightGreen),
                        ),
                        value: "it",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "🇩🇪 Germany",
                          style: TextStyle(color: Colors.lightGreen),
                        ),
                        value: "de",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "🇷🇺 Russia",
                          style: TextStyle(color: Colors.lightGreen),
                        ),
                        value: "rs",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "🇺🇸 United States",
                          style: TextStyle(color: Colors.lightGreen),
                        ),
                        value: "us",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "🇦🇪 United Arab Emirates",
                          style: TextStyle(color: Colors.lightGreen),
                        ),
                        value: "ae",
                      )
                    ],
                    initialValue: dropDownValue,
                    onChanged: (value) {
                      setState(() {
                        dropDownValue = value;
                      });
                    },
                    elevation: 10,
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                    iconSize: 40,
                  ),
                ),
                key: _fbKey,
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
                  
                  Navigator.pop(context);
                  Flushbar(
                    animationDuration: Duration(milliseconds: 400),
                    backgroundColor: Colors.green,
                    flushbarStyle: FlushbarStyle.FLOATING,
                    flushbarPosition: FlushbarPosition.BOTTOM,
                    message: "Country edited...",
                    isDismissible: true,
                    duration: Duration(seconds: 5),
                  )..show(context);
                } else {
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
