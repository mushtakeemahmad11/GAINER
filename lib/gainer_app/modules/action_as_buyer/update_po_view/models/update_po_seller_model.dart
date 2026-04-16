import '../models/update_po_model.dart';

class UpdatePoSellerModel {
  final String highestDate;
  final String sellerName;
  final String location;
  final int totalMrp;
  final int totalPrice;
  final List<UpdatePoModel> items;

  UpdatePoSellerModel({
    required this.highestDate,
    required this.sellerName,
    required this.location,
    required this.totalMrp,
    required this.totalPrice,
    required this.items,
  });
}
