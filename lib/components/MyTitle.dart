
import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget {
  String text;
  Color color;

  MyTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
    //  padding: EdgeInsets.only(right: 8.0),
      decoration: new BoxDecoration(
          border: new Border(
              bottom: new BorderSide(
                  width: 2.0, color: Colors.white24))),

      child: Row(
        children: <Widget>[
          Icon(Icons.label, color: Colors.white,),
          Text(
            '$text ',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}
