import 'package:flutter/material.dart';

class LoginInput extends StatelessWidget {
/*
   TextEditingController myController = TextEditingController();
   String hintText;
   String labelText;

   LoginInput(this.hintText, this.myController);*/

  final TextEditingController myController;
  final String hintText;
  final String labelText;
  final String errorText;
  final bool obscureText;

  const LoginInput(
      {Key key,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10.0),
      // color: Colors.white,
      child: new TextField(
        obscureText: obscureText,
        controller: myController,
        decoration: new InputDecoration(
          hintText: hintText,
          labelText: labelText,
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
            borderSide: new BorderSide(),
          ),
          errorText: errorText,
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

/*
 * new TextFormField(
       autovalidate: true,
       decoration: InputDecoration(
         //  border: const UnderlineInputBorder(),
         filled: true,
         hintText: "$hintText",
         labelText: "Username",
         //  helperText: "",
         fillColor: Colors.white,
       ),
     );


     */
