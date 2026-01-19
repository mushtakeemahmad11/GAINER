import 'package:shared_preferences/shared_preferences.dart';

setStringData(String k, String v) async {
  final key = k;
  final value = v;
  final pref = await SharedPreferences.getInstance();
  await pref.setString(key, value);
  return true;
}


setIntData(String k, int v) async {
  final key = k;
  final value = v;
  final pref = await SharedPreferences.getInstance();
  await pref.setInt(key, value);
  return true;
}


setBoolData(String k, bool v) async {
  final key = k;
  final value = v;
  final pref = await SharedPreferences.getInstance();
  await pref.setBool(key, value);
  return true;
}
