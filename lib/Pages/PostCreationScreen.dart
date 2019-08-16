import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immigrate/Widgets/PostEditorButtons.dart';
import 'package:simple_design/simple_design.dart';

class PostCreationScreen extends StatefulWidget {
  PostCreationScreen({Key key}) : super(key: key);

  _PostCreationScreenState createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  TextEditingController _controller = new TextEditingController();
  FocusNode node = FocusNode();

  @override
  void initState() {
    node.addListener(() {
      if (!node.hasFocus) {
        print("Focus lost");
      } else {
        print("Focused to field");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SDAppBar(
        title: Text("Create a Post"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                focusNode: node,
                controller: _controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autofocus: true,
                cursorColor: Colors.red.shade500,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    FontAwesomeIcons.penFancy,
                    size: 35,
                    color: Colors.red.shade500,
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
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.all(16),
            ),
            PostEditorButtons(
              controller: _controller,
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
