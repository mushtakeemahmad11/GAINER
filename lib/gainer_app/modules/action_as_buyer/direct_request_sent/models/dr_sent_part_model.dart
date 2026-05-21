import 'dr_sent_model.dart';

class DrSentPartModel {
  final String partNumber;
  final String partDesc;
  final int qty;
  final List<DrSentModel> items;

  DrSentPartModel({
    required this.partNumber,
    required this.partDesc,
    required this.qty,
    required this.items,
  });
}
