import 'part_request_model.dart';

class PartRequestPartModel {
  final String partNumber;
  final String partDesc;
  final int mrp;
  final List<PartRequestModel> items;

  PartRequestPartModel({
    required this.partNumber,
    required this.partDesc,
    required this.mrp,
    required this.items,
  });
}
