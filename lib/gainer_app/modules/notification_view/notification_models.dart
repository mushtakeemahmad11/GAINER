class NotificationModel {
  final int id;
  final int receiverId;
  final String receiver;
  final int senderId;
  final String sender;
  final String title;
  final String message;
  final bool isRead;
  final DateTime? sentOn;
  final String moduleRoute;

  NotificationModel({
    required this.id,
    required this.receiverId,
    required this.receiver,
    required this.senderId,
    required this.sender,
    required this.title,
    required this.message,
    required this.isRead,
    required this.sentOn,
    required this.moduleRoute,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: _toInt(json['ID']),
      receiverId: _toInt(json['ReceiverId']),
      receiver: _toString(json['Receiver']),
      senderId: _toInt(json['SenderId']),
      sender: _toString(json['Sender']),
      title: _toString(json['Title']),
      message: _toString(json['Message']),
      isRead: _toBool(json['IsRead']),
      sentOn: _toDate(json['SentOn']),
      moduleRoute: _toString(json['ModuleRoute']),
    );
  }

  /// ---------- Helpers ----------

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static String _toString(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
  }

  static bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) return value;

    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}

//
// class NotificationModel {
//   final int id;
//   final int receiverId;
//   final String receiver;
//   final int senderId;
//   final String sender;
//   final String title;
//   final String message;
//   final bool isRead;
//   final DateTime? sentOn;
//   final String moduleRoute;
//
//   NotificationModel({
//     required this.id,
//     required this.receiverId,
//     required this.receiver,
//     required this.senderId,
//     required this.sender,
//     required this.title,
//     required this.message,
//     required this.isRead,
//     required this.sentOn,
//     required this.moduleRoute,
//   });
//
//   factory NotificationModel.fromJson(Map<String, dynamic> json) {
//     return NotificationModel(
//       id: json['ID'],
//       receiverId: json['ReceiverId'],
//       receiver: json['Receiver'],
//       senderId: json['SenderId'],
//       sender: json['Sender'],
//       title: json['Title'],
//       message: json['Message'],
//       isRead: json['IsRead'],
//       sentOn: json['SentOn'] != null ? DateTime.parse(json['SentOn']) : null,
//       // sentOn: DateTime.parse(json['SentOn']),
//       moduleRoute: json['ModuleRoute'],
//     );
//   }
// }

// class GainerAppNotification {
//   final String id;
//   final String userId;
//   final String title;
//   final String body;
//   final String locationId;
//   final String? sourceLocationId;
//   final String? tCode;
//   final String type;
//   final bool read;
//   final Map<String, dynamic> data;
//   final Timestamp? createdAt;
//
//   GainerAppNotification({
//     required this.id,
//     required this.userId,
//     required this.title,
//     required this.body,
//     required this.locationId,
//     required this.type,
//     required this.read,
//     required this.data,
//     this.sourceLocationId,
//     this.tCode,
//     this.createdAt,
//   });
//
//   /// 🔹 Create model from Firestore document
//   factory GainerAppNotification.fromDoc(DocumentSnapshot doc) {
//     final d = doc.data() as Map<String, dynamic>? ?? {};
//
//     return GainerAppNotification(
//       id: doc.id,
//       userId: d['userId'] ?? '',
//       title: d['title'] ?? '',
//       body: d['body'] ?? '',
//       locationId: d['locationId'] ?? '',
//       sourceLocationId: d['sourceLocationId'],
//       tCode: d['tCode'],
//       type: d['type'] ?? 'system',
//       read: d['read'] ?? false,
//       data: Map<String, dynamic>.from(d['data'] ?? {}),
//       createdAt: d['createdAt'],
//     );
//   }
//
//   /// 🔹 Convert model to Firestore map
//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'title': title,
//       'body': body,
//       'locationId': locationId,
//       'sourceLocationId': sourceLocationId,
//       'tCode': tCode,
//       'type': type,
//       'read': read,
//       'data': data,
//       'createdAt': createdAt ?? FieldValue.serverTimestamp(),
//     };
//   }
//
//   /// 🔹 Optional: copyWith (useful for updates)
//   GainerAppNotification copyWith({
//     bool? read,
//     Map<String, dynamic>? data,
//   }) {
//     return GainerAppNotification(
//       id: id,
//       userId: userId,
//       title: title,
//       body: body,
//       locationId: locationId,
//       sourceLocationId: sourceLocationId,
//       tCode: tCode,
//       type: type,
//       read: read ?? this.read,
//       data: data ?? this.data,
//       createdAt: createdAt,
//     );
//   }
// }
