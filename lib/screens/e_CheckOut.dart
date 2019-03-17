import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_x/api/ApiConstant.dart';
import 'package:flutter_app_x/components/MyTitle.dart';
import 'package:flutter_app_x/components/MyValueText.dart';
import 'package:flutter_app_x/components/ProfileTextField.dart';
import 'package:flutter_app_x/drawer/AddressBook.dart';
import 'package:flutter_app_x/localization/AppTranslations.dart';
import 'package:flutter_app_x/pref/UserPref.dart';
import 'package:flutter_app_x/drawer/LoginPage.dart';
import 'package:flutter_app_x/drawer/LoginTab.dart';
import 'package:flutter_app_x/drawer/PickAddressTab.dart';
import 'package:flutter_app_x/screens/f_PickMap.dart';
import 'package:flutter_app_x/screens/g_SuccessPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  bool _isLoading = true;
  bool _isLogin = false;
  bool _isGuestLogin = false;
  bool _isAddressConfirm = false;

  String user_id;
  String user_name;
  String user_email;
  String user_phone;

  String serialize_dateTime;
  String dateTime;
  String car_name;
  String car_id;
  String service_nature;
  String service_name;
  String service_id;
  String addons_id; //
  String price;
  String duration;

  var street = ' Street no selected';
  var block = ' Block no selected';
  var building = ' Building not selected';
  var avenue = ' Avenue not selected';
  var apartment = ' Apartment no selected';
  var floor = ' Floor no selected';

  var _pickAddress = 'Pick Address';
  final List<String> _allActivities = <String>['Cash'];
  String _payMethod = 'Cash';

  ContactDetails _contactDetails;
  AddressDetails _addressDetails;
  OrderDatails _orderDatails;

  //Loading counter value on start
  Future _loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('------------CheckOut_loadPref()-------------');

      _isLogin = (prefs.getBool('isLogin') ?? false);
      _isGuestLogin = (prefs.getBool('isGuestLogin') ?? false);

      serialize_dateTime = (prefs.getString('serialize_dateTime') ?? 0);
      dateTime = (prefs.getString('dateTime') ?? 0);
      car_name = (prefs.getString('car_type_name') ?? 0);
      car_id = (prefs.getString('car_type_id') ?? 0);
      service_name = (prefs.getString('service_name') ?? 0);
      service_nature = (prefs.getString('service_nature') ?? 0);
      service_id = (prefs.getString('service_id') ?? 0);
      price = (prefs.getString('price') ?? 0);
      duration = (prefs.getString('duration') ?? 0);

      user_id = prefs.getString('user_id');
      user_name = prefs.getString('user_name');
      user_email = prefs.getString('user_email');
      user_phone = prefs.getString('user_phone');

      street = prefs.getString('street');
      block = prefs.getString('block');
      building = prefs.getString('building');
      avenue = prefs.getString('avenue');
      apartment = prefs.getString('apartment');
      floor = prefs.getString('floor');

      _contactDetails = new ContactDetails(
          user_id, user_name, user_name, user_email, user_phone);
      _orderDatails = new OrderDatails(
          user_id,
          user_name,
          user_email,
          serialize_dateTime,
          car_name,
          car_id,
          service_nature,
          service_name,
          service_id,
          price,
          duration);
      _addressDetails =
          new AddressDetails(street, block, building, avenue, apartment, floor);

      print(_contactDetails.toString());
      print(_addressDetails.toString());
      print(_orderDatails.toString());
    });
  }

  @override
  void initState() {
    /*
    * check isLogin
    * ? retrieve = name + email + date and time + Car type + Service name + service nature
    * : resister
    *
    *
    * */
    super.initState();
    print('---------------->CheckOut initState()');
    _loadPref().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
          title: Text(
            AppTranslations.of(context).text("check_out"),
          ),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 12.0),
              child: IconButton(
                  icon: Icon(
                    Icons.person_pin,
                    size: 30,
                  ),
                  onPressed: () {
                    _getLoginFeed(context);
                  }),
            )
          ],
        ),
        bottomNavigationBar: _isLogin || _isGuestLogin
            ? new Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: MaterialButton(
                  child: new Text(
                    AppTranslations.of(context).text("check_out"),
                    style: const TextStyle(
                      color: Colors.black,
                      letterSpacing: 5.0,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    /*  Fluttertoast.showToast(
                        msg: " Processing your order :) ",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                        fontSize: 16.0); */

                    if (_addressDetails.street == null ||
                        _addressDetails.block == null ||
                        _addressDetails.building == null) {
                      Fluttertoast.showToast(
                          msg: AppTranslations.of(context)
                              .text("pick_address_error_msg"),
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.yellowAccent,
                          fontSize: 16.0);
                    } else {
                      _submitOrder().then((bool status) {
                        if (status) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SuccessPage()),
                              ModalRoute.withName('/'));
                          // Navigator.of(context).pushNamedAndRemoveUntil('/screen4', (Route<dynamic> route) => false);
                          // ModalRoute.withName('/screen1'));
                        } else {
                          Fluttertoast.showToast(
                              msg: AppTranslations.of(context)
                                  .text("error_msg"),
                              //error_msg
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.black54,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      });
                    }
                  },
                  elevation: 4.0,
                  minWidth: double.infinity,
                  height: 48.0,
                  color: Colors.white,
                ),
              )
            : null,
        body: _isLoading
            ? new Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : _isLogin || _isGuestLogin
                ? new ListView(
                    padding: EdgeInsets.all(17.0),
                    children: <Widget>[
                      _isGuestLogin
                          ? Center(
                              child: new Text(AppTranslations.of(context).text("guest_login_warning_msg"),
                                style: TextStyle(color: Colors.yellowAccent),
                              ),
                            )
                          : null,
                      new PPTextField(
                          Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                          '${_contactDetails.first_name}',
                          null),
                      new PPTextField(
                          Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          '$user_email',
                          null),
                      new PPTextField(
                          Icon(
                            Icons.phone_iphone,
                            color: Colors.white,
                          ),
                          '$user_phone ',
                          null),
                      new PPTextField(
                          Icon(
                            Icons.date_range,
                            color: Colors.white,
                          ),
                          dateTime.replaceAll(',', ''),
                          null),
                      new Card(
                          color: Colors.teal,
                          elevation: 3.0,
                          // color: Colors.white,
                          child: new Container(
                            padding: EdgeInsets.only(bottom: 12.0),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.only(right: 12.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            right: new BorderSide(
                                                width: 1.0,
                                                color: Colors.white24))),
                                    child:
                                        Icon(Icons.list, color: Colors.white),
                                    // Icon(Icons.directions_car, color: Colors.white),
                                  ),
                                  title: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 0.0),
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            bottom: new BorderSide(
                                                width: 1.0,
                                                color: Colors.white))),
                                    child: Text(
                                      AppTranslations.of(context)
                                          .text("services_details"),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                // SizedBox(height: 15.0),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Container(
                                      // color: Colors.red,
                                      // width: MediaQuery.of(context).size.width*0.39,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          new MyTitle(
                                            AppTranslations.of(context)
                                                .text("car_name"),
                                          ),
                                          new MyTitle(
                                            AppTranslations.of(context)
                                                .text("service_nature"),
                                          ),
                                          new MyTitle(
                                            AppTranslations.of(context)
                                                .text("service_name"),
                                          ),
                                          new MyTitle(
                                            AppTranslations.of(context)
                                                .text("price"),
                                          ),
                                          new MyTitle(
                                            AppTranslations.of(context)
                                                .text("duration"),
                                          ),
                                          //  new MyText('created_at'),
                                        ],
                                      ),
                                    ),
                                    new Container(
                                      //   color: Colors.yellow,
                                      // width: MediaQuery.of(context).size.width*0.40,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new MyValueText('$car_name'),
                                          new MyValueText('$service_nature'),
                                          new MyValueText('$service_name'),
                                          new MyValueText('$price'),
                                          new MyValueText('$duration'),
                                          // new MyText('= ${widget.orders[index].created_at}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 8.0),
                      new Card(
                        elevation: 3.0,
                        child: new Container(
                          child: ListTile(
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.white24))),
                                child: Icon(Icons.monetization_on,
                                    color: Colors.white),
                              ),
                              title: Container(
                                padding: EdgeInsets.only(
                                    top: 0.0,
                                    bottom: 0.0,
                                    left: 20.0,
                                    right: 12.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: DropdownButton(
                                  isExpanded: true,
                                  items: _allActivities
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                          '${AppTranslations.of(context).text("payment_by")} : $value'),
                                    );
                                  }).toList(),
                                  value: _payMethod,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _payMethod = newValue;
                                    });
                                  },
                                ),
                              )
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              //  trailing: Icon(Icons.directions_car, color: Colors.white)
                              ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      new Card(
                          elevation: 3.0,
                          color: Colors.teal,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ListTile(
                                      leading: Container(
                                        padding: EdgeInsets.only(right: 12.0),
                                        decoration: new BoxDecoration(
                                            border: new Border(
                                                right: new BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white24))),
                                        child: Icon(Icons.directions,
                                            color: Colors.white),
                                        // Icon(Icons.directions_car, color: Colors.white),
                                      ),
                                      title: Text(
                                        AppTranslations.of(context)
                                            .text("pick_address"),
                                        style: TextStyle(
                                            //fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              Row(children: <Widget>[
                                Expanded(
                                  child: MaterialButton(
                                    textColor: Colors.white,
                                    child: Text(AppTranslations.of(context)
                                        .text("address_book")),
                                    // color: Colors.red,address_book
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(
                                            new MaterialPageRoute(
                                                builder: (_) =>
                                                    new AddressBook()),
                                          )
                                          .then((value) =>
                                              value ? _loadPref() : null);

                                      /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddressBook()));*/
                                    },
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  decoration: new BoxDecoration(
                                      border: new Border(
                                          left: new BorderSide(
                                              width: 5.0,
                                              color: Colors.white54))),
                                  child: MaterialButton(
                                    textColor: Colors.white,
                                    child: Text(AppTranslations.of(context)
                                        .text("map")),
                                    // color: Colors.yellow,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PickMap()));
                                    },
                                  ),
                                )),
                              ])
                            ],
                          )),
                      new Card(
                          color: Colors.teal,
                          elevation: 3.0,
                          // color: Colors.white,
                          child: new Container(
                            padding: EdgeInsets.only(bottom: 12.0),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.only(right: 12.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            right: new BorderSide(
                                                width: 1.0,
                                                color: Colors.white24))),
                                    child:
                                        Icon(Icons.list, color: Colors.white),
                                    // Icon(Icons.directions_car, color: Colors.white),
                                  ),
                                  title: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 0.0),
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            bottom: new BorderSide(
                                                width: 1.0,
                                                color: Colors.white))),
                                    child: Text(
                                      AppTranslations.of(context)
                                          .text("address_details"),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                // SizedBox(height: 15.0),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Container(
                                      //    color: Colors.red,
                                      // width: MediaQuery.of(context).size.width*0.39,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          new MyTitle(
                                              AppTranslations.of(context)
                                                  .text("street")),
                                          new MyTitle(
                                              AppTranslations.of(context)
                                                  .text("block")),
                                          new MyTitle(
                                              AppTranslations.of(context)
                                                  .text("building")),
                                          new MyTitle(
                                              AppTranslations.of(context)
                                                  .text("avenue")),
                                          new MyTitle(
                                              AppTranslations.of(context)
                                                  .text("apartment")),
                                          new MyTitle(
                                              AppTranslations.of(context)
                                                  .text("floor")),
                                        ],
                                      ),
                                    ),
                                    new Container(
                                      //   color: Colors.yellow,
                                      // width: MediaQuery.of(context).size.width*0.40,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new MyValueText(
                                              '${street == null ? '${AppTranslations.of(context).text("not_selected_error_msg")}' : street}'),
                                          new MyValueText(
                                              '${block == null ? '${AppTranslations.of(context).text("not_selected_error_msg")}' : block}'),
                                          new MyValueText(
                                              '${building == null ? '${AppTranslations.of(context).text("not_selected_error_msg")}' : building}'),
                                          new MyValueText(
                                              '${avenue == null ? '${AppTranslations.of(context).text("not_selected_error_msg")}' : avenue}'),
                                          new MyValueText(
                                              '${apartment == null ? '${AppTranslations.of(context).text("not_selected_error_msg")}' : apartment}'),
                                          new MyValueText(
                                              '${floor == null ? '${AppTranslations.of(context).text("not_selected_error_msg")}' : floor}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ].map<Widget>((Widget child) {
                      return Container(
                          //  padding: const EdgeInsets.symmetric(vertical: 5.0),
                          // height: 96.0,
                          child: child);
                    }).toList(),
                  )
                : new Center(
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
                  ));
  }

  Future<bool> _submitOrder() async {
    var _locale = await UserPref.getPref('locale');
    _locale == 0 ? _locale = '?locale=en' : null;

    var user_id = _contactDetails.user_id ?? ' ';
    var user_first_name = _contactDetails.first_name;
    var user_email = _contactDetails.email;
    var user_phone = _contactDetails.phone;

    var street = _addressDetails.street;
    var block = _addressDetails.block;
    var building = _addressDetails.building;
    var avenue = _addressDetails.avenue;
    var apartment = _addressDetails.apartment;
    var floor = _addressDetails.floor;

    print(''
        '\n user_id : $user_id'
        '\n user_first_name : $user_first_name'
        '\n user_email : $user_email'
        '\n user_phone : $user_phone'
        '\n street : $street'
        '\n block : $block'
        '\n building : $building'
        '\n avenue : $avenue'
        '\n apartment : $apartment'
        '\n floor : $floor');

    /*   var _shippingAddress = new _ShippingAddress(
        first_name: user_first_name,
        last_name: user_first_name,
        email: user_email,
        phone: user_phone,
        street: street,
        block: block,
        building: building,
        avenue: avenue,
        apartment: apartment,
        floor: floor);*/

    var _shippingAddressBody = json.encode(new _ShippingAddress(
        first_name: user_first_name,
        last_name: user_first_name,
        email: user_email,
        phone: user_phone,
        street: street,
        block: block,
        building: building,
        avenue: avenue,
        apartment: apartment,
        floor: floor));
    print('_shippingAddressBody : $_shippingAddressBody');

    var _shippingAddressResponse = await http.post(
      ApiConstant.ARRAY_TO_STRING,
      body: {'serialize_array': '$_shippingAddressBody'},
    );
    var jsonResponse = json.decode(_shippingAddressResponse.body);
    var _shippingAddress = jsonResponse['data'];
    print('_shippingAddress response : $_shippingAddress');

    // Create a FormData
    var _orderBody = {
      "user_id": " $user_id", //*
      "addons_id": " ",
      "service_id": "${_orderDatails.service_id}", //*
      "car_type_id": "${_orderDatails.car_id}", //*
      "amount": "${_orderDatails.price}", //*
      "duration": "${_orderDatails.duration}", //*
      "shipping_address": "$_shippingAddress", //*
      "order_schedule": "${_orderDatails.serialize_dateTime}", //*
      "payment_method": " $_payMethod ", //*
      "paid_amount": "123456", //*
      "order_type": "${_orderDatails.service_nature}", //*
    };
    print('_orderBody : ${_orderBody}');
    // Send FormData
    var response = await http.post(ApiConstant.SUBMIT_ORDER, body: _orderBody);
    print('checkout response : ${response.body}');
    print('checkout response status : ${response.statusCode}');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  void _getLoginFeed(BuildContext context) async {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (_) => new LoginTab()),
    ).then((val) => val ? _loadPref() : null);
  }
}

