
import "package:flutter/material.dart";

class PageCollector extends StatefulWidget {
  @override
  _PageCollectorState createState() => _PageCollectorState();
}

class _PageCollectorState extends State<PageCollector> {
  PageController _pageController = new PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => AboutDialog(
                  applicationName: "Immigrate",
                  applicationVersion: "v 0.1",
                  children: <Widget>[
                    Center(
                      child: Text(
                          "Developed by Etam Software Ltd. in Turkey/Ankara"),
                    ),
                  ],
                ),
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: <Widget>[],
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        padding: EdgeInsets.all(4),
      ),
      drawer: Drawer(),
    );
  }
}
