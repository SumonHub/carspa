import 'package:carspa/components/Avatar.dart';
import 'package:carspa/components/MyToast.dart';
import 'package:carspa/components/loginInput.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

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

  String loadingMsg;
  String loadingExtMsg;
  String _emptyMsg;
  String guest_login_warning_msg;
  String error_msg;

  String user_token;

  @override
  Widget build(BuildContext context) {
    _emptyMsg = AppTranslations.of(context).text("empty_msg");
    guest_login_warning_msg =
        AppTranslations.of(context).text("guest_login_warning_msg");
    error_msg = AppTranslations.of(context).text("error_msg");
    loadingMsg = AppTranslations.of(context).text("loading");
    loadingExtMsg = AppTranslations.of(context).text("loading_ext");

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
                AppTranslations.of(context).text("login_as_guest"),
                style: const TextStyle(
                  color: Colors.black,
                  letterSpacing: 5.0,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                bool status = checkValidity();
                if (status) {
                  new MyToast(
                      context,
                      '$loadingMsg',
                      '$loadingExtMsg',
                      Duration(seconds: 2),
                      Color(0xff004d40),
                      FlushbarPosition.TOP,
                      true)
                      .showToast();
                  _login(_fstNameController.text, _lstNameController.text,
                      _phoneController.text);
                  new Future.delayed(Duration(seconds: 2), () {
                    Navigator.pop(context, true);
                    new MyToast(
                        context,
                        '',
                        '$guest_login_warning_msg',
                        Duration(seconds: 2),
                        Color(0xff004d40),
                        FlushbarPosition.TOP,
                        false)
                        .showToast();
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

  void _showToast(String msg) {}

  _login(String fstName, String lstName, String phoneNo) async {
    UserStringPref.saveBoolPref('isLogin', false);
    UserStringPref.saveBoolPref('isGuestLogin', true);
    UserStringPref.savePref('token', null);
    UserStringPref.savePref('user_fstName', fstName);
    UserStringPref.savePref('user_lstName', lstName);
    UserStringPref.savePref('user_phone', phoneNo);
  }

  bool checkValidity() {
    bool status = true;
    if (_fstNameController.text.isEmpty) {
      status = false;
      setState(() {
        _fstNameErrorText = _emptyMsg;
      });
    }
    if (_lstNameController.text.isEmpty) {
      status = false;
      setState(() {
        _lstNameErrorText = _emptyMsg;
      });
    }
    if (_phoneController.text.isEmpty) {
      status = false;
      setState(() {
        _phoneErrorText = _emptyMsg;
      });
    }
    return status;
  }
}
