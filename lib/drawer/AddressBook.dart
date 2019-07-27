import 'dart:convert';

import 'package:carspa/api/ApiConstant.dart';
import 'package:carspa/api/ApiHelperClass.dart';
import 'package:carspa/drawer/FullScreenDialog.dart';
import 'package:carspa/drawer/LoginTab.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddressBook extends StatefulWidget {
  @override
  _AddressBookState createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  bool _isLogin = false;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: new Text(AppTranslations.of(context).text('address_book')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute<DismissDialogAction>(
                builder: (BuildContext context) => FullScreenDialog(),
                fullscreenDialog: true,
              ));
        },
        child: Icon(Icons.add),
      ),
      body: _isLogin
          ? Container(
              padding: new EdgeInsets.all(12.0),
              child: FutureBuilder(
                  future: fetchAddress(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    print(snapshot.data);
                    return snapshot.hasData
                        ? AddressList(
                            addressBooks: snapshot.data,
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          );
                  }),
            )
          : Center(
              child: MaterialButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        new MaterialPageRoute(
                            builder: (_) => new LoginTab(
                                  tabPosition: 0,
                                )),
                      )
                      .then((value) => value ? _checkIsLogin() : null);
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

  Future<List<Address_Book>> fetchAddress() async {
    print('---------------> AddressBook/fetchAddress() end <----------------');
    var _token = await UserStringPref.getPref('token');
    var customer_id = await UserStringPref.getPref('user_id');
    List<Address_Book> _addressBooks = new List();
    final response = await http.get(
      ApiConstant.GET_CUSTOMER_ADDRESS + '?customer_id=$customer_id',
      headers: {"Authorization": "Bearer $_token"},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      var data = jsonResponse['data'];
      print('GET_CUSTOMER_ADDRESS response : $data');

      for (var u in data) {
        Address_Book address = new Address_Book(
          id: u['id'].toString(),
          customer_id: u['customer_id'].toString(),
          address_name: u['address_name'],
          selected_area_id: u['selected_area_id'].toString(),
          phone_number: u['phone_number'],
          area_name: u['area_name'],
          street: u['street'],
          block: u['block'],
          building: u['building'],
          avenue: u['avenue'],
          apartment: u['apartment'],
          floor: u['floor'],
        );
        _addressBooks.add(address);
      }
    }
    print(
        '---------------> _addressBooks length : ${_addressBooks.length} <----------------');
    print(
        '---------------> GET_CUSTOMER_ADDRESS/fetchAddress() end <----------------');
    return _addressBooks.reversed.toList();
  }

  Future _checkIsLogin() async {
    var _token = await UserStringPref.getPref('token');
    if (_token == 0) {
      setState(() {
        _isLogin = false;
      });
    } else {
      setState(() {
        _isLogin = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIsLogin().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }
}

class AddressList extends StatefulWidget {
  List<Address_Book> addressBooks = [];

  AddressList({Key key, this.addressBooks}) : super(key: key);

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  Widget buildText(String key, String value) {
    return new Expanded(
        flex: 0,
        child: Container(
          // margin: EdgeInsets.only(left: 60.0, right: 12.0),
          padding: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
              //  border: Border(bottom: BorderSide(color: Colors.red),),
              ),
          child: new Row(
            children: <Widget>[
              new Expanded(
                flex: 1,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text(
                      '$key',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  width: 50,
                  child: new Icon(
                    Icons.label,
                    color: Colors.white,
                  ),
                ),
              ),
              new Expanded(
                flex: 1,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      '''$value''',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return widget.addressBooks.isEmpty
        ? new Center(
            child: Text(
              AppTranslations.of(context).text("empty_msg"),
              style: const TextStyle(
                color: Colors.white,
                letterSpacing: 5.0,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : new ListView.builder(
            shrinkWrap: true,
            itemCount: widget.addressBooks.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  elevation: 11.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: Colors.teal),
                        child: ListTile(
                          onTap: () {
                            _addAddressLocally(index);
                            Navigator.pop(context, true);
                          },
                          onLongPress: null,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          title: new Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      buildText(
                                          AppTranslations.of(context)
                                              .text("address"),
                                          '${widget.addressBooks[index].address_name}'),
                                      buildText(
                                          AppTranslations.of(context)
                                              .text("area_name"),
                                          '${widget.addressBooks[index].area_name}'),
                                      buildText(
                                          AppTranslations.of(context)
                                              .text("street"),
                                          '${widget.addressBooks[index].street}'),
                                      buildText(
                                          AppTranslations.of(context)
                                              .text("block"),
                                          '${widget.addressBooks[index].block}'),
                                      buildText(
                                          AppTranslations.of(context)
                                              .text("building"),
                                          '${widget.addressBooks[index].building}'),
                                      buildText(
                                          AppTranslations.of(context)
                                              .text("avenue"),
                                          '${widget.addressBooks[index].avenue}'),
                                      buildText(
                                          AppTranslations.of(context)
                                              .text("apartment"),
                                          '${widget.addressBooks[index].apartment}'),
                                      buildText(
                                          AppTranslations.of(context)
                                              .text("floor"),
                                          '${widget.addressBooks[index].floor}'),
                                      buildText(
                                          AppTranslations.of(context)
                                              .text("phone"),
                                          '${widget.addressBooks[index].phone_number}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ));
            });
  }

  void _addAddressLocally(int index) {
    var _address = widget.addressBooks[index];

    UserStringPref.savePref('street', '${widget.addressBooks[index].street}');
    UserStringPref.savePref('area', '${_address.area_name}');
    UserStringPref.savePref('block', '${_address.block}');
    UserStringPref.savePref('building', '${_address.building}');
    UserStringPref.savePref('avenue', '${_address.avenue}');
    UserStringPref.savePref('apartment', '${_address.apartment}');
    UserStringPref.savePref('floor', '${_address.floor}');
  }
}
