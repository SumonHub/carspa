import 'dart:convert';

import 'package:carspa/api/ApiConstant.dart';
import 'package:carspa/api/ApiHelperClass.dart';
import 'package:carspa/components/Avatar.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:carspa/screens/c_ServiceDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SelectService extends StatelessWidget {
  /*
  * Post Request with Cartype_id
  *
  * */
  Future<List<Service>> fetchService() async {
    var _locale = await UserStringPref.getPref('lang_code');
    if (_locale == 0 || _locale == 'en') {
      _locale = "?locale=en";
    } else {
      _locale = '?locale=ar';
    }

    List<Service> serviceList = [];
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String car_type_id =
        _pref.getString('car_type_id') ?? 'car_type_id empty in pref';
    var _bodyData = {
      "car_type_id": car_type_id,
    };
    var response =
        await http.get(ApiConstant.SERVICE_API + _locale + '&car_type_id=1');
    print('ApiConstant.SERVICE_API : ${ApiConstant.SERVICE_API}');
    var jsonResponse = json.decode(response.body);
    var data = jsonResponse['data'];
    for (var u in data) {
      Service service = new Service(
          u['service_id'],
          u['duration'] as String,
          u['one_time_price'] as String,
          u['subscription_price'] as String,
          u['addons_id'] as String,
          u['image'] as String,
          u['service_name'] as String,
          u['description'] as String);

      serviceList.add(service);
    }
    print('ServiceList API response : ${data}');
    return serviceList;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: new Text(
          AppTranslations.of(context).text("select_service"),
        ),
      ),
      body: new Container(
        padding: new EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder(
            future: fetchService(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              print(snapshot.data);
              return snapshot.hasData
                  ? ServiceList(
                serviceList: snapshot.data,
              )
                  : Center(
                child: SpinKitPouringHourglass(color: Colors.teal),
              );
            }),
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
    return Column(
      children: <Widget>[
        Avatar('assets/photos/car.png'),
        new Expanded(
          child: new ListView.builder(physics: BouncingScrollPhysics(),
              itemCount: widget.serviceList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                    ),
                  ),
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

                        UserStringPref.savePref(
                            'service_id',
                            widget.serviceList[index].service_id
                                .toString());
                        UserStringPref.savePref('service_name',
                            widget.serviceList[index].service_name);
                        UserStringPref.savePref(
                            'duration', widget.serviceList[index].duration);
                        UserStringPref.savePref(
                            'price', widget.serviceList[index].price);
                        UserStringPref.savePref('subscription_price',
                            widget.serviceList[index].subscription_price);
                        UserStringPref.savePref('subscription_duration',
                            widget.serviceList[index].duration);
                        UserStringPref.savePref('description',
                            widget.serviceList[index].description);
                        UserStringPref.savePref(
                            'addons_serialized_id',
                            widget.serviceList[index]
                                .addons_serialized_id)
                            .toString();
                        UserStringPref.savePref('service_image',
                            widget.serviceList[index].image);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ServiceDetails()));
                      },
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(
                                    width: 1.0, color: Colors.black))),
                        child:
                        Icon(
                          Icons.directions_car,
                          color: Colors.teal,
                          size: 48.0,

                        ),
                      ),
                      title: Text(
                        widget.serviceList[index].service_name,
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.normal,
                            fontSize: 22.0),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          /*Icon(Icons.linear_scale,
                                  color: Colors.yellowAccent),*/
                          Text(AppTranslations.of(context).text("service_type"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0
                              ))
                        ],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right,
                          color: Colors.black26, size: 60.0)
                  ),
                );
              }),
        )
      ],
    );
  }
}
