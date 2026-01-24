import '../models/update_po_model.dart';

class UpdatePoPartModel {
  final String partNumber;
  final String partDesc;
  final int totalQty;
  final List<UpdatePoModel> items;

  UpdatePoPartModel({
    required this.partNumber,
    required this.partDesc,
    required this.totalQty,
    required this.items,
  });
}

