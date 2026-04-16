import '../models/manifestation_model.dart';

class ManifestationSellerModel {
  final String minimumDate;
  final String sellerName;
  final String location;
  final int totalItem;
  // final int totalPrice;
  final List<ManifestationModel> items;

  ManifestationSellerModel({
    required this.minimumDate,
    required this.sellerName,
    required this.location,
    required this.totalItem,
    // required this.totalPrice,
    required this.items,
  });
}
