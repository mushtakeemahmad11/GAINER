import '../models/order_received_model.dart';

class OrderReceivedPartModel {
  final String minimumDate;
  final String partNumber;
  final String partDesc;
  final int totalItem;
  final List<OrderReceivedModel> items;

  OrderReceivedPartModel({
    required this.minimumDate,
    required this.partNumber,
    required this.partDesc,
    required this.totalItem,
    required this.items,
  });
}
