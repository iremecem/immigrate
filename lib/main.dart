import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Pages/LoginPage.dart';
import 'package:immigrate/Pages/PageCollector.dart';
import 'package:immigrate/Pages/SetupPage.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_design/simple_design.dart';

final ThemeData theme = SimpleDesign.lightTheme;

void main() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  FirebaseController _controller = FirebaseController();
  String userId = _prefs.getString("id");
  String userName = _prefs.getString("name");
  String to = _prefs.getString("to");
  String profilePic = _prefs.getString("profilePic");
  user.id = userId;
  user.name = userName;
  user.to = to;
  user.profilePic = profilePic;

  var location = new Location();

  if (userId != null) {
    try {
      var currentLocation = await location.getLocation();
      user.lat = currentLocation.latitude;
      user.lon = currentLocation.longitude;
      await _controller.setUserLocation(
        userId: user.id,
        long: user.lon,
        lat: user.lat,
      );
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  Widget _selectScreen({String userId, String to}) {
    if (userId == null) {
      return LoginPage();
    }
    if (userId != null && to == null) {
      return SetupPage();
    }
    if (userId != null && to != null) {
      return PageCollector();
    }
    return LoginPage();
  }

  runApp(
    MaterialApp(
      home: _selectScreen(
        userId: user.id,
        to: user.to,
      ),
      theme: theme,
    ),
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: theme.backgroundColor.withOpacity(0.2),
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarDividerColor:
          theme.brightness == Brightness.light ? Colors.black : Colors.white,
      systemNavigationBarIconBrightness: theme.brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    ),
  );
}
