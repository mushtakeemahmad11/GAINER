import '../models/manifestation_model.dart';

class ManifestationPartModel {
  final String minimumDate;
  final String partNumber;
  final String partDesc;
  final int totalItem;
  // final int totalMrp;
  // final int totalPrice;
  final List<ManifestationModel> items;

  ManifestationPartModel({
    required this.minimumDate,
    required this.partNumber,
    required this.partDesc,
    required this.totalItem,
    // required this.totalMrp,
    // required this.totalPrice,
    required this.items,
  });
}
