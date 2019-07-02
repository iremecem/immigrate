import 'package:flutter/material.dart';

class PageCollector extends StatefulWidget {
  @override
  _PageCollectorState createState() => _PageCollectorState();
}

class _PageCollectorState extends State<PageCollector> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, scrolled) {
        return [
          SliverAppBar(
            title: Text("Immigrate"),
            centerTitle: true,
            backgroundColor: Colors.lightGreen,
            floating: false,
            pinned: true,
            snap: false,
            expandedHeight: MediaQuery.of(context).size.height / 2,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //TODO:Weather will be here
                    ],
                  ),
                ],
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: DecoratedBox(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/dummy-imm.png"),
                )),
              ),
              centerTitle: true,
            ),
          )
        ];
      },
      body: GridView.extent(
        children: <Widget>[
          //TODO: ADD CARDS HERE
        ],
        maxCrossAxisExtent: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
    );
  }
}
