import './part_receipt_model.dart';

class PartReceiptPartModel {
  final String partNumber;
  final String partDesc;
  final int poQty;
  final List<PartReceiptModel> items;

  PartReceiptPartModel({
    required this.partNumber,
    required this.partDesc,
    required this.poQty,
    required this.items,
  });
}
