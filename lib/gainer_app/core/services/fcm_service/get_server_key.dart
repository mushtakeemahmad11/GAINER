import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKey() async {
    final scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
      // "https://www.googleapis.com/auth/userinfo.email",
      // "https://www.googleapis.com/auth/firebase.database",
      // "https://www.googleapis.com/auth/userinfo.messaging",
    ];

    try {
      final serviceAccountJson = {};

      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
      );

      final accessServerKey = client.credentials.accessToken.data;
      // print("✅ Server Token: $accessServerKey");
      return accessServerKey;
    } catch (e) {
      // print('❌ Error generating server token: $e');
      return "Error generating server token";
    }
  } //comment
}

// {
// "type": "service_account",
// "project_id": "gainer-app",
// "private_key_id": "6e65d61b419a29ce61c6224fafca133dd30a94d4",
// "private_key":
// "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCbHh7O1hCohfRs\nV9wDBrrCzkE9uI2EmvfxJrtHyy98AV7j69kNHZ/anPxUxze+6clObYOlFUQbIz5T\nDM8O29Mk1lUBd7VlkDUoMKihN510Yl3fEOymw9H2mmI73XHkeZ1ddy/ww0nXHcPF\nk9LI9LX8HuUoWnT5NNN1WhOdfnwC046h8Gy64xyeRBitYjrs3ml/7qRz34/ZESSs\nfz4Dircc+hGStFh/KIJN+I08QdBv2M2DWX+HBXZmJ4xLJTLOPnbNPDPcATWfAfp0\nAjX9ixlsIbq5yKB/hASFBWFnJLBoFCOV2AQ9FKqO6Ur0O28NSdRgRb9ww/v0SBRz\nXNY42+xfAgMBAAECggEAOI3Uwah+TlL4eH/X8SqE8P1t/+jHf+9YMo3ifhxwZY/C\nXurgKc4BOB1ASlCP3IU0Jen7szZ7rEE/OdxTqaEv7CBQwcY5VpwrJUoIUS8LsyEi\nBHAROAPxCy3iXt0v5xMH8sm/qtIom8t4UxLAKRA/QXqqJfpE548BAaojuKoi4Ixb\n6+/i1bBpy+h57HdoaGTzS4fAALK9wuyJzN67FfvI07IkCuqt7/2P1nantAoNAqYo\nKwfWaO78ZXZuIWNPl3LI0WnQ6NFDiGLRwaUshOdYlIfxzGH7a93+wIu+lFZ3itDN\nGuD1cx4cT/SuPJtxOfYt/++6nEY4iVJ4X/ONcrNOUQKBgQDPGYlLy66XA6hLsmNc\n6bWU8Km10afXIO8VF3AdXa0LRRAnh2vFdSZK4iJ/E0Jk1DQSwXQ7k64r86Oql3S7\niJb2qSg6uL9cO9L2WlFY/jqCiiVYpvMGY+RUr2+WYApcP9h9PMHpwxX+AO+IU6Du\n90UfvTwXdaQYE4bjWwB/d2ArbQKBgQC/vnI90ugoeXpf91wnv4SshuwuuE1LazQS\n8+pAHjIyKNY5h9Cs+y+U01P23EnJHLaMgMwdb6wsl+XrQr+a4JMTq5/k95tJKNTd\n9B4fbFd+pidBxzIsRQzgjkR7uNC0GQ7uMw0Oqz2zJ1ivIrI5DwSOWAVzT5stktpq\nbpDzdLLrewKBgGAYAD28J6mIl+lvv20YQBn4xTZJLrDCZk0KEAqAMc/d3s4Ipvf7\nEKaEYO9Ht3HjiLn/K3iNYK6iIRoBprdxfGK9QJ5mpNweIhgO9lnttKZnhUaqSG95\noDOvJ37F12jQcxpBO9TEoYq3Um2WKEFZWKiOfLiB7H8DaH5L9mIuuN/NAoGAKcJP\nXRmOyCnUtgvIPTvfqDdmPrKS2ucJG0uV68rnwbbVGQh0MQgvj6kKs0u8ohknxKfU\nTGDizX9zam5KDm/0eCc7loE6h49l9MTSvqM41vNWv2OjkLKlIE67qXpRsbd3Yfcq\nU9SFhnv+O35B9F1J77pJzZg7wowmF2HnHa5/vPsCgYEAiPRz5Y1Im4u5LewnGdgv\nbWHIFKzGqxYgw72iILpy+ktbfhImm+OSHabWq05m/64TKWOTAWWMHXYgCGTaC5Ds\nAdfB60EYv3r3dlyondUpHA45Ied5WIMQhq2LedU+OIJj8oNerkuJ+HjupqS0SfCL\nWpTNW3UNw8SIKc2wf/1Xl4o=\n-----END PRIVATE KEY-----\n",
// "client_email":
// "firebase-adminsdk-fbsvc@gainer-app.iam.gserviceaccount.com",
// "client_id": "102642224080672926319",
// "auth_uri": "https://accounts.google.com/o/oauth2/auth",
// "token_uri": "https://oauth2.googleapis.com/token",
// "auth_provider_x509_cert_url":
// "https://www.googleapis.com/oauth2/v1/certs",
// "client_x509_cert_url":
// "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40gainer-app.iam.gserviceaccount.com",
// "universe_domain": "googleapis.com"
// },
