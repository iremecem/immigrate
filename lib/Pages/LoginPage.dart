import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _nameController = new TextEditingController();
  int selectedRegion = 0;
  var flagList = [
    DropdownMenuItem(
      child: Text("🇹🇷 Turkey"),
    ),
    DropdownMenuItem(
      child: Text("🇬🇧 United Kingdom"),
    ),
    DropdownMenuItem(
      child: Text("🇫🇷 France"),
    ),
    DropdownMenuItem(
      child: Text("🇮🇹 Italy"),
    ),
    DropdownMenuItem(
      child: Text("🇩🇪 Germany"),
    ),
    DropdownMenuItem(
      child: Text("🇷🇺 Russia"),
    ),
    DropdownMenuItem(
      child: Text("🇺🇸 United States"),
    ),
    DropdownMenuItem(
      child: Text("🇦🇪 United Arab Emirties"),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text("Would you like to tell us your name?"),
                  ),
                  TextField(
                    controller: _nameController,
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Center(
                    child:
                        Text("Would you like to tell us where are you from?"),
                  ),
                  DropdownButton(
                    value: selectedRegion,
                    items: flagList,
                    onChanged: (value){
                      selectedRegion = value;
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
