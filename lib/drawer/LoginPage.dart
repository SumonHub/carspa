import 'dart:async';
import 'dart:convert';

import 'package:carspa/api/ApiConstant.dart';
import 'package:carspa/api/ApiHelperClass.dart';
import 'package:carspa/components/Avatar.dart';
import 'package:carspa/components/loginInput.dart';
import 'package:carspa/drawer/SignupPage.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var user_token;

  String _emailErrorText = null;
  String _passwordErrorText = null;

  String _emptyMsg;
  String login_success_msg;
  String error_msg;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _emptyMsg = AppTranslations.of(context).text("empty_msg");
    login_success_msg = AppTranslations.of(context).text("login_success_msg");
    error_msg = AppTranslations.of(context).text("error_msg");

    return Scaffold(
        backgroundColor: Colors.teal,
       // appBar: new AppBar(title: new Text(AppTranslations.of(context).text("login"))),
        body: new ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            new Avatar('assets/photos/profile.png'),
            new LoginInput(
              labelText: AppTranslations.of(context).text("email"),
              hintText: AppTranslations.of(context).text("enter_email"),
              myController: emailController,
              errorText: _emailErrorText,
            ),
            new LoginInput(
              labelText: AppTranslations.of(context).text("password"),
              hintText: AppTranslations.of(context).text("enter_pass"),
              myController: passwordController,
              errorText: _passwordErrorText,
              obscureText: true,
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
                  if (emailController.text.isEmpty) {
                    setState(() {
                      _emailErrorText = _emptyMsg;
                    });
                  }
                  ;
                  if (passwordController.text.isEmpty) {
                    setState(() {
                      _passwordErrorText = _emptyMsg;
                    });
                  }
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    _showToast(' Loading... ');
                    _login(emailController.text, passwordController.text)
                        .then((bool success) {
                      if (success) {
                        _loadingUserInfo().then((_) {
                          _showToast(' $login_success_msg ');
                          Navigator.pop(context, true);

                        });
                      } else {
                        _showToast(' $error_msg ');
                      }
                    });
                  }

                  //     _loadUserInfo();

                  /*  _loadingUserInfo(await _login(
                      nameController.text, passwordController.text)).then((_){
                        print('-------login success------------');
                    Navigator.pop(context, true);
                  });*/
                },
                elevation: 4.0,
                minWidth: double.infinity,
                height: 48.0,
                color: Colors.white,
              ),
            ),
            // new Text("forgot password"),
            new Center(
              child: new Text(
                "_____________OR_____________",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ),
            new Container(
              margin: EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                child: new Text(
                  AppTranslations.of(context).text("sign_to_carspa"),
                  style: const TextStyle(
                    color: Colors.black,
                    letterSpacing: 5.0,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupPage()));
                },
                elevation: 4.0,
                minWidth: double.infinity,
                height: 48.0,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }

  Future<bool> _login(String user_email, String user_password) async {
    var _loginUrl = ApiConstant.LOGIN_API;
    var _bodyData = {
      "email": "$user_email",
      'password': "$user_password",
    };
    /*var _bodyData = {
      "email": "admin@123.com",
      'password': "123456",
    };*/
    var response = await http.post(_loginUrl, body: _bodyData);
    var responseBody = jsonDecode(response.body);

    if (responseBody['success'] != null && response.statusCode == 200) {
      print('---------------> _login() call <--------------');
      setState(() {
        user_token = responseBody['success']['token'];
      });
      // user_token = responseBody['success']['token'];
      UserStringPref.savePref('token', user_token);
      UserStringPref.saveBoolPref('isLogin', true);
      UserStringPref.saveBoolPref('isGuestLogin', false);
      return true;
    } else {
      print('login_error : ${responseBody['error']}');
      return false;
    }
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

  Future _loadingUserInfo() async {

      // var _token = await UserPref.getPref('token');
      final response = await http.get(
        ApiConstant.USER,
        headers: {"Authorization": "Bearer $user_token "},
      );
      final responseJson = json.decode(response.body);
      print('user profile : ${responseJson['success']}');
      var user = new UserProfile.fromJson(responseJson['success']);
      if (user != null) {
        UserStringPref.savePref('user_id', '${user.id.toString()}');
        UserStringPref.savePref('user_fstName', '${user.first_name}');
        UserStringPref.savePref('user_lstName', '${user.last_name}');
        UserStringPref.savePref('user_email', '${user.email}');
        UserStringPref.savePref('user_phone', '${user.phone.toString()}');
      }

  }
}
