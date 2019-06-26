import 'package:flutter/material.dart';

void main() => runApp(ImmigrateApp());

class ImmigrateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Immigrate',
      home: ImmigratePage(),
    );
  }
}

class ImmigratePage extends StatefulWidget {
  ImmigratePage();
  @override
  _ImmigratePageState createState() => _ImmigratePageState();
}

class _ImmigratePageState extends State<ImmigratePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
