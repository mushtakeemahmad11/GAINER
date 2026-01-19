import '../shared_preferences/shared_preferences_get_data.dart';

Future<bool> isSessionExpired() async {
  int? loginTime = await getIntData('login_time');

  if (loginTime == null) return true; // treat as expired if not found

  int currentTime = DateTime.now().millisecondsSinceEpoch;
  const int fourHours = 4 * 60 * 60 * 1000;

  return (currentTime - loginTime) >= fourHours;
}
