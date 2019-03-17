import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_x/api/ApiConstant.dart';
import 'package:flutter_app_x/components/Avatar.dart';
import 'package:flutter_app_x/localization/AppTranslations.dart';
import 'package:flutter_app_x/pref/UserPref.dart';
import 'package:flutter_app_x/screens/c_ServiceDetails.dart';
import 'package:flutter_app_x/screens/d_ServiceNature.dart';
import 'package:flutter_app_x/screens/c_Demo_ServiceDetails.dart';
import 'package:flutter_app_x/screens/da_SubsOneTime.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_x/api/ApiHelperClass.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SelectService extends StatelessWidget {
  /*
  * Post Request with Cartype_id
  *
  * */
  Future<List<Service>> fetchService() async {
    var _locale = await UserPref.getPref('lang_code');
    if(_locale==0 || _locale=='en'){
      _locale = "?locale=en";
    }else{
      _locale = '?locale=ar';
    }

    List<Service> serviceList = [];
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String car_type_id = _pref.getString('car_type_id') ?? 'car_type_id empty in pref' ;
    var _bodyData = {
      "car_type_id": car_type_id,
    };
    var response = await http.get(ApiConstant.SERVICE_API+_locale+'&car_type_id=$car_type_id');
    print('ApiConstant.SERVICE_API : ${ApiConstant.SERVICE_API}');
    var jsonResponse = json.decode(response.body);
    var data = jsonResponse['data'];
    for (var u in data) {
      Service service = new Service(u['service_id'] as String , u['duration'] as String, u['one_time_price'] as String, u['subscription_price'] as String,
          u['addons_id'] as String, u['image'] as String, u['service_name'] as String, u['description'] as String);

      serviceList.add(service);
    }
    print('ServiceList API response : ${data}');
    return serviceList;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: new Text(AppTranslations.of(context).text("select_service"),),
      ),
      body: new Container(
        padding: new EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            //new Expanded(child: AvaterSection),
            Avatar('assets/photos/service.png'),
            FutureBuilder(
                future: fetchService(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  print(snapshot.data);
                  return snapshot.hasData
                      ? ServiceList(
                          serviceList: snapshot.data,
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                }),
          ],
        ),
      ),
    );
  }
}

class ServiceList extends StatefulWidget {
  ServiceList({Key key, this.serviceList}) : super(key: key);
  List<Service> serviceList = [];

  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new ListView.builder(
          itemCount: widget.serviceList.length,
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
                            /*
                            * save locally
                            *
                            * widget.serviceList[index].service_name
                            * widget.serviceList[index].service_name
                            *
                            * String service_id;
                              String duration;
                              String price;
                              String addons_id;
                              String image;
                              String service_name;
                              String description;
                            *
                            *
                            * */

                            /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectSubscriptionType()));*/

                            UserPref.savePref('service_id',  widget.serviceList[index].service_id);
                            UserPref.savePref('service_name',  widget.serviceList[index].service_name);
                            UserPref.savePref('duration',  widget.serviceList[index].duration);
                            UserPref.savePref('price',  widget.serviceList[index].price);
                            UserPref.savePref('subscription_price',  widget.serviceList[index].subscription_price);
                            UserPref.savePref('description',  widget.serviceList[index].description);
                            UserPref.savePref('addons_serialized_id',  widget.serviceList[index].addons_serialized_id);
                            UserPref.savePref('service_image',  widget.serviceList[index].image);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Details()));
                          },
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.white24))),
                            child:
                                Icon(Icons.directions_car, color: Colors.white),
                          ),
                          title: Text(
                            widget.serviceList[index].service_name,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                          subtitle: Row(
                            children: <Widget>[
                              Icon(Icons.linear_scale,
                                  color: Colors.yellowAccent),
                              Text(AppTranslations.of(context).text("service_type"),
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right,
                              color: Colors.white, size: 30.0)
                          /*trailing: new Checkbox(
                              value: widget.serviceList[index].isChecked,
                              onChanged: (bool value) {
                                ItemChange(value, index);
                              })),*/
                          ),
                    ),
                  ],
                ));
          }),
    );
  }
}