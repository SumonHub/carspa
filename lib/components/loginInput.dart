import 'package:flutter/material.dart';

class LoginInput extends StatelessWidget {
/*
   TextEditingController myController = TextEditingController();
   String hintText;
   String labelText;

   LoginInput(this.hintText, this.myController);*/

  final TextEditingController myController;
  final String prefixText;
  final int maxLength;
  final String hintText;
  final String labelText;
  final String errorText;
  final bool obscureText;

  const LoginInput(
      {Key key,
        this.prefixText,
        this.maxLength,
      this.hintText,
      this.labelText,
      this.myController,
      this.errorText,
      this.obscureText: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(

      padding: const EdgeInsets.symmetric(vertical: 10.0),
      // color: Colors.white,
      child: new TextField(
        maxLength: maxLength,
        obscureText: obscureText,
        controller: myController,
        decoration: new InputDecoration(
          prefixText: prefixText,
          hintText: hintText,
          labelText: labelText,
          fillColor: Colors.grey,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
            borderSide: new BorderSide(),
          ),
          errorText: errorText,
          hintStyle: new TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          labelStyle: new TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey, width: 2.5)),
        ),
        // keyboardType: TextInputType.emailAddress,
        style: new TextStyle(
          color: Colors.black,
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}
