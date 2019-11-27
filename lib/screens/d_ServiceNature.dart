import 'package:carspa/components/Avatar.dart';
import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/screens/da_SubsOneTime.dart';
import 'package:carspa/screens/db_SubsMonthly.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceNature extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppTranslations.of(context).text("service_type")),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Avatar('assets/photos/calendar.png'),

            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Container(
                height: 80.0,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
                child: ListTile(
                    onTap: () {
                      /*
                  * save service type / nature
                  *
                  * service_nature: "One Time Wash"
                  *
                  * */

                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => SubsOneTime()));
                    },
                    title: Center(
                      child: Text(
                        AppTranslations.of(context).text("one_time_wash"),
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                            fontSize: 22.0

                        ),
                      ),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right,
                        color: Colors.black26, size: 60.0)
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Container(
                height: 80.0,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
                child: ListTile(
                    onTap: () {
                      /*
                  * save service type / nature
                  *
                  * service_nature: "Monthly Wash"
                  *
                  * */
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => SubsMonthly()));
                    },

                    title: Center(
                      child: Text(
                        AppTranslations.of(context).text("monthly_wash"),
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                            fontSize: 22.0

                        ),
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black26, size: 60.0,
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
