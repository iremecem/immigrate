import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NoNetPage extends StatelessWidget {
  const NoNetPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Icon(FontAwesomeIcons.wifi),
            Padding(
              padding: EdgeInsets.all(64),
              child: Text(
                "No internet connection found, please connect to a source and try again...",
                style: TextStyle(
                  color: Colors.lightGreen,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
