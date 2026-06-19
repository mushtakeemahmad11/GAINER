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