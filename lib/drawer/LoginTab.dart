import 'package:flutter/material.dart';
import 'package:flutter_app_x/drawer/GuestLoginPage.dart';
import 'package:flutter_app_x/drawer/LoginPage.dart';
import 'package:flutter_app_x/localization/AppTranslations.dart';

class LoginTab extends StatefulWidget {
  @override
  _LoginTabState createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Container(
            padding: EdgeInsets.only(top: 30.0),
            color: Colors.teal,
            child: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: AppTranslations.of(context).text("login"),),
                Tab(text: AppTranslations.of(context).text("guest_login"),),
              ],
            ),
          ),
       // title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            new LoginPage(),
            new GuestLogin(),
          ],
        ),
      ),
    );
  }
}
