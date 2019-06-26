import 'dart:convert';

import 'package:carspa/api/ApiConstant.dart';
import 'package:carspa/api/ApiHelperClass.dart';
import 'package:carspa/components/Avatar.dart';
import 'package:carspa/drawer/LoginTab.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  final String _pageTitle;

  Profile(this._pageTitle);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool activeName = false;
  bool activeEmail = false;
  bool activePhone = false;
  bool activeAddress = false;
  bool activePassword = false;
  bool _isLogin = false;
  bool _isLoading = true;
  var _id, _name, _email, _phone, _address, _password;

  Future _loadUserInfo() async {
    var _token = await UserStringPref.getPref('token');
    if (_token == 0) {
     setState(() {
       _isLogin = false;
     });
    } else {
     setState(() {
       _isLogin = true;
     });

      final response = await http.get(
        ApiConstant.USER,
        headers: {"Authorization": "Bearer $_token "},
      );
      final responseJson = json.decode(response.body);
      print('user profile : ${responseJson['success']}');
      var user = new UserProfile.fromJson(responseJson['success']);
      if (user != null) {
        setState(() {
          _id = '${user.id}';
          _name = '${user.first_name} ${user.last_name}';
          _email = user.email;
          _phone = user.phone;
          _address = user.address;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text(widget._pageTitle),
      ),
      bottomNavigationBar: _isLogin
          ? new Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 12.0, top: 12.0),
              child: MaterialButton(
                child: new Text(
                  AppTranslations.of(context).text("save_change"),
                  style: const TextStyle(
                    color: Colors.black,
                    letterSpacing: 5.0,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {},
                elevation: 4.0,
                minWidth: double.infinity,
                height: 48.0,
                color: Colors.white,
              ),
            )
          : null,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : _isLogin
              ? new ListView(
                  padding: EdgeInsets.all(20.0),
                  children: <Widget>[
                    Avatar('assets/photos/profile.png'),
                    new ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child:
                          Icon(Icons.account_circle, color: Colors.white),
                          // Icon(Icons.directions_car, color: Colors.white),
                        ),
                        title: TextField(
                          onSubmitted: (value) {
                            setState(() {
                              activeName = false;
                            });
                          },
                          style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorColor: Colors.yellowAccent,
                          enabled: activeName,
                          decoration: InputDecoration(
                            hintText: _name,
                            hintStyle: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            helperText:
                            AppTranslations.of(context).text("name"),
                            helperStyle: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                )),
                          ),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                activeName == true
                                    ? activeName = false
                                    : activeName = true;
                              });
                            })),
                    new ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: Icon(Icons.email, color: Colors.white),
                          // Icon(Icons.directions_car, color: Colors.white),
                        ),
                        title: TextField(
                          onSubmitted: (value) {
                            setState(() {
                              activeEmail = false;
                            });
                          },
                          style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorColor: Colors.yellowAccent,
                          enabled: activeEmail,
                          decoration: InputDecoration(
                            hintText: _email,
                            hintStyle: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            helperText:
                            AppTranslations.of(context).text("email"),
                            helperStyle: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                )),
                          ),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                activeEmail == true
                                    ? activeEmail = false
                                    : activeEmail = true;
                              });
                            })),
                    new ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: Icon(Icons.phone, color: Colors.white),
                          // Icon(Icons.directions_car, color: Colors.white),
                        ),
                        title: TextField(
                          onSubmitted: (value) {
                            setState(() {
                              activePhone = false;
                            });
                          },
                          style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorColor: Colors.yellowAccent,
                          enabled: activePhone,
                          decoration: InputDecoration(
                            hintText: _phone,
                            hintStyle: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            helperText:
                            AppTranslations.of(context).text("phone"),
                            helperStyle: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                )),
                          ),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                activePhone == true
                                    ? activePhone = false
                                    : activePhone = true;
                              });
                            })),
                    new ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: Icon(Icons.add_location, color: Colors.white),
                          // Icon(Icons.directions_car, color: Colors.white),
                        ),
                        title: TextField(
                          onSubmitted: (value) {
                            setState(() {
                              activeAddress = false;
                            });
                          },
                          style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorColor: Colors.yellowAccent,
                          enabled: activeAddress,
                          decoration: InputDecoration(
                            hintText: _address,
                            hintStyle: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            helperText:
                            AppTranslations.of(context).text("address"),
                            helperStyle: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                )),
                          ),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                activeAddress == true
                                    ? activeAddress = false
                                    : activeAddress = true;
                              });
                            })),
                    new ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: Icon(Icons.lock, color: Colors.white),
                          // Icon(Icons.directions_car, color: Colors.white),
                        ),
                        title: TextField(
                          // autofocus: true,
                          onSubmitted: (value) {
                            setState(() {
                              activePassword = false;
                            });
                          },
                          style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorColor: Colors.yellowAccent,
                          enabled: activePassword,
                          decoration: InputDecoration(
                            hintText: _password,
                            hintStyle: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            helperText:
                            AppTranslations.of(context).text("password"),
                            helperStyle: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                )),
                          ),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                activePassword == true
                                    ? activePassword = false
                                    : activePassword = true;
                              });
                            })),
                  ],
                )
              : Center(
                  child: MaterialButton(
                    color: Colors.white,
                    onPressed: () {
                      _getLoginFeed(context);
                    },
                    child: Text(
                      AppTranslations.of(context).text("login_note"),
                      style: const TextStyle(
                        color: Colors.black,
                        letterSpacing: 5.0,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
    );
  }

  void _getLoginFeed(BuildContext context) async {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (_) => new LoginTab()),)
        .then((value) => value ? _loadUserInfo() : null);
  }
}
