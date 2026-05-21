
import 'dr_received_model.dart';

class DrReceivedPartModel {
  final String partNumber;
  final String partDesc;
  final int totalItem;
  final List<DrReceivedModel> items;

  DrReceivedPartModel({
    required this.partNumber,
    required this.partDesc,
    required this.totalItem,
    required this.items,
  });
}
