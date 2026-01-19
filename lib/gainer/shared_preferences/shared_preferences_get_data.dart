import 'package:shared_preferences/shared_preferences.dart';

getStringData(String k) async {
  final key = k;
  final pref = await SharedPreferences.getInstance();
  return pref.getString(key);
}

getIntData(String k) async {
  final key = k;
  final pref = await SharedPreferences.getInstance();
  return pref.getInt(key);
}


getBoolData(String k) async {
  final key = k;
  final pref = await SharedPreferences.getInstance();
  return pref.getBool(key);
}


