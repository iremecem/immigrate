import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:immigrate/Controllers/FirebaseController.dart';
import 'package:immigrate/Controllers/Globals.dart';
import 'package:immigrate/Pages/LoginPage.dart';
import 'package:immigrate/Pages/NoNetPage.dart';
import 'package:immigrate/Pages/PageCollector.dart';
import 'package:immigrate/Pages/SetupPage.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

final ThemeData theme = ThemeData(
  splashColor: Colors.greenAccent.withOpacity(0.15),
  textTheme: TextTheme(
    title: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
    body1: TextStyle(fontSize: 16.0),
    body2: TextStyle(fontSize: 16.0, color: Colors.grey[800]),
    button: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
    caption: TextStyle(
      fontSize: 16.0,
      color: Colors.black.withOpacity(0.5),
    ),
  ),
  accentColor: Colors.lightGreen,
  accentColorBrightness: Brightness.dark,
  backgroundColor: Colors.grey[200],
  bottomAppBarColor: Colors.white,
  brightness: Brightness.light,
  buttonColor: Colors.lightGreen,
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    buttonColor: Colors.lightGreen,
    alignedDropdown: true,
    disabledColor: Colors.grey[400],
    height: 44.0,
    highlightColor: Colors.transparent,
    layoutBehavior: ButtonBarLayoutBehavior.constrained,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.0),
      side: BorderSide(style: BorderStyle.none),
    ),
  ),
  highlightColor: Colors.transparent,
  disabledColor: Colors.grey[400],
  canvasColor: Colors.white,
  cardColor: Colors.white,
  cursorColor: Colors.lightGreen,
  dialogBackgroundColor: Colors.white,
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.0),
      side: BorderSide(style: BorderStyle.none),
    ),
  ),
  dividerColor: Colors.transparent,
  errorColor: Colors.red[400],
  inputDecorationTheme: InputDecorationTheme(
    border: UnderlineInputBorder(),
    contentPadding: EdgeInsets.all(8.0),
    hasFloatingPlaceholder: false,
    errorMaxLines: 1,
    filled: false,
  ),
  indicatorColor: Colors.lightGreen,
  primaryColor: Colors.lightGreen,
  primaryColorBrightness: Brightness.light,
  primaryColorDark: Colors.lightGreen[400],
  primaryColorLight: Colors.lightGreen[100],
  scaffoldBackgroundColor: Colors.white,
  selectedRowColor: Colors.grey[200],
  sliderTheme: SliderThemeData(
    activeTrackColor: Colors.lightGreen,
    inactiveTrackColor: Colors.grey[400],
    disabledActiveTrackColor: Colors.grey[400],
    disabledInactiveTrackColor: Colors.grey[300],
    activeTickMarkColor: Colors.lightGreen,
    inactiveTickMarkColor: Colors.grey,
    disabledActiveTickMarkColor: Colors.grey[400],
    disabledInactiveTickMarkColor: Colors.grey[400],
    thumbColor: Colors.lightGreen,
    disabledThumbColor: Colors.grey[400],
    overlayColor: Colors.lightGreen.withOpacity(0.3),
    valueIndicatorColor: Colors.lightGreen,
    thumbShape: RoundSliderThumbShape(),
    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
    showValueIndicator: ShowValueIndicator.onlyForDiscrete,
    valueIndicatorTextStyle:
        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
  ),
  fontFamily: "HK Grotesk",
  splashFactory: InkRipple.splashFactory,
  tabBarTheme: TabBarTheme(
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.lightGreen, width: 2.0, style: BorderStyle.solid),
        ),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment(0.0, 0.8),
          colors: [
            Colors.lightGreen.withOpacity(0.5),
            Colors.lightGreen.withOpacity(0.0)
          ],
        ),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Colors.lightGreen,
      unselectedLabelColor: Colors.grey),
  textSelectionColor: Colors.lightGreen.withOpacity(0.5),
  textSelectionHandleColor: Colors.lightGreen,
  toggleableActiveColor: Colors.lightGreen,
  unselectedWidgetColor: Colors.grey[600],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  FirebaseController _controller = FirebaseController();
  String userId = _prefs.getString("id");
  String userName = _prefs.getString("name");
  String to = _prefs.getString("to");
  String from = _prefs.getString("from");
  String profilePic = _prefs.getString("profilePic");
  user.id = userId;
  user.name = userName;
  user.to = to;
  user.from = from;
  user.profilePic = profilePic
  ;

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
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        seconds: 1,
        image: Image(
          image: AssetImage("assets/images/dummy-imm.png"),
        ),
        loaderColor: Colors.lightGreen,
        photoSize: 100,
        loadingText: Text("Welcome Back, Countryman!"),
        navigateAfterSeconds: OfflineBuilder(
          child: Container(),
          connectivityBuilder: (context, connectivity, child) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (connected) {
              return _selectScreen(
                userId: user.id,
                to: user.to,
              );
            } else {
              return NoNetPage();
            }
          },
        ),
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
