class OrderTypeListModel {
  final String orderFor;
  final int orderForId;

  OrderTypeListModel({
    required this.orderFor,
    required this.orderForId,
  });

  factory OrderTypeListModel.fromJson(Map<String, dynamic> json) {
    return OrderTypeListModel(
      orderFor: json['OrderFor'] ?? '',
      orderForId: json['OrderForID'] ?? 0,
    );
  }
}
