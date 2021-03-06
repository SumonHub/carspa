import 'package:carspa/localization/AppTranslations.dart';
import 'package:carspa/pref/UserPref.dart';
import 'package:carspa/screens/fa_AddressForm.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickMap extends StatefulWidget {
  @override
  _PickMapState createState() => _PickMapState();
}

class _PickMapState extends State<PickMap> {
  var _search;
  TextEditingController _textEditingController;

  GoogleMapController mapController;

  //var _initLocation = const LatLng(29.347126136377188, 47.67043210566044);
  static const _initLocation = const LatLng(29.3759, 47.9774);
  LatLng _updatedLoc = _initLocation;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    // _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _search = AppTranslations.of(context).text("search_your_place");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppTranslations.of(context).text("map"),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: new CameraPosition(
              target: _initLocation,
              zoom: 15.0,
            ),
            onCameraMove: (CameraPosition position) {
              _updatedLoc = position.target;
              debugPrint(_updatedLoc.toString());
            },

          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: new Container(
                margin: EdgeInsets.only(top: 30.0),
                //  padding: const EdgeInsets.all(10.0),
                // color: Colors.white,
                child: new TextFormField(
                  onFieldSubmitted: (searchKey) {
                    setState(() {
                      _textEditingController
                          .addListener(_getLatlngFromAddress(searchKey));
                    });
                  },
                  controller: _textEditingController,
                  decoration: new InputDecoration(
                    hintText:
                        AppTranslations.of(context).text("search_your_place"),
                    labelText: _search,
                    fillColor: Colors.white70,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  // keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                    color: Colors.black,
                    letterSpacing: 3.0,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 70.0),
            child: Align(
              alignment: Alignment.center,
              child: new Icon(
                Icons.edit_location,
                size: 80.0,
                color: Colors.redAccent,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _currLocation();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Icon(
                  Icons.location_on,
                  size: 70.0,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
                _getAddressFromLatlng(_updatedLoc).then((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AddressForm()),
                  );
                });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.check_circle,
                  size: 70.0,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _currLocation() {
    var _currLoc;

    Geolocator()
        .getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    )
        .then((currloc) {
      setState(() {
        _currLoc = LatLng(currloc.latitude, currloc.longitude);
      });
    }).then((_) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_currLoc.latitude, _currLoc.longitude),
        zoom: 15.0,
      )));
      _getAddressFromLatlng(_currLoc);
    });

  }

  Future _getAddressFromLatlng(LatLng latlng) async {
    // From coordinates

    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    print("country : ${placemark[0].country}");
    print("position : ${placemark[0].position}");
    print("locality : ${placemark[0].locality}");
    print("administrativeArea : ${placemark[0].administrativeArea}");
    print("postalCode : ${placemark[0].postalCode}");
    print("name : ${placemark[0].name}");
    print("isoCountryCode : ${placemark[0].isoCountryCode}");
    print("subLocality : ${placemark[0].subLocality}");
    print("subThoroughfare : ${placemark[0].subThoroughfare}");
    print("thoroughfare : ${placemark[0].thoroughfare}");

    UserStringPref.savePref('name', '${placemark[0].name}');
    UserStringPref.savePref('street', '${placemark[0].thoroughfare}');

    /*final coordinates = new Coordinates(latlng.latitude, latlng.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print("${addresses.toString()}");
    var first = addresses.first;

    UserStringPref.savePref('addressLine', '${first.featureName}');

    // _search = first.addressLine;

    print("addressLine:  ${first.addressLine}\n"
        "countryName : ${first.countryName}\n"
        "featureName : ${first.featureName}\n"
        "postalCode : ${first.postalCode}\n"
        "locality : ${first.locality}\n"
        "subLocality : ${first.subLocality}\n"
        "adminArea : ${first.adminArea}\n"
        "subAdminArea : ${first.subAdminArea}\n"
        "thoroughfare : ${first.thoroughfare}\n"
        "subThoroughfare : ${first.subThoroughfare}\n");*/
  }

  _getLatlngFromAddress(String address) async {
    /* final query = address;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");

    setState(() {
      final _updatedLoc =
          LatLng(first.coordinates.latitude, first.coordinates.longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_updatedLoc.latitude, _updatedLoc.longitude),
        zoom: 17.0,
      )));
    });*/

    List<Placemark> placemark = await Geolocator()
        .placemarkFromAddress(address);
    print("position : ${placemark[0].position}");

    setState(() {
      final _updatedLoc =
      LatLng(placemark[0].position.latitude, placemark[0].position.longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_updatedLoc.latitude, _updatedLoc.longitude),
        zoom: 17.0,
      )));
    });
  }
}
