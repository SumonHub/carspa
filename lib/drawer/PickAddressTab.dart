import 'package:flutter/material.dart';
import 'package:flutter_app_x/drawer/AddressBook.dart';
import 'package:flutter_app_x/screens/f_PickMap.dart';

class PickAddressTab extends StatefulWidget {
  @override
  _PickAddressTabState createState() => _PickAddressTabState();
}

class _PickAddressTabState extends State<PickAddressTab> {
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
                Tab(text: 'AddressBook',),
                Tab(text: 'PickMap',),
              ],
            ),
          ),
          // title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            new AddressBook(),
            new PickMap(),
          ],
        ),
      ),
    );
  }
}
