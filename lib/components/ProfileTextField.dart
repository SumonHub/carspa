import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PPTextField extends StatelessWidget {
  PPTextField(this._leadingIcon, this._string, this.trailingIcon);

  final Icon _leadingIcon;
  final String _string;
  final Icon trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.black12,
      // decoration: BoxDecoration(color: Colors.redAccent),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.black54))),
          child: _leadingIcon,
          // Icon(Icons.directions_car, color: Colors.white),
        ),
        title: Text(
          _string,
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        trailing: trailingIcon == null
            ? null
            : new GestureDetector(
          child: trailingIcon,
        ),
      ),
    );
  }
}
