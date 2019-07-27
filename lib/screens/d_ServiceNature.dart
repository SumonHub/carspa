import 'package:carspa/components/Avatar.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/screens/da_SubsOneTime.dart';
import 'package:carspa/screens/db_SubsMonthly.dart';
import 'package:flutter/material.dart';

class ServiceNature extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text(AppTranslations.of(context).text("service_type")),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Avatar('assets/photos/date.png'),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: new MaterialButton(
                child: new Text(
                  AppTranslations.of(context).text("one_time_wash"),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  /*
                  * save service type / nature
                  *
                  * service_nature: "One Time Wash"
                  *
                  * */

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SubsOneTime()));
                },
                elevation: 4.0,
                minWidth: double.infinity,
                height: 48.0,
                color: Colors.white,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: new MaterialButton(
                child: new Text(
                  AppTranslations.of(context).text("monthly_wash"),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    //   fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  /*
                  * save service type / nature
                  *
                  * service_nature: "Monthly Wash"
                  *
                  * */
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SubsMonthly()));
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
