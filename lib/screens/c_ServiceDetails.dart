import 'dart:async';
import 'dart:convert';

import 'package:carspa/api/ApiConstant.dart';
import 'package:carspa/api/ApiHelperClass.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:carspa/screens/d_ServiceNature.dart';
import 'package:carspa/screens/da_SubsOneTime.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceDetails extends StatefulWidget {
  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  //Duration delay = const Duration(milliseconds: 200);
  bool isLoading = true;

  String service_name;
  String addons_id; // serialized
  String duration;
  String price;
  String subscription_price;
  String description;

  // String addons_serialized_id;
  String service_image;
  List _selectedAddonsId = new List();
  List<Addons> _addonsList = new List();

  Future<List<Addons>> fetchData() async {
    var _locale = await UserStringPref.getPref('locale');
    _locale==0? _locale='?locale=en': null;
    print('---------> fetchData() <------------');

    List<Addons> addonsList = new List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var addons_serialized_id = (prefs.getString('addons_serialized_id') ?? 0);
    print('addons_serialized_id : $addons_serialized_id');

    print(
        'ApiConstant.UNSERIALIZED_STRING : ${ApiConstant.UNSERIALIZED_STRING}');
    var response = await http.post(ApiConstant.UNSERIALIZED_STRING, body: {
      "serialize_string": '$addons_serialized_id',
    });
    var jsonResponse = json.decode(response.body);
    List data = jsonResponse['data'];
    print('addons_unserialized_id : $data');
    print('addons_unserialized_id length : ${data.length}');
    if (data.length != 0) {
      for (int i = 0; i < data.length; i++) {
        String addons_id = '?addons_id=${data[i]}';
        var response = await http.get(ApiConstant.ADD_ONS+ addons_id);

        var jsonResponse = json.decode(response.body);
        var addons = jsonResponse['data'];
        print(' addons response : $addons');
        for (var u in addons) {
          Addons addons = new Addons(
              u['id'].toString(), u['duration'], u['price'], u['addons_name']);
          print('addons $i: ${addons.toString()}');
          addonsList.add(addons);
        }
      }
    } /*else {
      addonsList.add(new Addons('1', '10.00', '20.00', 'test add1'));
      addonsList.add(new Addons('2', '30.00', '40.00', 'test add2'));
      addonsList.add(new Addons('3', '50.00', '60.00', 'test add3'));
    }*/

    setState(() {
      print('---------> fetchData() <------------');
      _addonsList = addonsList;
    });
  }

  //Loading counter value on start
  _loadPref() async {
    print('---------> _loadPref() <------------');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      service_name = (prefs.getString('service_name') ?? 0);
      duration = (prefs.getString('duration') ?? 0);
      price = (prefs.getString('price') ?? 0);
      subscription_price = (prefs.getString('subscription_price') ?? '');
      description = (prefs.getString('description') ?? 0);
      // addons_serialized_id = (prefs.getString('addons_serialized_id') ?? 0);
      service_image = (prefs.getString('service_image') ?? 0);
    });
  }

  void _saveSelectedAddons(List selectedAddonsId) async {
    if (selectedAddonsId.isNotEmpty) {
      var body = jsonEncode(selectedAddonsId);
      var response = await http.post(
        ApiConstant.ARRAY_TO_STRING,
        body: {'serialize_array': '$body'},
      );
      var jsonResponse = json.decode(response.body);
      var data = jsonResponse['data'];

      UserStringPref.savePref('serialize_addons', data.toString());
      //  UserStringPref.savePref('_addons_id', selectedAddonsId.toString().replaceAll("[", "").replaceAll("]", "").trim());

    }
    else {
      // UserStringPref.savePref('_addons_id', "empty");
      UserStringPref.savePref('serialize_addons', '');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPref();
    fetchData();

    const timeOut = const Duration(seconds: 1);
    new Timer(timeOut, () {
      setState(() => isLoading = false);
    });
  }

  void _onAddonsSelected(bool selected, addons_id, int index) {

    var initDuration = double.parse(_addonsList[index].duration).abs();
    var addonsDuration = double.parse(duration).abs();
    var initPrice = double.parse(_addonsList[index].price).abs();
    var addonsPrice = double.parse(price).abs();

    var _addDuration = initDuration+addonsDuration;
    var _addPrice = initPrice+addonsPrice;
    var _subDuration = initDuration-addonsDuration;
    var _subPrice = initPrice-addonsPrice;

    UserStringPref.saveBoolPref('hasAddons', selected);
    if (selected == true) {
      setState(() {
        UserStringPref.savePref('addons_name', _addonsList[index].addons_name);
        UserStringPref.savePref('addons_duration', _addonsList[index].duration);
        UserStringPref.savePref('addons_price', _addonsList[index].price);


        _selectedAddonsId.add(addons_id);
        duration = _addDuration.abs().toString();
        price = _addPrice.abs().toString();
      });
    } else {
      setState(() {
        _selectedAddonsId.remove(addons_id);
        duration = _subDuration.abs().toString();
        price = _subPrice.abs().toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: new Text(AppTranslations.of(context).text("services_details")),
      ),
      bottomNavigationBar: isLoading ? null : new BottomAppBar(
        child: FlatButton(
          color: Colors.white,
          child: new Text(
            AppTranslations.of(context).text("continue"),
            style: const TextStyle(
              color: Colors.black,
              letterSpacing: 5.0,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            /*
            * save addond id, duration, price
            *
            * */

            _saveSelectedAddons(_selectedAddonsId);


            UserStringPref.savePref('duration', duration);
            UserStringPref.savePref('price', price);

            if (subscription_price == '') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SubsOneTime()));
            } else {
              UserStringPref.savePref('subscription_price', subscription_price);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ServiceNature()));
            }

            /* Navigator.push(context,
                MaterialPageRoute(builder: (context) => ServiceNature()));*/
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : new ListView(
              children: <Widget>[
                new Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox.fromSize(
                      size: Size.fromHeight(
                          MediaQuery.of(context).size.height * 0.33),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            // margin: EdgeInsets.only(top: 24.0),
                            child: Material(
                              // elevation: 10.0,
                              borderRadius: BorderRadius.circular(6.0),
                              /*  shadowColor: Colors.white,
                        color: Colors.white,*/
                              child: InkWell(
                                // onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItemReviewsPage())),
                                //  child: Image.asset('assets/car.png'),
                                child: Image.network(
                                    ApiConstant.IMAGE_BASE_URL + service_image),
                              ),
                            ),
                          ),

                          /// Item description inside a material
                          Container(
                            color: Colors.white24,

                            // margin: EdgeInsets.only(top: 24.0),
                            child: Material(
                              // elevation: 10.0,
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white54,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    /// Title and rating
                                    Container(
                                      height: 30.0,
                                      // padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                                      child: ListTile(
                                        leading: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 12.0),
                                          decoration: new BoxDecoration(
                                              border: new Border(
                                                  right: new BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black54))),
                                          child: Icon(Icons.title,
                                              color: Colors.black),
                                        ),
                                        title: Text(
                                          '$service_name',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                      ),
                                    ),

                                    Container(
                                      height: 30.0,
                                      // padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                                      child: ListTile(
                                        leading: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 12.0),
                                          decoration: new BoxDecoration(
                                              border: new Border(
                                                  right: new BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black54))),
                                          child: Icon(Icons.timer,
                                              color: Colors.black),
                                        ),
                                        title: Text(
                                          '${AppTranslations.of(context).text("duration")}: $duration',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    Container(
                                      height: 30.0,
                                      // padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                                      child: ListTile(
                                        leading: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 12.0),
                                          decoration: new BoxDecoration(
                                              border: new Border(
                                                  right: new BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black54))),
                                          child: Image.asset('assets/photos/price.png',width: 24.0,height: 24.0, ),
                                        ),
                                        title: Text(
                                          //'$price',
                                          '${'${AppTranslations.of(context).text("price")}: $price'} ${subscription_price!=''?'|| ${AppTranslations.of(context).text("subscription_price")}: $subscription_price':''}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
                // ------->description<----------------//
                new Container(
                    padding: EdgeInsets.only(
                      top: 12.0,
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(
                                    width: 1.0, color: Colors.white24))),
                        child: Icon(Icons.format_align_justify,
                            color: Colors.white),
                      ),
                      title: Text(
                        '$description',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                    )),
                // ------->addons<----------------//
                new ListView.builder(
                    padding: EdgeInsets.only(bottom: 12.0),
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _addonsList.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Container(
                        // color: Colors.white,
                        margin: EdgeInsets.only(left: 12.0),
                        height: 60.0,
                        child: CheckboxListTile(
                          value: _selectedAddonsId
                              .contains(_addonsList[index].addons_id),
                          onChanged: (bool selected) {

                            var a = double.parse(_addonsList[index].duration);
                            var aa = double.parse(duration);
                            var b = double.parse(_addonsList[index].price);
                            var bb = double.parse(price);

                            var aaa = a+aa;
                            var aaaa = a-aa;
                            var bbb = b+bb;
                            var bbbb= b-bb;

                            print('\n${a.toString()} + ${aa.toString()} = ${aaa.toString()}\n'
                                  '${a.toString()} - ${aa.toString()} = ${aaaa.toString()}\n'
                                ' ${b.toString()} + ${bb.toString()} = ${bbb.toString()}\n'
                                '${b.toString()} - ${bb.toString()} = ${bbbb.toString()}\n'
                                );


                            _onAddonsSelected(
                                selected, _addonsList[index].addons_id, index);
                          },
                          title: new Text(
                            _addonsList[index].addons_name,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          subtitle: new Text(
                            '${AppTranslations.of(context).text("price")}: ${_addonsList[index].price} | ${AppTranslations.of(context).text("duration")}: ${_addonsList[index].duration}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          activeColor: Colors.white,
                        ),
                      );
                    })
              ],
            ),
    );
  }
}
