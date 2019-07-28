import 'dart:convert';

import 'package:carspa/api/ApiConstant.dart';
import 'package:carspa/components/Avatar.dart';
import 'package:carspa/components/MyToast.dart';
import 'package:carspa/components/loginInput.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController fstNameController = TextEditingController();
  TextEditingController lstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cnfEmailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController cnfPassController = TextEditingController();

  var _errorText;
  var _emailErrorText;
  var _passErrorText;

  String empty_msg;
  String sign_success_msg;
  String error_msg;
  String error;
  String email_error_msg;
  String pass_error_msg;

  @override
  void dispose() {
    fstNameController.dispose();
    lstNameController.dispose();
    emailController.dispose();
    cnfEmailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passController.dispose();
    cnfPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    empty_msg = AppTranslations.of(context).text("empty_msg");
    sign_success_msg = AppTranslations.of(context).text("sign_success_msg");
    error_msg = AppTranslations.of(context).text("error_msg");
    error = AppTranslations.of(context).text("error");
    email_error_msg = AppTranslations.of(context).text("email_error_msg");
    pass_error_msg = AppTranslations.of(context).text("pass_error_msg");

    return Scaffold(
        backgroundColor: Colors.teal,
        appBar: new AppBar(
            title: new Text(AppTranslations.of(context).text("signup"))),
        bottomNavigationBar: new Padding(
          padding:
              EdgeInsets.only(left: 20.0, right: 20.0, bottom: 12.0, top: 12.0),
          child: MaterialButton(
            child: new Text(
              AppTranslations.of(context).text("signup"),
              style: const TextStyle(
                color: Colors.black,
                letterSpacing: 5.0,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              print('------------onPressed()-------------');

              if (_valid()) {
                print('------------_valid()-------------');

                setState(() {});
                _userReg(
                        fstNameController.text,
                        lstNameController.text,
                        emailController.text,
                        cnfEmailController.text,
                        phoneController.text,
                        addressController.text,
                        passController.text,
                        cnfPassController.text)
                    .then((bool success) {
                  if (success) {
                    Navigator.pop(context);
                    new MyToast(
                        context,
                        'Conrgratulation!',
                        '$sign_success_msg',
                        Duration(seconds: 2),
                        Color(0xff004d40),
                        FlushbarPosition.TOP,
                        true)
                        .showToast();
                    // _showToast(' $sign_success_msg ');
                  } else {
                    /* new MyToast(context, 'Error', '$error_msg', Duration(seconds: 2), Color(0xffdd2c00), FlushbarPosition.TOP,
                        true).showToast();*/
                  }
                });
              }
            },
            elevation: 4.0,
            minWidth: double.infinity,
            height: 48.0,
            color: Colors.white,
          ),
        ),
        body: new ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            new Avatar('assets/photos/profile.png'),
            new LoginInput(
              labelText: AppTranslations.of(context).text("fst_name"),
              hintText: AppTranslations.of(context).text("enter_fst_name"),
              myController: fstNameController,
              errorText: _errorText,
            ),
            new LoginInput(
              labelText: AppTranslations.of(context).text("lst_name"),
              hintText: AppTranslations.of(context).text("enter_lst_name"),
              myController: lstNameController,
              errorText: _errorText,
            ),
            new LoginInput(
              labelText: AppTranslations.of(context).text("email"),
              hintText: AppTranslations.of(context).text("enter_email"),
              myController: emailController,
              errorText: _emailErrorText,
            ),
            new LoginInput(
              labelText: AppTranslations.of(context).text("cnf_email"),
              hintText: AppTranslations.of(context).text("enter_cnf_email"),
              myController: cnfEmailController,
              errorText: _emailErrorText,
            ),
            new LoginInput(
              labelText: AppTranslations.of(context).text("phone"),
              hintText: AppTranslations.of(context).text("enter_phone"),
              myController: phoneController,
              errorText: _errorText,
            ),
            new LoginInput(
              labelText: AppTranslations.of(context).text("address"),
              hintText: AppTranslations.of(context).text("enter_address"),
              myController: addressController,
              errorText: _errorText,
            ),
            new LoginInput(
              labelText: AppTranslations.of(context).text("password"),
              hintText: AppTranslations.of(context).text("enter_pass"),
              myController: passController,
              errorText: _passErrorText,
              obscureText: true,
            ),
            new LoginInput(
              labelText: AppTranslations.of(context).text("cnf_password"),
              hintText: AppTranslations.of(context).text("enter_cnf_pass"),
              myController: cnfPassController,
              errorText: _passErrorText,
              obscureText: true,
            ),
          ],
        ));
  }

  Future<bool> _userReg(
      String fstName,
      String lstName,
      String email,
      String cnfEmail,
      String phone,
      String address,
      String pass,
      String cnfPass) async {
    var _regUrl = ApiConstant.REG_API;
    debugPrint(_regUrl);

    // Create a FormData
    var _bodyData = {
      "first_name": "$fstName",
      "last_name": "$lstName",
      "email": "$email",
      "confirm_email": "$cnfEmail",
      "phone": "$phone",
      "address": "$address",
      "password": "$pass",
      "confirm_password": "$cnfPass"
    };

    print(_bodyData);
    var response = await http.post(_regUrl, body: _bodyData);
    var responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 && responseBody['success'] != null) {
      print(responseBody['success']);
      return true;
    } else {
      print(responseBody['error']);
      new MyToast(
          context,
          '$error',
          responseBody['error'].toString(),
          Duration(seconds: 2),
          Color(0xffdd2c00),
          FlushbarPosition.TOP,
          true)
          .showToast();

      return false;
    }
  }

  bool _valid() {
    if (fstNameController.text.isEmpty ||
        lstNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        cnfEmailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        passController.text.isEmpty ||
        cnfPassController.text.isEmpty) {
      setState(() {
        _errorText = empty_msg;
        _emailErrorText = empty_msg;
        _passErrorText = empty_msg;
      });
      return false;
    }
    if (!emailController.text.contains('@') ||
        emailController.text != cnfEmailController.text) {
      setState(() {
        _emailErrorText = email_error_msg;
        _errorText = null;
        _passErrorText = null;
      });
      return false;
    }
    if (passController.text.length < 6 ||
        passController.text != cnfPassController.text) {
      setState(() {
        _passErrorText = pass_error_msg;
        _errorText = null;
        _emailErrorText = null;
      });
      return false;
    }
    return true;
  }
}
