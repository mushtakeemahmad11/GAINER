import 'order_placed_model.dart';

class GroupedPartModel {
  final String partNumber;
  final String partDesc;
  final int totalQty;
  final List<OrderPlacedModel> items;

  GroupedPartModel({
    required this.partNumber,
    required this.partDesc,
    required this.totalQty,
    required this.items,
  });
}

