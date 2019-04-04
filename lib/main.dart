import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_x/components/loginInput.dart';
import 'package:flutter_app_x/drawer/AddressBook.dart';
import 'package:flutter_app_x/localization/AppTranslationsDelegate.dart';
import 'package:flutter_app_x/localization/Application.dart';
import 'package:flutter_app_x/pref/UserPref.dart';
import 'package:flutter_app_x/drawer/LoginTab.dart';
import 'package:flutter_app_x/screens/d_ServiceNature.dart';
import 'package:flutter_app_x/screens/fa_AddressForm.dart';
import 'package:flutter_app_x/screens/da_SubsOneTime.dart';
import 'package:flutter_app_x/drawer/LoginPage.dart';
import 'package:flutter_app_x/screens/db_SubsMonthly.dart';
import 'package:flutter_app_x/screens/e_CheckOut.dart';
import 'package:flutter_app_x/screens/f_PickMap.dart';
import 'package:flutter_app_x/screens/a_SelectCars.dart';
import 'package:flutter_app_x/screens/b_SelectService.dart';
import 'package:flutter_app_x/screens/g_SuccessPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    UserPref.savePref('lang_code', 'en');
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
            ? Cars()
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
