import 'dart:async';

import 'package:carspa/localization/Application.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'a_SelectCars.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  @override
  void initState() {
    super.initState();
    // loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Cars()));
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        body: new Center(
            child: Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      width: 300.0,
                      height: 300.0,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.contain,
                            image: new AssetImage('assets/launcher/logo.png'),
                          )
                      )
                  ),
                  new SpinKitChasingDots(color: Colors.teal),
                  new SizedBox(height: 20,),
                  new Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3.0,
                              color: Colors.teal,


                            ),
                          ),
                          height: 50.0,
                          child: MaterialButton(
                            height: 50.0,
                            padding: EdgeInsets.all(2.0),
                            color: Colors.white,
                            child: new Text('English',
                                style: new TextStyle(fontSize: 16.0,
                                    color: Colors.teal)),
                            onPressed: () {
                              UserStringPref.savePref('lang_code', 'en');
                              application.onLocaleChanged(Locale(
                                  languagesMap['English']));

                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                  builder: (context) => Cars()));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide( //                   <--- left side
                                color: Colors.teal,
                                width: 3.0,
                              ),
                              top: BorderSide( //                    <--- top side
                                color: Colors.teal,
                                width: 3.0,
                              ),
                              right: BorderSide( //                    <--- top side
                                color: Colors.teal,
                                width: 3.0,
                              ),

                            ),
                          ),
                          height: 50.0,
                          child: MaterialButton(
                            height: 50.0,
                            padding: EdgeInsets.all(2.0),
                            color: Colors.white,
                            child: new Text('Arabic',
                                style: new TextStyle(fontSize: 16.0,
                                    color: Colors.teal)),
                            onPressed: () {
                              UserStringPref.savePref('lang_code', 'ar');
                              application.onLocaleChanged(Locale(
                                  languagesMap['Arabic']));

                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                  builder: (context) => Cars()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  //SpinKitWave(color: Colors.white, size: 30.0, type: SpinKitWaveType.start),
                ],
              ),
            )
        )
    );
  }
}
