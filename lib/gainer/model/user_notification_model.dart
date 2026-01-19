import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserNotification {
  final String id;
  final String title;
  final String body;
  final bool isSeen;
  final String sendAt;
  final String dealerID;
  final int userId;

  UserNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.isSeen,
    required this.sendAt,
    required this.dealerID,
    required this.userId,
  });

  // factory UserNotification.fromMap(String id, Map<String, dynamic> data) {
  //   return UserNotification(
  //     id: id,
  //     title: data['title'],
  //     body: data['body'],
  //     isSeen: data['isSeen'] ?? false,
  //     sendAt: (data['sendAt'] as Timestamp).toDate(),
  //   );
  // }

  factory UserNotification.fromMap(String id, Map<String, dynamic> data) {
    Timestamp? timestamp = data['sendAt'];
    String formattedDate = timestamp != null
        ? DateFormat('dd-MM-yyyy HH:mm:ss').format(timestamp.toDate())
        : 'Unknown time';

    return UserNotification(
      id: id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      isSeen: data['isSeen'] ?? false,
      sendAt: formattedDate,
      dealerID: data['dealerID'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

}
