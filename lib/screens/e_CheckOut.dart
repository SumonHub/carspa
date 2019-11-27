import 'dart:async';
import 'dart:convert';

import 'package:carspa/api/ApiConstant.dart';
import 'package:carspa/components/MyToast.dart';
import 'package:carspa/components/ProfileTextField.dart';
import 'package:carspa/drawer/AddressBook.dart';
import 'package:carspa/drawer/LoginTab.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:carspa/screens/f_PickMap.dart';
import 'package:carspa/screens/g_SuccessPage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum ConfirmAction { CANCEL, ACCEPT }

Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppTranslations.of(context).text("order_confirm")),
        // content: const Text('This will reset your device to its default factory settings.'),
        actions: <Widget>[
          FlatButton(
            child: new Text(
              AppTranslations.of(context).text("cancel"),
            ),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: new Text(
              AppTranslations.of(context).text("submit"),
            ),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  bool _isLoading = false;
  bool _isLogin = false;
  bool _isGuestLogin = false;

  String user_id;
  String user_fstName;
  String user_lstName;
  String user_email;
  String user_phone;

  String serialize_dateTime;
  String dateTime;
  String car_name;
  String car_id;
  String service_nature;
  String service_name;
  String service_id;
  var serialize_addons_id;
  String price;
  String duration;

  var street;
  var area;
  var block;

  var building;
  var avenue;
  var apartment;
  var floor;

  var _pickAddress = 'Pick Address';
  final List<String> _allActivities = <String>['Cash'];
  String _payMethod = 'Cash';

  ContactDetails _contactDetails;
  AddressDetails _addressDetails;
  OrderDatails _orderDatails;

  bool hasAddons = false;
  String addonsName;
  String addonsDuration;
  String addonsPrice;

  //Loading counter value on start
  Future _loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('------------CheckOut_loadPref()-------------');

      _isLogin = (prefs.getBool('isLogin') ?? false);
      _isGuestLogin = (prefs.getBool('isGuestLogin') ?? false);

      print('guest login status = $_isGuestLogin');
/*
* serialize_dateTime  = a:1:{i:0;a:2:{s:4:"date";s:9:"3/25/2019";s:4:"time";s:8:"11:36 PM";}}
* dateTime  = 2019/3/25 at 11:36 PM
*/
      serialize_dateTime = (prefs.getString('serialize_dateTime') ?? 0);
      dateTime = (prefs.getString('dateTime') ?? 0);
      car_name = (prefs.getString('car_type_name') ?? 0);
      car_id = (prefs.getString('car_type_id') ?? 0);
      service_name = (prefs.getString('service_name') ?? 0);
      service_nature = (prefs.getString('service_nature') ?? 0);
      service_id = (prefs.getString('service_id') ?? 0);
      serialize_addons_id = (prefs.getString('serialize_addons') ?? "");
      price = (prefs.getString('price') ?? 0);
      duration = (prefs.getString('duration') ?? 0);

      hasAddons = (prefs.getBool('hasAddons') ?? false);
      if (hasAddons) {
        addonsName = (prefs.getString('addons_name') ?? 0);
        addonsDuration = (prefs.getString('addons_duration') ?? 0);
        addonsPrice = (prefs.getString('addons_price') ?? 0);
      }

      user_fstName = prefs.getString('user_fstName');
      user_lstName = prefs.getString('user_lstName');
      if (_isGuestLogin) {
        user_id = ' ';
        user_email = ' ';
      } else {
        user_id = prefs.getString('user_id');
        user_email = prefs.getString('user_email');
      }

      user_phone = prefs.getString('user_phone');

      street = prefs.getString('street');
      area = prefs.getString('area');
      block = prefs.getString('block');
      building = prefs.getString('building');
      avenue = prefs.getString('avenue');
      apartment = prefs.getString('apartment');
      floor = prefs.getString('floor');

      _contactDetails = new ContactDetails(
          user_id, user_fstName, user_lstName, user_email, user_phone);
      _orderDatails = new OrderDatails(
          user_id,
          user_fstName,
          user_lstName,
          user_email,
          serialize_dateTime,
          car_name,
          car_id,
          service_nature,
          service_name,
          service_id,
          serialize_addons_id,
          price,
          duration);
      _addressDetails = new AddressDetails(
          street, area, block, building, avenue, apartment, floor);

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
    Widget buildText(String key, String value) {
      return new Expanded(
          flex: 0,
          child: Container(
            margin: EdgeInsets.only(left: 60.0, right: 12.0),
            padding: EdgeInsets.all(3.0),
            /* decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.red),),
            ),*/
            child: new Row(
              children: <Widget>[
                new Expanded(
                  //flex: 0,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        '$key',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    width: 35,
                    child: new Icon(
                      Icons.label,
                      color: Colors.black54,
                      size: 20.0,
                    ),
                  ),
                ),
                new Expanded(
                  flex: 2,
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        '''$value''',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    }

    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
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
                  _goToLoginTab(context, 0);
                }),
          )
        ],
      ),
      bottomNavigationBar: _isLogin || _isGuestLogin
          ? new BottomAppBar(
        child: MaterialButton(
          minWidth: double.infinity,
          height: 48.0,
          color: Color(0xffe0e0e0),
                child: new Text(
                  AppTranslations.of(context).text("check_out"),
                  style: const TextStyle(
                    color: Colors.black,
                    letterSpacing: 5.0,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  if (_addressDetails.street.toString().trim().length == 0 ||
                      _addressDetails.block == null ||
                      _addressDetails.building == null) {
                    new MyToast(
                        context,
                        '',
                        AppTranslations.of(context)
                            .text("pick_address_error_msg"),
                        Duration(seconds: 2),
                        Colors.black54,
                        FlushbarPosition.TOP,
                        false)
                        .showToast();
                  } else {
                    final ConfirmAction action =
                        await _asyncConfirmDialog(context);
                    print("Confirm Action $action");

                    switch (action) {
                      case ConfirmAction.CANCEL:
                        // TODO: Handle this case.

                        break;
                      case ConfirmAction.ACCEPT:
                        // TODO: Handle this case.
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
                            new MyToast(
                                context,
                                '',
                                AppTranslations.of(context)
                                    .text("error_msg"),
                                Duration(seconds: 2),
                                Color(0xff004d40),
                                FlushbarPosition.TOP,
                                false)
                                .showToast();
                          }
                        });
                        break;
                    }
                  }
                },
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
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(17.0),
        children: <Widget>[
          _isGuestLogin
              ? Center(
            child: new Text(
              AppTranslations.of(context)
                  .text("guest_login_warning_msg"),
              style: TextStyle(color: Colors.redAccent),
            ),
          )
              : null,
          new PPTextField(
              Icon(
                Icons.account_circle,
                color: Colors.black54,
              ),
              '${_contactDetails.first_name + " " + _contactDetails.last_name}',
              null),
          _isGuestLogin
              ? null
              : new PPTextField(
              Icon(
                Icons.email,
                color: Colors.black54,
              ),
              '$user_email',
              null),
          new PPTextField(
              Icon(
                Icons.phone_iphone,
                color: Colors.black54,
              ),
              '$user_phone ',
              null),
          new PPTextField(
              Icon(
                Icons.date_range,
                color: Colors.black54,
              ),
              dateTime,
              null),
          // service details
          new Card(
            // color: Color(0xffe0e0e0),
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
                                    color: Colors.black54))),
                        child: Icon(Icons.list, color: Colors.black54),
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
                                    color: Colors.black54))),
                        child: Text(
                          AppTranslations.of(context)
                              .text("services_details"),
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // SizedBox(height: 15.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            children: <Widget>[
                              buildText(
                                  AppTranslations.of(context)
                                      .text("car_name"),
                                  '$car_name'),
                              buildText(
                                  AppTranslations.of(context)
                                      .text("service_nature"),
                                  '$service_nature'),
                              buildText(
                                  AppTranslations.of(context)
                                      .text("service_name"),
                                  '$service_name'),
                              buildText(
                                  AppTranslations.of(context)
                                      .text("price"),
                                  '$price'),
                              buildText(
                                  AppTranslations.of(context)
                                      .text("duration"),
                                  '$duration'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 8.0),
          // payment method
          new Card(
            elevation: 3.0,
            child: new Container(
              child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.white24))),
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
          // pick address
          new Card(
              elevation: 3.0,
              color: Colors.white,
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
                                    color: Colors.black54),
                              ),

                            ),
                            child: Icon(Icons.directions,
                                color: Colors.black54),
                            // Icon(Icons.directions_car, color: Colors.white),
                          ),
                          title:
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 0.0),
                            padding: EdgeInsets.only(bottom: 8.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    bottom: new BorderSide(
                                        width: 1.0,
                                        color: Colors.black54))),
                            child: Text(
                              AppTranslations.of(context)
                                  .text("pick_address"),
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
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
                            .text("address_book"),
                          style: TextStyle(
                            //fontSize: 18.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
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
                        },
                      ),
                    ),
                    Expanded(
                        child: Container(
                          decoration: new BoxDecoration(
                              border: new Border(
                                  left: new BorderSide(
                                      width: 5.0,
                                      color: Colors.black26))),
                          child: MaterialButton(
                            textColor: Colors.white,
                            child: Text(
                              AppTranslations.of(context).text("map"),
                              style: TextStyle(
                                //fontSize: 18.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
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
          const SizedBox(height: 8.0),
          // address details
          new Card(
              color: Colors.white,
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
                                    color: Colors.black54))),
                        child: Icon(Icons.list, color: Colors.black54),
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
                                    color: Colors.black54))),
                        child: Text(
                          AppTranslations.of(context)
                              .text("address_details"),
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // SizedBox(height: 15.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            children: <Widget>[
                              buildText(
                                  AppTranslations.of(context)
                                      .text("street"),
                                  '${street == null ? '${AppTranslations.of(context).text("not_selected_error_msg")}' : street}'),
                              buildText(
                                  AppTranslations.of(context)
                                      .text("area_name"),
                                  '${area == null ? '${AppTranslations.of(context).text("not_selected_error_msg")}' : area}'),
                              buildText(
                                  AppTranslations.of(context)
                                      .text("block"),
                                  '${block == null ? '${AppTranslations.of(context).text("not_selected_error_msg")}' : block}'),
                              buildText(
                                  AppTranslations.of(context)
                                      .text("building"),
                                  '${building == null ? '${AppTranslations.of(context).text("not_selected_error_msg")}' : building}'),
                              buildText(
                                  AppTranslations.of(context)
                                      .text("avenue"),
                                  '${avenue == null ? '${AppTranslations.of(context).text("not_selected_error_msg")}' : avenue}'),
                              buildText(
                                  AppTranslations.of(context)
                                      .text("apartment"),
                                  '${apartment == null ? '${AppTranslations.of(context).text("not_selected_error_msg")}' : apartment}'),
                              buildText(
                                  AppTranslations.of(context)
                                      .text("floor"),
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
              : Center(
                  child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                      //elevation: 4.0,
                      // minWidth: double.infinity,
                      height: 48.0,
                      color: Color(0xffe0e0e0),
                      onPressed: () {
                        _goToLoginTab(context, 0);
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
                    FlatButton(
                      // color: Colors.blue,
                      textColor: Colors.black,
                      //  disabledColor: Colors.grey,
                      //  disabledTextColor: Colors.black,
                      //  padding: EdgeInsets.all(8.0),
                      //  splashColor: Colors.blueAccent,
                      onPressed: () {
                        _goToLoginTab(context, 1);
                      },
                      child: Text(
                        "* ${AppTranslations.of(context).text("login_as_guest")}",
                      ),
                    )
                  ],
                )),
    );
  }

  Future<bool> _submitOrder() async {
    var _locale = await UserStringPref.getPref('locale');
    _locale == 0 ? _locale = '?locale=en' : null;

    var user_id = _contactDetails.user_id ?? ' ';
    var user_fst_name = _contactDetails.first_name;
    var user_lst_name = _contactDetails.last_name;
    var user_email = _contactDetails.email;
    var user_phone = _contactDetails.phone;

    var street = _addressDetails.street;
    var area = _addressDetails.area;
    var block = _addressDetails.block;
    var building = _addressDetails.building;
    var avenue = _addressDetails.avenue;
    var apartment = _addressDetails.apartment;
    var floor = _addressDetails.floor;

    var _shippingAddressBody = json.encode(new _ShippingAddress(
        first_name: user_fst_name,
        last_name: user_lst_name,
        email: user_email,
        phone: user_phone,
        street: street,
        area: area,
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
    // print('_shippingAddressResponse : $_shippingAddress');

    // Create a FormData
    var _orderBody = {
      "user_id": " $user_id", //*
      "addons_id": "${_orderDatails.serialize_addons_id}",
      "service_id": "${_orderDatails.service_id}", //*
      "car_type_id": "${_orderDatails.car_id}", //*
      "amount": "${_orderDatails.price}", //*
      "duration": "${_orderDatails.duration}", //*
      "shipping_address": "$_shippingAddress", //*
      "order_schedule": "${_orderDatails.serialize_dateTime}", //*
      "payment_method": " $_payMethod ", //*
      "paid_amount": "${_orderDatails.price}", //*
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

  void _goToLoginTab(BuildContext context, int tabPosition) async {
    Navigator.of(context)
        .push(
          new MaterialPageRoute(
              builder: (_) => new LoginTab(
                    tabPosition: tabPosition,
                  )),
        )
        .then((val) => val ? _loadPref() : null);
  }
}

class _ShippingAddress {
  final String first_name;
  final String last_name;
  final String email;
  final String phone;
  final String street;
  final String area;
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
      this.area,
      this.block,
      this.building,
      this.avenue,
      this.apartment,
      this.floor});

  Map toJson() {
    return {
      'contact_details': {
        'first_name': '$first_name',
        'last_name': '$last_name',
        'email': '$email',
        'phone': '$phone'
      },
      "address_details": {
        "street": "$street",
        "area": "$area",
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
  var area;
  var block;
  var building;
  var avenue;
  var apartment;
  var floor;
  var additional_direction = "No direction";

  AddressDetails(this.street, this.area, this.block, this.building, this.avenue,
      this.apartment, this.floor);

  @override
  String toString() {
    return 'AddressDetails{street: $street, area: $area, block: $block, building: $building, avenue: $avenue, apartment: $apartment, floor: $floor, additional_direction: $additional_direction}';
  }
}

class OrderDatails {
  String user_id;
  String user_fstName;
  String user_lstName;
  String user_email;
  String serialize_dateTime;
  String car_name;
  String car_id;
  String service_nature;
  String service_name;
  String service_id;
  var serialize_addons_id;
  String price;
  String duration;

  OrderDatails(
      this.user_id,
      this.user_fstName,
      this.user_lstName,
      this.user_email,
      this.serialize_dateTime,
      this.car_name,
      this.car_id,
      this.service_nature,
      this.service_name,
      this.service_id,
      this.serialize_addons_id,
      this.price,
      this.duration);

  @override
  String toString() {
    return 'OrderDatails{user_id: $user_id, user_name: $user_fstName $user_lstName, user_email: $user_email, serialize_dateTime: $serialize_dateTime, car_name: $car_name, car_id: $car_id, service_nature: $service_nature, service_name: $service_name, service_id: $service_id, serialize_addons_id: $serialize_addons_id, price: $price, duration: $duration}';
  }
}
