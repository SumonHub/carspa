import 'dart:convert';

import 'package:carspa/api/ApiConstant.dart';
import 'package:carspa/api/ApiHelperClass.dart';
import 'package:carspa/drawer/LoginTab.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistoryPage> {
  bool _isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: new Text(AppTranslations.of(context).text("your_order")),
      ),
      body: _isLogin
          ? FutureBuilder(
          future: fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            print(snapshot.data);
            return snapshot.hasData
                ? OrderList(
              orders: snapshot.data,
            )
                : Center(
              child: CircularProgressIndicator(
                valueColor:
                AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            );
          })
          : Center(
              child: MaterialButton(
                height: 44.0,
                color: Color(0xffe0e0e0),
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

  Future<List<OrderHistory>> fetchOrders() async {
    List<OrderHistory> orders = [];

    /*var uri = Uri.parse('http://test/testing');
    uri = uri.replace(query: 'user=x--------------------');
    print(uri);*/

    var customer_id = await UserStringPref.getPref('user_id');

    var response = await http.get(
        'http://carspa-kw.com/api/get-all-orders-by-id?customer_id=$customer_id');
    debugPrint(ApiConstant.SERVICE_API);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var data = jsonResponse['success'];
    for (var u in data) {
      OrderHistory order = new OrderHistory(
          service_name: u['service_name'],
          amount: u['amount'],
          order_type: u['order_type'],
          status: u['status'],
          created_at: u['created_at']);
      orders.add(order);
    }
    print(orders.length);
    return orders.reversed.toList();
  }

  @override
  void initState() {
    super.initState();
    _checkIsLogin();
  }

  void _checkIsLogin() async {
    var token = await UserStringPref.getPref('token');
    if (token != 0) {
      setState(() {
        _isLogin = true;
      });
    }
  }
}

class OrderList extends StatefulWidget {
  List<OrderHistory> orders = [];

  OrderList({Key key, this.orders}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  Widget buildText(String key, String value) {
    return new Expanded(
        flex: 0,
        child: Container(
          padding: EdgeInsets.all(3.0),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      '$key',
                      style: TextStyle(
                        color: Colors.black,
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
                    color: Colors.black,
                  ),
                ),
              ),
              new Expanded(
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      '''$value''',
                      style: TextStyle(
                        color: Colors.black,
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
    return widget.orders.isEmpty
        ? new Center(
            child: Text(
              AppTranslations.of(context).text("empty_msg"),
              style: const TextStyle(
                color: Colors.grey,
                letterSpacing: 5.0,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : new ListView.builder(
            itemCount: widget.orders.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                  elevation: 3.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: ListTile(
                          onTap: null,
                          title: Row(
                            children: <Widget>[
                              new Expanded(
                                child: new Column(
                                  children: <Widget>[
                                    buildText(
                                        AppTranslations.of(context)
                                            .text("service_name"),
                                        widget.orders[index].service_name),
                                    buildText(
                                        AppTranslations.of(context)
                                            .text("price"),
                                        widget.orders[index].amount),
                                    buildText(
                                        AppTranslations.of(context)
                                            .text("order_type"),
                                        widget.orders[index].order_type),
                                    buildText(
                                        AppTranslations.of(context)
                                            .text("order_status"),
                                        widget.orders[index].status),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ));
            });
  }
}
