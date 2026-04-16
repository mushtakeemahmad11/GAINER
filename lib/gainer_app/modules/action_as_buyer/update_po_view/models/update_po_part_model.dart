import '../models/update_po_model.dart';

class UpdatePoPartModel {
  final String highestDate;
  final String partNumber;
  final String partDesc;
  final int totalMrp;
  final int totalPrice;
  final List<UpdatePoModel> items;

  UpdatePoPartModel({
    required this.highestDate,
    required this.partNumber,
    required this.partDesc,
    required this.totalMrp,
    required this.totalPrice,
    required this.items,
  });
}
