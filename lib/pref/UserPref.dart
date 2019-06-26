import 'package:shared_preferences/shared_preferences.dart';

class UserStringPref {
  static savePref(String key, String value) async {
    final _pref = await SharedPreferences.getInstance();
    _pref.setString(key, value);
    var counter = _pref.getString('$key') ?? 0;
    print('Pref.. Save_String $key  = $counter');
  }

  static saveBoolPref(String key, bool value) async {
    final _pref = await SharedPreferences.getInstance();
    _pref.setBool(key, value);
    print('Pref.. Save_Bool $key  = $value');
  }

  static getPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = (prefs.getString('$key') ?? 0);
    return value;
  }

  static clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
