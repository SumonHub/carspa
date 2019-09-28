import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'a_SelectCars.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Cars()));
  }

//assets/photos/logo.png
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.teal,
        body: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  width: 300.0,
                  height: 300.0,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.contain,
                        image: new AssetImage('assets/launcher/logo.png'),
                      ))),
              SpinKitWave(
                  color: Colors.white, size: 30.0, type: SpinKitWaveType.start),
            ],
          ),
        ));
  }
}
