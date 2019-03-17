import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_x/api/ApiConstant.dart';
import 'package:flutter_app_x/components/Avatar.dart';
import 'package:flutter_app_x/components/loginInput.dart';
import 'package:flutter_app_x/localization/AppTranslations.dart';
import 'package:flutter_app_x/pref/UserPref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class GuestLogin extends StatefulWidget {
  @override
  _GuestLoginState createState() => _GuestLoginState();
}

class _GuestLoginState extends State<GuestLogin> {
  TextEditingController _fstNameController = TextEditingController();
  TextEditingController _lstNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  String _fstNameErrorText = null;
  String _lstNameErrorText = null;
  String _phoneErrorText = null;
  String _emptyMsg;
  String guest_login_warning_msg;
  String error_msg;

  String user_token;

  @override
  Widget build(BuildContext context) {
    _emptyMsg = AppTranslations.of(context).text("empty_msg");
    guest_login_warning_msg = AppTranslations.of(context).text("guest_login_warning_msg");
    error_msg = AppTranslations.of(context).text("error_msg");

    return Scaffold(
      backgroundColor: Colors.teal,
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          new Avatar('assets/photos/profile.png'),
          new LoginInput(
            labelText: AppTranslations.of(context).text("fst_name"),
            hintText: AppTranslations.of(context).text("enter_fst_name"),
            myController: _fstNameController,
            errorText: _fstNameErrorText,
          ),
          new LoginInput(
            labelText: AppTranslations.of(context).text("lst_name"),
            hintText: AppTranslations.of(context).text("enter_lst_name"),
            myController: _lstNameController,
            errorText: _lstNameErrorText,
            obscureText: false,
          ),
          new LoginInput(
            labelText: AppTranslations.of(context).text("phone"),
            hintText: AppTranslations.of(context).text("enter_phone"),
            myController: _phoneController,
            errorText: _phoneErrorText,
            obscureText: false,
          ),
          new Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: MaterialButton(
              child: new Text(
                AppTranslations.of(context).text("login_to_carspa"),
                style: const TextStyle(
                  color: Colors.black,
                  letterSpacing: 5.0,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                if (_fstNameController.text.isEmpty) {
                  setState(() {
                    _fstNameErrorText = _emptyMsg;
                  });
                }
                if (_lstNameController.text.isEmpty) {
                  setState(() {
                    _lstNameErrorText = _emptyMsg;
                  });
                }
                if (_phoneController.text.isEmpty) {
                  setState(() {
                    _phoneErrorText = _emptyMsg;
                  });
                }
                if (_phoneController.text.isNotEmpty &&
                    _lstNameController.text.isNotEmpty &&
                    _phoneController.text.isNotEmpty) {
                  _showToast(' Loading... ');
                  _login(_fstNameController.text, _lstNameController.text,
                          _phoneController.text)
                      .then((_) {
                      _showToast(' $guest_login_warning_msg ');
                      Navigator.pop(context, true);
                  });
                }
              },
              elevation: 4.0,
              minWidth: double.infinity,
              height: 48.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _login(String fstName, String lstName, String phoneNo) async {
    UserPref.saveBool('isLogin', false);
    UserPref.saveBool('isGuestLogin', true);
    UserPref.savePref('token', null);
    UserPref.savePref('user_name', fstName);
    UserPref.savePref('user_email', lstName);
    UserPref.savePref('user_phone', phoneNo);
  }
}
