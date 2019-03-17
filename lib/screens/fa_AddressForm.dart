import 'package:flutter/material.dart';
import 'package:flutter_app_x/localization/AppTranslations.dart';
import 'package:flutter_app_x/pref/UserPref.dart';
import 'package:flutter_app_x/screens/e_CheckOut.dart';

class AddressForm extends StatefulWidget {
  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {


  TextEditingController _streetController = TextEditingController();
  TextEditingController _blockController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _avenueController = TextEditingController();
  TextEditingController _apartmentController = TextEditingController();
  TextEditingController _flooController = TextEditingController();

  bool _streetValidStatus = true;
  bool _blockValidStatus = true;
  bool _buildingValidStatus = true;

  var _streetText;
  var _blockText = 'Enter Block';
  var _buildingText = 'Enter Building No';
  var _avenueText = 'Enter Avenue No';
  var _apartmentText = 'Enter Apartment No';
  var _floorText = 'Enter Floor No';

  var _isLogin = true;

  var empty_msg;

  void _loadPrefData() async {
    var addressLine = await (UserPref.getPref('addressLine')) ?? 0;
    setState(() {
      _streetText = addressLine;
      _streetController = TextEditingController(text: '$_streetText');
    });
  }

  @override
  void initState() {
    super.initState();

    _loadPrefData();
  }

  @override
  Widget build(BuildContext context) {

    empty_msg = AppTranslations.of(context).text("empty_msg");

    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text(AppTranslations.of(context).text("confirm_address")),
      ),
      bottomNavigationBar: _isLogin
          ? Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 12.0, top: 12.0),
              child: MaterialButton(
                child: new Text(
                  AppTranslations.of(context).text("confirm_address"),
                  style: const TextStyle(
                    color: Colors.black,
                    letterSpacing: 5.0,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _streetController.text.isNotEmpty
                        ? _streetValidStatus = true
                        : _streetValidStatus = false;
                    _buildingController.text.isNotEmpty
                        ? _blockValidStatus = true
                        : _blockValidStatus = false;
                    _buildingController.text.isNotEmpty
                        ? _buildingValidStatus = true
                        : _buildingValidStatus = false;
                    _avenueController.text.isNotEmpty
                        ? UserPref.savePref(
                            'avenue', '${_avenueController.text}')
                        : UserPref.savePref('avenue', null);
                    _apartmentController.text.isNotEmpty
                        ? UserPref.savePref(
                            'apartment', '${_apartmentController.text}')
                        : UserPref.savePref('apartment', null);
                    _flooController.text.isNotEmpty
                        ? UserPref.savePref('floor', '${_flooController.text}')
                        : UserPref.savePref('floor', null);

                    if (_streetValidStatus &&
                        _buildingValidStatus &&
                        _blockValidStatus) {
                      UserPref.savePref('street', '${_streetController.text}');
                      UserPref.savePref('block', '${_blockController.text}');
                      UserPref.savePref(
                          'building', '${_buildingController.text}');

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckOut()),
                      );
                    }
                  });
                },
                elevation: 4.0,
                minWidth: double.infinity,
                height: 48.0,
                color: Colors.white,
              ),
            )
          : null,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: ListView(
          children: <Widget>[
            new ListTile(
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.white24))),
                child: Icon(Icons.add_location, color: Colors.white),
                // Icon(Icons.directions_car, color: Colors.white),
              ),
              title: TextField(
                maxLines: 2,
                controller: _streetController,
                textInputAction: TextInputAction.done,
                style: new TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: Colors.yellowAccent,
                decoration: InputDecoration(
                  hintText: '$_streetText',
                  hintStyle: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  helperText: AppTranslations.of(context).text("street"),
                  helperStyle: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.yellowAccent, width: 2.5)),
                  errorText:
                      _streetValidStatus ? null : empty_msg,
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.yellowAccent,
                  )),
                  errorStyle: TextStyle(
                    color: Colors.yellowAccent,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            new ListTile(
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.white24))),
                child: Icon(Icons.add_location, color: Colors.white),
              ),
              title: TextField(
                controller: _blockController,
                style: new TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: Colors.yellowAccent,
                decoration: InputDecoration(
                  hintText: _blockText,
                  hintStyle: new TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                  helperText: AppTranslations.of(context).text("block"),
                  helperStyle: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.yellowAccent, width: 2.5)),
                  errorText: _blockValidStatus ? null : empty_msg,
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.yellowAccent,
                  )),
                  errorStyle: TextStyle(
                    color: Colors.yellowAccent,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            new ListTile(
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.white24))),
                child: Icon(Icons.add_location, color: Colors.white),
              ),
              title: TextField(
                controller: _buildingController,
                style: new TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: Colors.yellowAccent,
                decoration: InputDecoration(
                  hintText: _buildingText,
                  hintStyle: new TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                  helperText: AppTranslations.of(context).text("building"),
                  helperStyle: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.yellowAccent, width: 2.5)),
                  errorText:
                      _buildingValidStatus ? null : '$empty_msg',
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.yellowAccent,
                  )),
                  errorStyle: TextStyle(
                    color: Colors.yellowAccent,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            new ListTile(
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.white24))),
                child: Icon(Icons.add_location, color: Colors.white),
                // Icon(Icons.directions_car, color: Colors.white),
              ),
              title: TextField(
                controller: _avenueController,
                style: new TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: Colors.yellowAccent,
                decoration: InputDecoration(
                  hintText: _avenueText,
                  hintStyle: new TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                  helperText: AppTranslations.of(context).text("avenue"),
                  helperStyle: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.yellowAccent, width: 2.5)),
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            new ListTile(
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.white24))),
                child: Icon(Icons.add_location, color: Colors.white),
              ),
              title: TextField(
                controller: _apartmentController,
                style: new TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: Colors.yellowAccent,
                decoration: InputDecoration(
                  hintText: _apartmentText,
                  hintStyle: new TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                  helperText: AppTranslations.of(context).text("apartment"),
                  helperStyle: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.yellowAccent, width: 2.5)),
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            new ListTile(
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.white24))),
                child: Icon(Icons.add_location, color: Colors.white),
              ),
              title: TextField(
                controller: _flooController,
                style: new TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: Colors.yellowAccent,
                decoration: InputDecoration(
                  hintText: _floorText,
                  hintStyle: new TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                  helperText: AppTranslations.of(context).text("floor"),
                  helperStyle: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.yellowAccent, width: 2.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
