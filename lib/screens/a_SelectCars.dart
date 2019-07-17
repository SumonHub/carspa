import 'dart:async';
import 'dart:convert';

import 'package:carspa/api/ApiConstant.dart';
import 'package:carspa/api/ApiHelperClass.dart';
import 'package:carspa/drawer/AddressBook.dart';
import 'package:carspa/drawer/LoginTab.dart';
import 'package:carspa/drawer/a_Profile.dart';
import 'package:carspa/drawer/b_OrderHistoryPage.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/localization/Application.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:carspa/screens/b_SelectService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Cars extends StatefulWidget {
  @override
  _CarsState createState() => _CarsState();
}

class _CarsState extends State<Cars> {
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  void _chooseLangAction(String language) {
    if (language == 'English') {
      UserStringPref.savePref('lang_code', 'en');
    } else {
      UserStringPref.savePref('lang_code', 'ar');
    }
    application.onLocaleChanged(Locale(languagesMap[language]));
  }

  Future<List<CarType>> fetchCars() async {
    print('-------------Cars / fetchCars() start ------------------');

    var _locale = await UserStringPref.getPref('lang_code');
    if (_locale == 0 || _locale == 'en') {
      _locale = "?locale=en";
    } else {
      _locale = '?locale=ar';
    }
    List<CarType> carList = [];
    var url = ApiConstant.SELECT_CARS_API + _locale;
    print('fetchCars api url : $url');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var data = jsonResponse['data'];
      for (var u in data) {
        CarType car = new CarType(
            id: u['id'],
            name: u['name'] as String,
            carImage: u['image']);
        carList.add(car);
      }
      print('carList.length : ${carList.length}');
    }
    print('------------- Cars / fetchCars() end ------------------');
    return carList;
  }

  @override
  void initState() {
    super.initState();
    print('-------------Cars / initState() ------------------');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
          title: new Text(
            AppTranslations.of(context).text("select_cars"),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Center(
                      child: Text(
                    'En/Ar',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
                onSelected: _chooseLangAction,
                itemBuilder: (BuildContext context) {
                  return languagesList.map((language) {
                    return PopupMenuItem<String>(
                        value: language, child: Text(language));
                  }).toList();
                }),
          ],
          // title: new Text("Cars Type"),//
        ),
        drawer: Drawer(
          child: new AppDrawer(),
        ),
        body: FutureBuilder(
            future: fetchCars(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              print(snapshot.data);
              return snapshot.hasData
                  ? CarTypeList(
                      carList: snapshot.data,
                    )
                  : SpinKitPouringHourglass(color: Colors.white);
            }));
  }
}

class CarTypeList extends StatelessWidget {
  final List<CarType> carList;

  const CarTypeList({Key key, this.carList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: carList.length,
        itemBuilder: (BuildContext context, int index) {
          return new Stack(
            children: <Widget>[
              GestureDetector(
                child: Container(
                    margin:
                        new EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new CarItem(
                            carList[index].name, carList[index].carImage),
                      ],
                    )),
                onTap: () async {
                  // _save(carList[index].id);

                  await UserStringPref.savePref(
                      'car_type_id', carList[index].id.toString());
                  await UserStringPref.savePref(
                      'car_type_name', carList[index].name);

                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SelectService()));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class CarItem extends StatelessWidget {
  CarItem(this._carName, this._carImage);

  String _carName;
  String _carImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0, top: 16.0),
      child: Stack(
        children: <Widget>[
          /// Item card
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox.fromSize(
                size: Size.fromHeight(172.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    /// Item description inside a material
                    Container(
                      // margin: EdgeInsets.only(top: 24.0),
                      child: Material(
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(12.0),
                        shadowColor: Color(0x802196F3),
                        color: Colors.white70,
                        child: InkWell(
                          child: Image.network(
                              ApiConstant.IMAGE_BASE_URL + _carImage),
                        ),
                      ),
                    ),
                  ],
                )),
          ),

          /// Review
          Padding(
            padding: EdgeInsets.only(top: 160.0, left: 32.0),
            child: Material(
              elevation: 12.0,
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              child: Container(
                child: Container(
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(
                                  width: 1.0, color: Colors.white24))),
                      child: Icon(Icons.directions_car, color: Colors.white),
                    ),
                    title: Text(
                      _carName,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.linear_scale, color: Colors.yellowAccent),
                        Text(AppTranslations.of(context).text("car_type"),
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => new _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var _isLogin = false;

  _getLoginFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _isLogin = (prefs.getBool('isLogin') ?? false);
    setState(() {
      _isLogin = _isLogin;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLoginFeed();
    print('---------------------------------------------');
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            /*  accountName: new Text('ggg'),
            accountEmail: new Text('gggg'),*/
            decoration: BoxDecoration(
              color: Colors.black,
              // backgroundBlendMode: BlendMode.colorBurn,
              image:
                  DecorationImage(image: AssetImage('assets/photos/base.png')),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.teal,
            ),
            title: Text(AppTranslations.of(context).text("home")),
            onTap: () {
              // close the drawer
              Navigator.pop(context);

              /*// Than Update the state of the app
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profile('Profile')));*/
            },
          ),
          Divider(
            color: Colors.teal,
            height: 16.0,
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_cart,
              color: Colors.teal,
            ),
            title: Text(AppTranslations.of(context).text("your_order")),
            onTap: () {
              // close the drawer
              Navigator.pop(context);

              // Than Update the state of the app
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrderHistoryPage()));
            },
          ),
          Divider(
            color: Colors.teal,
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Colors.teal,
            ),
            title: Text(AppTranslations.of(context).text("profile")),
            onTap: () {
              // close the drawer
              Navigator.pop(context);
              // Than Update the state of the app
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(
                          AppTranslations.of(context).text("profile"))));
            },
          ),
          Divider(
            color: Colors.teal,
            height: 16.0,
          ),
          ListTile(
            leading: Icon(
              Icons.directions,
              color: Colors.teal,
            ),
            title: Text(AppTranslations.of(context).text("address_book")),
            onTap: () {
              // close the drawer
              Navigator.pop(context);
              // Than Update the state of the app
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddressBook()));
            },
          ),
          Divider(
            color: Colors.teal,
          ),
          ListTile(
            leading: Icon(
              Icons.vpn_key,
              color: Colors.red,
            ),
            title: Text(AppTranslations.of(context)
                .text(_isLogin ? "logout" : "login")),
            onTap: () {
              // Update the state of the app
              // close the drawer
              Navigator.pop(context);

              UserStringPref.clearAll();

              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LoginTab()));
              // Then close the drawer
              // Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
