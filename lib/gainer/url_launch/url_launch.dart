import 'package:url_launcher/url_launcher.dart';

Future<bool> launchURL(String url) async {
  Uri uri = Uri.parse(url);

  try {
    await launchUrl(uri);
    return true;
  } catch (e) {
    return false;
  }
}
