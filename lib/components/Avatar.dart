import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String url;
  Avatar(this.url);

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
            margin: EdgeInsets.only(bottom: 12.0),
            // padding: EdgeInsets.all(16.0),
            width: 160.0,
            height: 160.0,
            decoration: new BoxDecoration(
                color: Colors.white54,
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.scaleDown,
                  image: new AssetImage(url),
                ))),
        /*new Text("John Doe",
                textScaleFactor: 1.5)*/
      ],
    ));
  }
}