class _ShippingAddress {
  final String first_name;
  final String last_name;
  final String email;
  final String phone;
  final String street;
  final String block;
  final String building;
  final String avenue;
  final String apartment;
  final String floor;
  final String additional_direction = "No direction";

  const _ShippingAddress(
      {this.first_name,
      this.last_name,
      this.email,
      this.phone,
      this.street,
      this.block,
      this.building,
      this.avenue,
      this.apartment,
      this.floor});

  Map toJson() {
    return {
      'contact_details': {
        'first_name': '$first_name',
        'last_name': ' $last_name',
        'email': '$email',
        'phone': '$phone'
      },
      "address_details": {
        "street": "$street",
        "block": "$block",
        "building": "$building",
        "avenue": "$avenue",
        "apartment": "$apartment",
        "floor": "$floor",
        "additional-direction": "No direction"
      }
    };
  }
}

class ContactDetails {
  var user_id;
  var first_name;
  var last_name;
  var email;
  var phone;

  ContactDetails(
      this.user_id, this.first_name, this.last_name, this.email, this.phone);

  @override
  String toString() {
    return 'ContactDetails{user_id: $user_id, first_name: $first_name, last_name: $last_name, email: $email, phone: $phone}';
  }
}

class AddressDetails {
  var street;
  var block;
  var building;
  var avenue;
  var apartment;
  var floor;
  var additional_direction = "No direction";

  AddressDetails(this.street, this.block, this.building, this.avenue,
      this.apartment, this.floor);

  @override
  String toString() {
    return 'AddressDetails{street: $street, block: $block, building: $building, avenue: $avenue, apartment: $apartment, floor: $floor, additional_direction: $additional_direction}';
  }
}

class OrderDatails {
  String user_id;
  String user_name;
  String user_email;
  String serialize_dateTime;
  String car_name;
  String car_id;
  String service_nature;
  String service_name;
  String service_id;
  String price;
  String duration;

  OrderDatails(
      this.user_id,
      this.user_name,
      this.user_email,
      this.serialize_dateTime,
      this.car_name,
      this.car_id,
      this.service_nature,
      this.service_name,
      this.service_id,
      this.price,
      this.duration);

  @override
  String toString() {
    return 'OrderDatails{user_id: $user_id, user_name: $user_name, user_email: $user_email, serialize_dateTime: $serialize_dateTime, car_name: $car_name, car_id: $car_id, service_nature: $service_nature, service_name: $service_name, service_id: $service_id, price: $price, duration: $duration}';
  }
}
