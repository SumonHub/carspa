import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_x/api/ApiConstant.dart';
import 'package:flutter_app_x/api/ApiHelperClass.dart';
import 'package:flutter_app_x/pref/UserPref.dart';
import 'package:flutter_app_x/screens/d_ServiceNature.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

/*
class ServiceDetails extends StatefulWidget {
  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {


  Future<List<Addons>> fetchData() async {

    List<Addons> addonsList = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var addons_serialized_id = (prefs.getString('addons_serialized_id') ?? 0);
    print('addons_serialized_id : $addons_serialized_id');

    print('ApiConstant.UNSERIALIZED_STRING : ${ApiConstant.UNSERIALIZED_STRING}');
    var response = await http.post(ApiConstant.UNSERIALIZED_STRING, body: {
      "serialize_string": "$addons_serialized_id",
    });
    var jsonResponse = json.decode(response.body);
    List data = jsonResponse['data'];
    print('addons_serialize_id : $data');
    print('addons_serialize_id length : ${data.length}');
    for (int i = 0; i < 2; i++) {
      String addons_id = '?addons_id=${data[i]}';
      var response =
          await http.get(ApiConstant.ADD_ONS +addons_id);

      var jsonResponse = json.decode(response.body);
      var addons = jsonResponse['data'];
      for (var u in addons) {
        Addons addons = new Addons(
            u['addons_id'], u['duration'], u['price'], u['addons_name']);
        print('addons $i: ${addons.toString()}');
        addonsList.add(addons);
      }
      print('addonsList.length : ${addonsList.length}');
   //   return addonsList;
    }
    return addonsList;
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: new Text("Service Details"),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, bottom: 12.0, top: 12.0),
        child: MaterialButton(
          child: new Text(
            "Continue",
            style: const TextStyle(
              color: Colors.black,
              letterSpacing: 5.0,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {



            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ServiceNature()));
          },
          elevation: 4.0,
          minWidth: double.infinity,
          height: 48.0,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            print(snapshot.data);
            return snapshot.hasData
                ? ServiceShowCase(snapshot.data)
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
          }),

      //ServiceShowCase(),
    );
  }
}

class ServiceShowCase extends StatefulWidget {
  List<Addons> addonsList = [];

  ServiceShowCase(this.addonsList);

  @override
  _ServiceShowCaseState createState() => _ServiceShowCaseState();
}

class _ServiceShowCaseState extends State<ServiceShowCase> {

  String service_name;
  String duration;
  String price;
  String description;
  String service_image;

  bool _value1 = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox.fromSize(
              size: Size.fromHeight(MediaQuery.of(context).size.height * 0.33),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    // margin: EdgeInsets.only(top: 24.0),
                    child: Material(
                      // elevation: 10.0,
                      borderRadius: BorderRadius.circular(6.0),
                      */
/*  shadowColor: Colors.white,
                        color: Colors.white,*//*

                      child: InkWell(
                        // onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItemReviewsPage())),
                        child: Image.asset('assets/car.png'),
                        //  child:  Image.network('assets/car.png'),
                      ),
                    ),
                  ),

                  /// Item description inside a material
                  Container(
                    color: Colors.white54,

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
                                  child: Icon(Icons.title, color: Colors.black),
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
                                  child: Icon(Icons.timer, color: Colors.black),
                                ),
                                title: Text(
                                  '${double.parse(duration)}',
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
                                  child: Icon(Icons.monetization_on,
                                      color: Colors.black),
                                ),
                                title: Text(
                                  //'$price',
                                  '${double.parse(price)}' ,
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
        Container(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: Icon(Icons.format_align_justify, color: Colors.white),
            ),
            title: Text(
              '$description',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
          ),
        ),

        // ------->addons<----------------//
        new ListView.builder(
            padding: EdgeInsets.only(bottom: 12.0),
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.addonsList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return new Container(
               // color: Colors.white,
                height: 60.0,
                child: CheckboxListTile(

                  value: _value1,
                  onChanged: (value) {
                    setState(() {
                      // UserPref.savePref(duration, duration+widget.addonsList[index].duration);
                      return _value1 = value;
                    });
                  },
                  title: new Text(widget.addonsList[index].addons_name,
                    style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  controlAffinity: ListTileControlAffinity.leading,
                  subtitle: new Text(
                      'Price: ${widget.addonsList[index].price} | Duration: ${widget.addonsList[index].duration}',
                    style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  activeColor: Colors.white,

                ),
              );
            }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  //Loading counter value on start
  _loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      service_name = (prefs.getString('service_name') ?? 0);
      duration = (prefs.getString('duration') ?? 0);
      price = (prefs.getString('price') ?? 0);
      description = (prefs.getString('description') ?? 0);
      service_image = (prefs.getString('service_image') ?? 0);
    });
  }
}*/
