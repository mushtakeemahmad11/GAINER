import 'package:googleapis_auth/auth_io.dart';
import 'firebase_db_creation.dart';

class GetServerKey {
  Future<String> getServerKey() async {
    final scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    try {
      final serviceAccountJson = await FirebaseDbCreation.getServerKey();
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
      );

      final accessServerKey = client.credentials.accessToken.data;
      return accessServerKey;
    } catch (e) {
      return "Error generating server token";
    }
  }
}
