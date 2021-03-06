// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:carspa/api/ApiConstant.dart';
import 'package:carspa/api/ApiHelperClass.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:flutter/material.dart';
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

  var _addressNameText = 'Enter Address Name';
  var _areaNameText = 'Enter Area Name';
  var _streetText = 'Enter Street';
  var _blockText = 'Enter Block';
  var _buildingText = 'Enter Building No';
  var _avenueText = 'Enter Avenue No';
  var _apartmentText = 'Enter Apartment No';
  var _floorText = 'Enter Floor No';
  var _phoneText = 'Enter Phone No';

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
              content: Text(AppTranslations.of(context).text("discard_warning"),
                  style: dialogTextStyle),
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

    var _locale = await UserStringPref.getPref('lang_code');
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
            area_name: u['area_name'],
            checked_area_id: u['checked_area_id'].toString());
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
    var enter = AppTranslations.of(context).text("enter");
    _addressNameText = enter + ' ' + AppTranslations.of(context).text("enter");
    _areaNameText = enter + ' ' + AppTranslations.of(context).text("enter");
    _streetText = enter + ' ' + AppTranslations.of(context).text("street");
    _blockText = enter + ' ' + AppTranslations.of(context).text("block");
    _buildingText = enter + ' ' + AppTranslations.of(context).text("building");
    _avenueText = enter + ' ' + AppTranslations.of(context).text("avenue");
    _apartmentText =
        enter + ' ' + AppTranslations.of(context).text("apartment");
    _floorText = enter + ' ' + AppTranslations.of(context).text("floor");
    _phoneText = enter + ' ' + AppTranslations.of(context).text("phone");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(AppTranslations.of(context).text("add_new_address")),
          actions: <Widget>[
            FlatButton(
                child: Text(AppTranslations.of(context).text("save"),
                    style: theme.textTheme.body1.copyWith(color: Colors.black)),
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
                                width: 1.0, color: Colors.black54))),
                    child: Icon(Icons.add_location, color: Colors.black54),
                    // Icon(Icons.directions_car, color: Colors.black54),
                  ),
                  title: TextField(
                    maxLines: 1,
                    controller: _addressNameController,
                    textInputAction: TextInputAction.done,
                    style: new TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.redAccent,
                    decoration: InputDecoration(
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.none)),
                      hintText: '$_addressNameText',
                      hintStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("address"),
                      helperStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black54, width: 2.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.redAccent, width: 2.5)),
                      errorText: _validStatus ? null : empty_error_msg,
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
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
                                width: 1.0, color: Colors.black54))),
                    child: Icon(Icons.add_location, color: Colors.black54),
                    // Icon(Icons.directions_car, color: Colors.black54),
                  ),
                  title: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: new Border.all(
                        width: 2.5,
                        color: Colors.black54,

                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          backgroundColor: Colors.teal,
                          canvasColor: Color(0xffe0e0e0),
                        ),
                        child: DropdownButton(
                          elevation: 3,
                      isExpanded: true,
                      /*style: TextStyle(
                      color: Colors.black54
                    ),*/
                      hint: Text(
                        AppTranslations.of(context).text("choose_your_area"),
                        // 'Choose Your Area',
                        style: TextStyle(
                          color: Colors.black54,
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
                        ),)
                  ),
                  subtitle: Container(
                    padding: EdgeInsets.all(9.0),
                    child: Text(
                      _validStatus
                          ? AppTranslations.of(context).text("area_name")
                          : empty_error_msg,
                      style: TextStyle(
                        color:
                        _validStatus ? Colors.black54 : Colors.redAccent,
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
                                width: 1.0, color: Colors.black54))),
                    child: Icon(Icons.add_location, color: Colors.black54),
                    // Icon(Icons.directions_car, color: Colors.black54),
                  ),
                  title: TextField(
                    maxLines: 1,
                    controller: _streetController,
                    textInputAction: TextInputAction.done,
                    style: new TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.redAccent,
                    decoration: InputDecoration(
                      hintText: '$_streetText',
                      hintStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("street"),
                      helperStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black54, width: 2.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.redAccent, width: 2.5)),
                      errorText: _validStatus ? null : empty_error_msg,
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
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
                                width: 1.0, color: Colors.black54))),
                    child: Icon(Icons.add_location, color: Colors.black54),
                  ),
                  title: TextField(
                    controller: _blockController,
                    style: new TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.redAccent,
                    decoration: InputDecoration(
                      hintText: _blockText,
                      hintStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("block"),
                      helperStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.black54, width: 2.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.redAccent, width: 2.5)),
                      errorText: _validStatus ? null : empty_error_msg,
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
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
                                width: 1.0, color: Colors.black54))),
                    child: Icon(Icons.add_location, color: Colors.black54),
                  ),
                  title: TextField(
                    controller: _buildingController,
                    style: new TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.redAccent,
                    decoration: InputDecoration(
                      hintText: _buildingText,
                      hintStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("building"),
                      helperStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.black54, width: 2.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.redAccent, width: 2.5)),
                      errorText: _validStatus ? null : '$empty_error_msg',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
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
                                width: 1.0, color: Colors.black54))),
                    child: Icon(Icons.add_location, color: Colors.black54),
                    // Icon(Icons.directions_car, color: Colors.black54),
                  ),
                  title: TextField(
                    controller: _avenueController,
                    style: new TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.redAccent,
                    decoration: InputDecoration(
                      hintText: _avenueText,
                      hintStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("avenue"),
                      helperStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.black54, width: 2.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.redAccent, width: 2.5)),
                      errorText: _validStatus ? null : '$empty_error_msg',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
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
                                width: 1.0, color: Colors.black54))),
                    child: Icon(Icons.add_location, color: Colors.black54),
                  ),
                  title: TextField(
                    controller: _apartmentController,
                    style: new TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.redAccent,
                    decoration: InputDecoration(
                      hintText: _apartmentText,
                      hintStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("apartment"),
                      helperStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.black54, width: 2.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.redAccent, width: 2.5)),
                      errorText: _validStatus ? null : '$empty_error_msg',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
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
                                width: 1.0, color: Colors.black54))),
                    child: Icon(Icons.add_location, color: Colors.black54),
                  ),
                  title: TextField(
                    controller: _floorController,
                    style: new TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.redAccent,
                    decoration: InputDecoration(
                      hintText: _floorText,
                      hintStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("floor"),
                      helperStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.black54, width: 2.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.redAccent, width: 2.5)),
                      errorText: _validStatus ? null : '$empty_error_msg',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
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
                                width: 1.0, color: Colors.black54))),
                    child: Icon(Icons.add_location, color: Colors.black54),
                  ),
                  title: TextField(
                    controller: _phoneController,
                    style: new TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.redAccent,
                    decoration: InputDecoration(
                      hintText: _phoneText,
                      hintStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      helperText: AppTranslations.of(context).text("phone"),
                      helperStyle: new TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.black54, width: 2.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.redAccent, width: 2.5)),
                      errorText: _validStatus ? null : '$empty_error_msg',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                      )),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.none)),
                    ),
                  ),
                ),
              ].map<Widget>((Widget child) {
                return Container(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    height: 110.0,
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

    var _token = await UserStringPref.getPref('token');
    var customer_id = await UserStringPref.getPref('user_id');
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
