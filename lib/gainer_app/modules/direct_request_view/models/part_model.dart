import 'dart:convert';

class PartModel {
  String partNo;
  String desc;
  String mrp;
  String rate;
  String qty;
  String dealer;
  String location;
  String orderFor;
  int dealerId;
  int locationId;
  int orderForId;
  String? remarks;

  PartModel({
    required this.partNo,
    required this.desc,
    required this.mrp,
    required this.rate,
    required this.qty,
    required this.dealer,
    required this.location,
    required this.orderFor,
    required this.dealerId,
    required this.locationId,
    required this.orderForId,
    this.remarks,
  });

  // Map<String, String> toSubmitJson() => {
  //       "PartNumber": partNo,
  //       "Description": desc,
  //       "MRP": mrp,
  //       "Rate": rate,
  //       "SuggestedSeller": dealerId.toString(),
  //       "Location": locationId.toString(),
  //       "Qty": qty,
  //       "Remark": remarks ?? '',
  //       "OrderFor": orderForId.toString(),
  //     };
  Map<String, String> toJson() {
    return {
      "PartNumber": partNo.toString(),
      "Description": desc,
      "MRP": double.parse(mrp).toStringAsFixed(2),
      "Rate": double.parse(rate).toStringAsFixed(2),
      "SuggestedSeller": dealerId.toString(),
      "Location": locationId.toString(),
      "Qty": qty.toString(),
      "Remark": remarks ?? "",
      "OrderFor": orderForId.toString(),
    };
    // return jsonEncode(part);
  }
}
