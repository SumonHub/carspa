// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_x/api/ApiConstant.dart';
import 'package:flutter_app_x/api/ApiHelperClass.dart';
import 'package:flutter_app_x/localization/AppTranslations.dart';
import 'package:flutter_app_x/pref/UserPref.dart';

import 'package:http/http.dart' as http;

// This demo is based on
// https://material.io/design/components/dialogs.html#full-screen-dialog

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class FullScreenDialog extends StatefulWidget {
  @override
  FullScreenDialogState createState() => FullScreenDialogState();
}

class FullScreenDialogState extends State<FullScreenDialog> {
  TextEditingController _addressNameController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _blockController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _avenueController = TextEditingController();
  TextEditingController _apartmentController = TextEditingController();
  TextEditingController _floorController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool _validStatus = true;

  var _AddressNameText = 'Enter Address Name';
  var _AreaNameText = 'Enter Area Name';
  var _streetText = 'Enter Street';
  var _blockText = 'Enter Block';
  var _buildingText = 'Enter Building No';
  var _avenueText = 'Enter Avenue No';
  var _apartmentText = 'Enter Apartment No';
  var _floorText = 'Enter Floor No';

  var _isLogin = true;
  List<SuggestedArea> _areaList = new List();
  List<String> _locations = ['A', 'B', 'C', 'D']; // Option 2
  SuggestedArea _selectedLocation;

