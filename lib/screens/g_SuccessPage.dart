import 'package:carspa/components/Avatar.dart';
import 'package:carspa/drawer/b_OrderHistoryPage.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/screens/a_SelectCars.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 50),
            shrinkWrap: true,
            children: <Widget>[
              Center(
                child: new Avatar('assets/photos/logo_2nd.png'),
              ),
              Center(
                  child: Container(
                    width: 250.0,
                    child: new Text(
                      AppTranslations.of(context).text("success_order_msg"),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black54,
                        letterSpacing: 5.0,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
              ),
              SizedBox(height: 20.0,),
              Center(
                child: new CircleAvatar(
                  child: Image.asset(
                    'assets/photos/success.png',
                    color: Colors.teal,
                  ),
                  backgroundColor: Colors.white,
                  radius: 40.0,
                ),
              ),
              Center(
                child: new Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.teal,
                        width: 3
                    ),
                  ),
                  width: 250.0,
                  margin: EdgeInsets.only(top: 20.0),
                  child: MaterialButton(
                    height: 48.0,
                    color: Colors.white,
                    child: new Text(
                      AppTranslations.of(context).text("home"),
                      style: const TextStyle(
                        color: Colors.black54,
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
                  ),
                ),
              ),
              Center(
                child: new Container(
                  width: 250.0,
                  margin: EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.teal,
                        width: 3
                    ),
                  ),
                  child: MaterialButton(
                    height: 48.0,
                    color: Colors.white,
                    child: new Text(
                      AppTranslations.of(context).text("order_history"),
                      style: const TextStyle(
                        color: Colors.black54,
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
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}


/*
* ListView(
          children: <Widget>[

            Center(
              child: new Avatar('assets/photos/logo_2nd.png'),
            ),





          ],
        ),
        */
