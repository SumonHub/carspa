import 'package:flutter/material.dart';
import 'package:flutter_app_x/components/Avatar.dart';
import 'package:flutter_app_x/drawer/b_OrderHistoryPage.dart';
import 'package:flutter_app_x/localization/AppTranslations.dart';
import 'package:flutter_app_x/screens/a_SelectCars.dart';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Container(
        width: MediaQuery.of(context).size.width,
        // color: Colors.redAccent,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Avatar('assets/photos/done.png'),
            Center(
              child: new Container(
                width: 300.0,
                //  color: Colors.redAccent,
                child: new Text(
                  AppTranslations.of(context).text("success_order_msg"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 5.0,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            new Container(
              //  width: MediaQuery.of(context).size.width*0.40,
              width: 200.0,
              margin: EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                child: new Text(
                  AppTranslations.of(context).text("home"),
                  style: const TextStyle(
                    color: Colors.black,
                    letterSpacing: 5.0,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  /* Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Cars()));*/
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Cars()),
                      (Route<dynamic> route) => false);
                },
                elevation: 4.0,
                minWidth: double.infinity,
                height: 48.0,
                color: Colors.white,
              ),
            ),
            new Container(
              width: 250.0,
              margin: EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                child: new Text(
                  AppTranslations.of(context).text("order_history"),
                  style: const TextStyle(
                    color: Colors.black,
                    letterSpacing: 5.0,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderHistoryPage()),
                      ModalRoute.withName('/'));
                },
                elevation: 4.0,
                minWidth: double.infinity,
                height: 48.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
