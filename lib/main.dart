import 'dart:io';

import 'package:carspa/localization/AppTranslationsDelegate.dart';
import 'package:carspa/localization/Application.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/SplashScreen.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTranslationsDelegate _newLocaleDelegate;

  bool checkConnection = false;

  Future<bool> _isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('check Internet Connection : connected');
        setState(() {
          checkConnection = true;
        });
      }
    } on SocketException catch (_) {
      print('check Internet Connection : not connected');
      setState(() {
        checkConnection = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    UserStringPref.savePref('lang_code', 'en');
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
    _isConnected();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          _newLocaleDelegate,
          const AppTranslationsDelegate(),
          //provides localised strings
          GlobalMaterialLocalizations.delegate,
          //provides RTL support
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: application.supportedLocales(),
        title: "CARSPA",
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: checkConnection
            ? SplashScreen()
            : Scaffold(
                body: Center(
                  child: Text('No internet connection!'),
                ),
              )

        //LoginPage()
        // MapsDemo()
        // OrderCompletaion()
        // PickMap()
        // SubsMonthly()
        // AddressForm()
        // SuccessPage()
        // LoginTab()
        // SubsOneTime()
        //  AddressBook()
        // ServiceNature()

        );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}
