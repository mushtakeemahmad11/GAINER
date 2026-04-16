import './part_receipt_model.dart';

class PartReceiptSellerModel {
  final String sellerName;
  final String location;
  final int poQty;
  final List<PartReceiptModel> items;

  PartReceiptSellerModel({
    required this.sellerName,
    required this.location,
    required this.poQty,
    required this.items,
  });
}
