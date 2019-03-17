import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PPTextField extends StatelessWidget {

  PPTextField(this._leadingIcon, this._string, this.trailingIcon);
  final Icon _leadingIcon;
  final String _string;

  final Icon trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.teal),
      child: Container(
        decoration: BoxDecoration(color: Colors.teal),
        child: ListTile(
           /* onTap: () {

            },*/

            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(
                          width: 1.0, color: Colors.white24))),
              child:_leadingIcon,
             // Icon(Icons.directions_car, color: Colors.white),

            ),
            title: Text(
              _string,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

            trailing: trailingIcon == null ? null : new GestureDetector(
              child: trailingIcon,
            ),
        ),
      ),
    );
  }
}
/*
*   // contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
        title: Text('$type',
          style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
             // fontWeight: FontWeight.bold
          ),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[
            Text('$value',
                style: TextStyle(color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins")
            )
          ],
        ),
      ),
* */