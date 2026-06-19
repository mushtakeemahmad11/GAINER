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
      final serviceAccountJson = {
        "type": "service_account",
        "project_id": "gainer-app",
        "private_key_id": "db1cf2586ef57ce7c5c197bfcedbff17eed558c4",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCrHRCnZQbbgmK4\nnXgfdItDVy7TK2qd2SMWn9hwhvTaja0Pk+m3zjdc2OmPE+uN+pub4Qc35p0sz1c5\nwwxrSi3+V1pMa7CJ6sg21D9089lNWAcwJ8Sn9btWA0/MKMLCnyyop97h/6zy0gTo\nwL/uJVnHMHf4iexlkQ9s9m9qL8ZgFm1AEWTonFj88j7u991fUt2+yprgZH1q1bq2\n7j9WjiVXUtomIQOafNe/Ehhi9CbJ8s8DoUebZxMvDaQaZTidAoYD58pi6Z7Hoib5\n8qj9IhXzKqTuBQi37RrHYNiU66KF3xphRXr6Y0T5hs4AaUv11kcdGW6GyFgKsIUC\nu39rX40BAgMBAAECggEARXTUz73YXL2+KMXyfoImDT2USi8zZcM/1O0pQ/Pj69ra\nRpp5ohxYqJ17oJIraUQyacGb1nsLjabT9yRPJDXGGZmHk8GatUDR6D+bSnO43wY+\nVLOvxaWfVzic6XgaJjnKPON3OzE3GJFbYMbsoVQT7yCjcgU6KbgKFOarLuUZluKZ\nnWJMryZ0BUw5JPsjrpTWlKwiOVU6klAnyPpFxsBlWTi/gMaGdjWjGOYfqzISafAq\nHaJkSOgM5zcfP4qDjRbSEWpmYFZ0auHfNJ4RuFbZN4b+dwchZttuO6TFZvovKaVH\n+y69+ALa2rqZ044pDrnyrYd1bfExPpmjENZvzQ2EyQKBgQDWCu7Io5wXY5NdAh6h\nifDNp+rW2ulX5X4pXRLafmwr5ekLWXTFyKY8v/MKS2U7j3wHMel74BDTojt3xIHj\n8vhNhJee808qlRJvEP/5OiEfvE4EQc1sYzwRqtvtYTQi4DEBn7xr5AmxxWx71W64\nSOMQwntVjrwhBvTaJD0W+Xz2IwKBgQDMp92Nfk6Af+eqFDl63ntSknM5n6vhS7rS\nacETkzCBMYhdU2FIdL2+1Cam6ssCv2oYshc9qNtcLUysfiKVgpSmn9/AeZ9zZUEd\nOEBTC+yGrRyB5ac3zjntO1yp9U3GegFNvNUNjz/kQVmKe24W6P1wIzSARYdh1yY4\nYqVvINz4iwKBgE465rU8XyOJSGX5DVr7QKDZ25I1po1yml7h3q8u/7g3qqp0QqK7\nSE7x1RGRJunS8oDqtCyLY3sGU3fdwZ+fwTML4CK/SNMGcxtW+keMAGlJ+LXDmyIf\nTugiK4miOlz41dCDImnIieaIgrLr+jCuqxcIDe3iYk4r7bgBALbx7sNDAoGBAJTv\nvS6RsvOVIbUGzuX6L2liJvTSnLVy9VzXlal3Pp9musSgP3YJb2UG47IpwOAZCU87\nm+pFjo5AcUI+8VA5HZE9XAqo+D90erSXEUjerp08MjjeNplIPaPFxaPyX02H0JcQ\nS0R48Zhdbpp3RSDrIjWPiU+oSeQMPUZfk+GR2v4NAoGALPxdUJDPZnGpDqlKopAI\nGu/NSJ475wj9Tk+EeyTjRIQJSKb33eKcLgglZ16DvH6KzI67Nzj6G5rFMIyO5q6w\nudbGV3XbG10WOln41JUMPeu/GiC4ycG35Ujo6EVfNPWQAHtEsg2msA2E8Y2cIQvU\n7VZlxzOC7LbgrhIH4aXmdJQ=\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@gainer-app.iam.gserviceaccount.com",
        "client_id": "102642224080672926319",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40gainer-app.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      };

      // final serviceAccountJson = {
      //   "type": "service_account",
      //   "project_id": "gainer-app",
      //   "private_key_id": "24d89c6b5bf32dfe7f29a3e6563db70dadb5ad63",
      //   "private_key":
      //       "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDUqluMlI6e6oVR\nPe//TxBoNaG/4IPf0zwKeE6hZUSMk+pufhIDDmHBgtCyv9rBtDF2sq9h97S4SVCl\nJpcnQey5XENYPJayJbH6PwRb8O8mz9yntQhHaCza7qwfEPsT1AyLrXEgZfTDdksU\n92//dMGJDx8EbN4rB+zQ+JeXdVY7PEkq2AhjOgpFWUpRUdEoDXdIPLooJzSkzpuK\nOA3MGDYFEFLKUAbMrm2TxTsJYFgFHNOHljxzLNfZFeawMdj6QCMRRnaZicLyeaPJ\neBfClCxQw0thmi90sxWqGj+yYq7Yk2mJjZX4f7UCFEGE+r6j1C8j35aQCkOmO7XZ\n3dY1PZYHAgMBAAECggEAGYCQV+xcqfvvns1xoUkm64g67FqNFeMr2QmSTFJrhPwb\n6cIegNVRrbX1NupA3mewYs6Mr4/X0R2hmRxmleOW8qd4v/UMETLqA9tYt3nOA/Z7\nPHU+F+oLLvneFB+iLD+KfZl/7mWrk2D1If+GI7kpmDkC/DHd9oUNxgV5kEUW4SVi\nitTO5Pc4HHVCVCNY2+kkkGlRPJxx0yiZNNKLU2QgrWWPhO8WH2n8ccpfwTiOO/Xg\nBqUo9wT/QEayQYnegV5cTMGmsxf1hkLCcfzE8zcCZYy9yzPy2Sob8tbUdrfmjaGx\nndJAG/GV2NI7Zp4DcVAlYTIk3OVDLdkQDw/JCvrP6QKBgQD197f+QyV2QAwnCg45\nGBytp9WrTkoFIHUOIVyEvMzE96mahpLn/oBNTOhbAMwX4/vs+Y0xQKmCDB0oF9Oa\n1WbRuwkVqhaeSZYhM+QzmK++WJW7Un2Oa+Y0ePPEF7gfFt9la/Qb/1lIcnOWIN4+\nQ/w0W4FhiSZrMRzH1uMfr0F3cwKBgQDdVummU1ktQodSdyBATJfxSKbZfzh6BuSh\nyYuw/2qUioK8e65tdKFgv45J4Ujb8nqT3WE8DXo8+GUJP1bIJxnTRW7gX6Vq4eJY\n1R9w2g3xD+MvUNJ9Gfffsfz5OYSzmnnUo2sX2opV8P00kMoem9vNAUIHUvqlHfoo\nFlVdBHE6HQKBgQCsVORPvAHaSON60rvGWtN1A/tba53G28fHn64vvgwGELN+9byl\n2JVSE4lUgUl9j5lpnirDkFdzK0OeXJtAhzXjyhSCXko8mrgaCT5gvCCdz3kQ5qnb\niFOg/gFkqW2yMpdQewNsPkryzGWZkOvFWmKw2E/c43fMcHuGtFMrVuIaawKBgQCO\nESgdUugtTcNv4fh4bPEltL0rYyYL5PrBAY1BCWAOga0Sb8xwgujGIY2hzBEo48Vb\nvT+Y/QmVstWfDuGTzM0dtzZIm/uf0+aln/3zQHKsZMcsapMAKzfXg/Xcvdd4NFG4\ncz/c6q/aI7lSERE6fk2hkwofi1pHuysCqfsWnjBS3QKBgHpi96EwzUgga0v5iK74\nbSJU9fGdMuU7nf/EcNiG/ixl76+Joc1PLU5se9BvV1+VEeoE9MfMnOwB45kSd5AK\n9bhKlyeRY4umF1sw/ChGHEKfR6FdqPKV+I2qRIpTPRp7BKiPfG2tEU65IkTeXx8x\n9eyLbZxz/4Na1vFMbUMi5Ss6\n-----END PRIVATE KEY-----\n",
      //   "client_email":
      //       "firebase-adminsdk-fbsvc@gainer-app.iam.gserviceaccount.com",
      //   "client_id": "102642224080672926319",
      //   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      //   "token_uri": "https://oauth2.googleapis.com/token",
      //   "auth_provider_x509_cert_url":
      //       "https://www.googleapis.com/oauth2/v1/certs",
      //   "client_x509_cert_url":
      //       "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40gainer-app.iam.gserviceaccount.com",
      //   "universe_domain": "googleapis.com"
      // };
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
