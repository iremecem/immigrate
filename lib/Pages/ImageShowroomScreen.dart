import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_design/simple_design.dart';

class ImageShowroomScreen extends StatelessWidget {
  final File image;
  const ImageShowroomScreen({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SDAppBar(
        title: Text("Image View"),
      ),
      body: Image(
        image: FileImage(image),
        fit: BoxFit.contain,
      ),
    );
  }
}