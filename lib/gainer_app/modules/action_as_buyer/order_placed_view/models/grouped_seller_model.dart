import 'order_placed_model.dart';

class GroupedSellerModel {
  final String sellerName;
  final String location;
  final int totalQty;
  final List<OrderPlacedModel> items;

  GroupedSellerModel({
    required this.sellerName,
    required this.location,
    required this.totalQty,
    required this.items,
  });
}
