import '../models/order_received_model.dart';

class OrderReceivedSellerModel {
  final String minimumDate;
  final String sellerName;
  final String location;
  final int totalItem;
  // final int totalPrice;
  final List<OrderReceivedModel> items;

  OrderReceivedSellerModel({
    required this.minimumDate,
    required this.sellerName,
    required this.location,
    required this.totalItem,
    // required this.totalPrice,
    required this.items,
  });
}
