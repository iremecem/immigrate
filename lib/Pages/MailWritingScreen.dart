import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_design/simple_design.dart';

class MailWritingScreen extends StatefulWidget {
  @override
  _MailWritingScreenState createState() => _MailWritingScreenState();
}

class _MailWritingScreenState extends State<MailWritingScreen> {
  TextEditingController _bodycontroller = new TextEditingController();
  TextEditingController _subjcontroller = new TextEditingController();

  @override
  void dispose() {
    _bodycontroller.dispose();
    _subjcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SDAppBar(
        title: Text(
          "Send Us",
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     MaterialIcons.getIconData("arrow-back"),
        //     color: Colors.amber.shade200,
        //   ),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.paperPlane,
              color: Colors.lightGreen,
            ),
            onPressed: () async {
              if (_bodycontroller.text.trim().length != 0) {
                try {
                  await FlutterMailer.send(new MailOptions(
                    subject: _subjcontroller.text,
                    body: _bodycontroller.text,
                    recipients: [
                      "applicationcountryman@gmail.com",
                    ],
                  )).then((onValue) {
                    Navigator.pop(context);
                  });
                } on PlatformException catch (exc) {
                  Flushbar(
                    animationDuration: Duration(milliseconds: 400),
                    backgroundColor: Colors.red,
                    flushbarStyle: FlushbarStyle.FLOATING,
                    flushbarPosition: FlushbarPosition.BOTTOM,
                    message: "Can not send the mail, error code: ${exc.code}",
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
                  message: "You can not send us an empty email :D",
                  isDismissible: true,
                  duration: Duration(seconds: 5),
                )..show(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: _subjcontroller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autofocus: true,
                cursorColor: Colors.amber.shade500,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    FontAwesomeIcons.hashtag,
                    size: 35,
                    color: Colors.lightGreen,
                  ),
                  hoverColor: Colors.green.shade200,
                  hintText: "Subject",
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                enableInteractiveSelection: true,
                textCapitalization: TextCapitalization.sentences,
              ),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: _bodycontroller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autofocus: true,
                cursorColor: Colors.amber.shade500,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    FontAwesomeIcons.penFancy,
                    size: 35,
                    color: Colors.lightGreen,
                  ),
                  hoverColor: Colors.green.shade200,
                  hintText: "Start writing...",
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                enableInteractiveSelection: true,
                textCapitalization: TextCapitalization.sentences,
              ),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[50],
    );
  }
}
