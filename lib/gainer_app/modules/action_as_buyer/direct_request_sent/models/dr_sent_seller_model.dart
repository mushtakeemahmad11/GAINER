import 'dr_sent_model.dart';

class DrSentSellerModel {
  final String sellerName;
  final String location;
  final int qty;
  final List<DrSentModel> items;

  DrSentSellerModel({
    required this.sellerName,
    required this.location,
    required this.qty,
    required this.items,
  });
}
