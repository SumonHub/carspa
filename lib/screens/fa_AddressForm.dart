import 'dart:convert';

import 'package:carspa/api/ApiConstant.dart';
import 'package:carspa/api/ApiHelperClass.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:carspa/screens/e_CheckOut.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddressForm extends StatefulWidget {
  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {


  TextEditingController _streetController = TextEditingController();
  TextEditingController _blockController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _avenueController = TextEditingController();
  TextEditingController _apartmentController = TextEditingController();
  TextEditingController _floorController = TextEditingController();

  bool _areaValidStatus = true;
  bool _streetValidStatus = true;
  bool _blockValidStatus = true;
  bool _buildingValidStatus = true;

  var _streetText = 'Enter Street';
  var _blockText = 'Enter Block';
  var _buildingText = 'Enter Building No';
  var _avenueText = 'Enter Avenue No';
  var _apartmentText = 'Enter Apartment No';
  var _floorText = 'Enter Floor No';

  var _isLogin = true;

  var empty_msg;

  void _loadPrefData() async {
    var building = await (UserStringPref.getPref('name')) ?? 0;
    var street = await (UserStringPref.getPref('street')) ?? 0;
    setState(() {
      if (street
          .toString()
          .isNotEmpty) {
        _streetText = street;
        _streetController = TextEditingController(text: '$_streetText');
      }
      if (building
          .toString()
          .isNotEmpty) {
        _buildingText = building;
        _buildingController = TextEditingController(text: '$_buildingText');
      }
    });
  }


  List<SuggestedArea> _areaList = new List();
  SuggestedArea _selectedArea;

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

    _loadPrefData();

    _getSuggestedArea();
  }

  @override
  Widget build(BuildContext context) {
    empty_msg = AppTranslations.of(context).text("required");

    var enter = AppTranslations.of(context).text("enter");

    _streetText = AppTranslations.of(context).text("street");
    _blockText = AppTranslations.of(context).text("block");
    _buildingText = AppTranslations.of(context).text("building");
    _avenueText = AppTranslations.of(context).text("avenue");
    _apartmentText = AppTranslations.of(context).text("apartment");
    _floorText = AppTranslations.of(context).text("floor");

    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text(AppTranslations.of(context).text("confirm_address")),
      ),
      bottomNavigationBar: _isLogin
          ? new BottomAppBar(
        child: FlatButton(
          color: Colors.white,
          child: new Text(
            AppTranslations.of(context).text("confirm_address"),
            style: const TextStyle(
              color: Colors.black,
              letterSpacing: 5.0,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            setState(() {
              _selectedArea != null
                  ? _areaValidStatus = true
                  : _areaValidStatus = false;
              _streetController.text.isNotEmpty
                  ? _streetValidStatus = true
                  : _streetValidStatus = false;
              _blockController.text.isNotEmpty
                  ? _blockValidStatus = true
                  : _blockValidStatus = false;
              _buildingController.text.isNotEmpty
                  ? _buildingValidStatus = true
                  : _buildingValidStatus = false;


              _avenueController.text.isNotEmpty
                  ? UserStringPref.savePref(
                  'avenue', '${_avenueController.text}')
                  : UserStringPref.savePref('avenue', null);
              _apartmentController.text.isNotEmpty
                  ? UserStringPref.savePref(
                  'apartment', '${_apartmentController.text}')
                  : UserStringPref.savePref('apartment', null);
              _floorController.text.isNotEmpty
                  ? UserStringPref.savePref('floor', '${_floorController.text}')
                  : UserStringPref.savePref('floor', null);

              if (_areaValidStatus && _streetValidStatus &&
                  _buildingValidStatus &&
                  _blockValidStatus) {
                UserStringPref.savePref('area', '${_selectedArea.area_name}');
                UserStringPref.savePref('street', '${_streetController.text}');
                UserStringPref.savePref('block', '${_blockController.text}');
                UserStringPref.savePref(
                    'building', '${_buildingController.text}');

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckOut()),
                );
              }
            });
          },
        ),
      )
          : null,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: ListView(
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
                    AppTranslations.of(context).text("choose_your_area"),
                    // 'Choose Your Area',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Not necessary for Option 1
                  value: _selectedArea,
                  onChanged: (SuggestedArea newValue) {
                    print('=======${newValue.toString()}======');
                    setState(() {
                      _selectedArea = newValue;
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
                  _areaValidStatus
                      ? AppTranslations.of(context).text("area_name")
                      : empty_msg,
                  style: TextStyle(
                    color:
                    _areaValidStatus ? Colors.white : Colors.yellowAccent,
                    fontSize: 12.5,
                    fontWeight:
                    _areaValidStatus ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            new ListTile(
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                        new BorderSide(width: 1.0, color: Colors.white24))),
                child: Icon(Icons.add_location, color: Colors.white),
                // Icon(Icons.directions_car, color: Colors.white),
              ),
              title: TextField(
                maxLines: 2,
                controller: _streetController,
                textInputAction: TextInputAction.done,
                style: new TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: Colors.yellowAccent,
                decoration: InputDecoration(
                  hintText: '$enter $_streetText',
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
                      borderSide: BorderSide(color: Colors.white, width: 2.5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.yellowAccent, width: 2.5)),
                  errorText:
                  _streetValidStatus ? null : empty_msg,
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
            SizedBox(
              height: 12.0,
            ),
            new ListTile(
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                        new BorderSide(width: 1.0, color: Colors.white24))),
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
                  hintText: '$enter $_blockText',
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
                      borderSide:
                      BorderSide(color: Colors.yellowAccent, width: 2.5)),
                  errorText: _blockValidStatus ? null : empty_msg,
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
            SizedBox(
              height: 12.0,
            ),
            new ListTile(
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                        new BorderSide(width: 1.0, color: Colors.white24))),
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
                  hintText: '$enter ' + _buildingText,
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
                      borderSide:
                      BorderSide(color: Colors.yellowAccent, width: 2.5)),
                  errorText:
                  _buildingValidStatus ? null : '$empty_msg',
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
            SizedBox(
              height: 12.0,
            ),
            new ListTile(
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                        new BorderSide(width: 1.0, color: Colors.white24))),
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
                  hintText: '$enter ' + _avenueText,
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
                      borderSide:
                      BorderSide(color: Colors.yellowAccent, width: 2.5)),
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            new ListTile(
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                        new BorderSide(width: 1.0, color: Colors.white24))),
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
                  hintText: '$enter ' + _apartmentText,
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
                      borderSide:
                      BorderSide(color: Colors.yellowAccent, width: 2.5)),
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            new ListTile(
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                        new BorderSide(width: 1.0, color: Colors.white24))),
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
                  hintText: '$enter ' + _floorText,
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
                      borderSide:
                      BorderSide(color: Colors.yellowAccent, width: 2.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