  Future<bool> _onWillPop() async {
    bool _hasAddress = _addressNameController.text.isEmpty;
    bool _hasArea = _areaController.text.isEmpty;
    bool _hasStreet = _streetController.text.isEmpty;
    bool _hasBuilding = _buildingController.text.isEmpty;
    bool _hasBlock = _blockController.text.isEmpty;

    _hasAddress =
        _hasArea || _hasStreet || _hasAddress || _hasBuilding || _hasBlock;
    if (!_hasAddress) return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle =
        theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(AppTranslations.of(context).text("discard_warning"), style: dialogTextStyle),
              actions: <Widget>[
                FlatButton(
                    child: Text(AppTranslations.of(context).text("cancel")),
                    onPressed: () {
                      Navigator.of(context).pop(
                          false); // Pops the confirmation dialog but not the page.
                    }),
                FlatButton(
                    child: Text(AppTranslations.of(context).text("discard")),
                    onPressed: () {
                      Navigator.of(context).pop(
                          true); // Returning true to _onWillPop will pop again.
                    })
              ],
            );
          },
        ) ??
        false;
  }

  Future _getSuggestedArea() async {
    print('------------- GET_SUGGESTED_AREA() start ------------------');

    var _locale = await UserPref.getPref('lang_code');
    if (_locale == 0 || _locale == 'en') {
      _locale = "?locale=en";
    } else {
      _locale = '?locale=ar';
    }

    var url = ApiConstant.GET_SUGGESTED_AREA + _locale;
    print('GET_SUGGESTED_AREA api url : $url');
    var response = await http.get(url);
    List<SuggestedArea> _suggestedAreaList = new List();
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var data = jsonResponse['data'];

      for (var u in data) {
        SuggestedArea suggestedArea = new SuggestedArea(
            area_name: u['area_name'], checked_area_id: u['checked_area_id']);
        _suggestedAreaList.add(suggestedArea);
      }

      print('GET_SUGGESTED_AREA.length : ${_suggestedAreaList.length}');
    }

    setState(() {
      _areaList = _suggestedAreaList;
    });
  }

  @override
  void initState() {
    super.initState();
    _getSuggestedArea();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    var empty_error_msg = AppTranslations.of(context).text("empty_error_msg");

    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
          title: Text(AppTranslations.of(context).text("add_new_address")),
          actions: <Widget>[
            FlatButton(
                child: Text(AppTranslations.of(context).text("save"),
                    style: theme.textTheme.body1.copyWith(color: Colors.white)),
                onPressed: () {
                  if (_addressNameController.text.isEmpty ||
                      _selectedLocation == null ||
                      _streetController.text.isEmpty ||
                      _blockController.text.isEmpty ||
                      _buildingController.text.isEmpty ||
                      _avenueController.text.isEmpty ||
                      _apartmentController.text.isEmpty ||
                      _floorController.text.isEmpty ||
                      _phoneController.text.isEmpty) {
                    setState(() {
                      _validStatus = false;
                    });
                  } else {
                    _addAddress();
                  }
                })
          ]),
      body: Form(
          onWillPop: _onWillPop,
          child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
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
                    maxLines: 1,
                    controller: _addressNameController,
                    textInputAction: TextInputAction.done,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.yellowAccent,
                    decoration: InputDecoration(
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.none)),
                      hintText: '$_AddressNameText',
                      hintStyle: new TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText:
                          AppTranslations.of(context).text("address_name"),
                      helperStyle: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.yellowAccent, width: 2.5)),
                      errorText: _validStatus ? null : empty_error_msg,
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.yellowAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                      ),
                    ),
                  ),
                ),
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
                  title: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: DropdownButton(
                      elevation: 0,
                      isExpanded: true,
                      /*style: TextStyle(
                      color: Colors.white
                    ),*/
                      hint: Text(
                        AppTranslations.of(context).text("search_your_place"),
                        // 'Choose Your Area',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Not necessary for Option 1
                      value: _selectedLocation,
                      onChanged: (SuggestedArea newValue) {
                        print('=======${newValue.toString()}======');
                        setState(() {
                          _selectedLocation = newValue;
                        });
                      },
                      items: _areaList.map((SuggestedArea location) {
                        return DropdownMenuItem(
                          child: new Text(location.area_name),
                          value: location,
                        );
                      }).toList(),
                    ),
                  ),
                  subtitle: Container(
                    padding: EdgeInsets.all(9.0),
                    child: Text(
                      _validStatus
                          ? AppTranslations.of(context).text("area_name")
                          : empty_error_msg,
                      style: TextStyle(
                        color:
                            _validStatus ? Colors.white : Colors.yellowAccent,
                        fontSize: 12.5,
                        fontWeight:
                            _validStatus ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
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
                    maxLines: 1,
                    controller: _streetController,
                    textInputAction: TextInputAction.done,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.yellowAccent,
                    decoration: InputDecoration(
                      hintText: '$_streetText',
                      hintStyle: new TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("street"),
                      helperStyle: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.yellowAccent, width: 2.5)),
                      errorText: _validStatus ? null : empty_error_msg,
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.yellowAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.none)),
                    ),
                  ),
                ),
                new ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.white24))),
                    child: Icon(Icons.add_location, color: Colors.white),
                  ),
                  title: TextField(
                    controller: _blockController,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.yellowAccent,
                    decoration: InputDecoration(
                      hintText: _blockText,
                      hintStyle: new TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("block"),
                      helperStyle: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.yellowAccent, width: 2.5)),
                      errorText: _validStatus ? null : empty_error_msg,
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.yellowAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.none)),
                    ),
                  ),
                ),
                new ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.white24))),
                    child: Icon(Icons.add_location, color: Colors.white),
                  ),
                  title: TextField(
                    controller: _buildingController,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.yellowAccent,
                    decoration: InputDecoration(
                      hintText: _buildingText,
                      hintStyle: new TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("building"),
                      helperStyle: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.yellowAccent, width: 2.5)),
                      errorText: _validStatus ? null : '$empty_error_msg',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.yellowAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.none)),
                    ),
                  ),
                ),
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
                    controller: _avenueController,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.yellowAccent,
                    decoration: InputDecoration(
                      hintText: _avenueText,
                      hintStyle: new TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("avenue"),
                      helperStyle: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.yellowAccent, width: 2.5)),
                      errorText: _validStatus ? null : '$empty_error_msg',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.yellowAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.none)),
                    ),
                  ),
                ),
                new ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.white24))),
                    child: Icon(Icons.add_location, color: Colors.white),
                  ),
                  title: TextField(
                    controller: _apartmentController,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.yellowAccent,
                    decoration: InputDecoration(
                      hintText: _apartmentText,
                      hintStyle: new TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("apartment"),
                      helperStyle: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.yellowAccent, width: 2.5)),
                      errorText: _validStatus ? null : '$empty_error_msg',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.yellowAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.none)),
                    ),
                  ),
                ),
                new ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.white24))),
                    child: Icon(Icons.add_location, color: Colors.white),
                  ),
                  title: TextField(
                    controller: _floorController,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.yellowAccent,
                    decoration: InputDecoration(
                      hintText: _floorText,
                      hintStyle: new TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("floor"),
                      helperStyle: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.yellowAccent, width: 2.5)),
                      errorText: _validStatus ? null : '$empty_error_msg',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.yellowAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.none)),
                    ),
                  ),
                ),
                new ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.white24))),
                    child: Icon(Icons.add_location, color: Colors.white),
                  ),
                  title: TextField(
                    controller: _phoneController,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.yellowAccent,
                    decoration: InputDecoration(
                      hintText: _floorText,
                      hintStyle: new TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("phone"),
                      helperStyle: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.yellowAccent, width: 2.5)),
                      errorText: _validStatus ? null : '$empty_error_msg',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.yellowAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.none)),
                    ),
                  ),
                ),
              ].map<Widget>((Widget child) {
                return Container(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    height: 96.0,
                    child: child);
              }).toList())),
    );
  }

  Future _addAddress() async {
    /*
    * customer_id
    * selected_area_id
    * address_name
    * block
    * street
    * building
    * avenue
    * apartment
    * floor
    * phone_number
    * token
    *
    * */

    var _token = await UserPref.getPref('token');
    var customer_id = await UserPref.getPref('user_id');
    var selected_area_id = _selectedLocation.checked_area_id;
    var address_name = _addressNameController.text;
    var street = _streetController.text;
    var block = _blockController.text;
    var building = _buildingController.text;
    var avenue = _avenueController.text;
    var apartment = _apartmentController.text;
    var floor = _floorController.text;
    var phone_number = _phoneController.text;

    var _httpBody = {
      "customer_id": customer_id,
      "selected_area_id": selected_area_id,
      "address_name": address_name,
      "street": street,
      "block": block,
      "building": building,
      "avenue": avenue,
      "apartment": apartment,
      "floor": floor,
      "phone_number": phone_number,
    };

    print('hhtpbody : ${_httpBody.toString()}');

    final response = await http.post(
      ApiConstant.ADD_CUSTOMER_ADDRESS,
      body: _httpBody,
      headers: {"Authorization": "Bearer $_token"},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      var data = jsonResponse['success'];
      print('add address response : $data');
      Navigator.pop(context, DismissDialogAction.save);
    }
  }
}
