import 'dr_received_model.dart';

class DrReceivedSellerModel {
  final String sellerName;
  final String location;
  final int totalItems;
  final List<DrReceivedModel> items;

  DrReceivedSellerModel({
    required this.sellerName,
    required this.location,
    required this.totalItems,
    required this.items,
  });
}
