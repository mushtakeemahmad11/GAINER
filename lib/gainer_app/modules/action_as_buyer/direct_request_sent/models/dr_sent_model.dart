class DrSentModel {
  final String? brand;
  final String? dealer;
  final String? location;
  final int? id;
  final String? partNumber;
  final String? description;
  final double? mrp;
  final double? rate;
  final String? remarks;
  final double? qty;
  final String? requestDate;
  final String? statusName;

  DrSentModel({
    this.brand,
    this.dealer,
    this.location,
    this.id,
    this.partNumber,
    this.description,
    this.mrp,
    this.rate,
    this.remarks,
    this.qty,
    this.requestDate,
    this.statusName,
  });

  /// ✅ Safe JSON parsing
  factory DrSentModel.fromJson(Map<String, dynamic> json) {
    return DrSentModel(
      brand: json['Brand']?.toString(),
      dealer: json['Dealer']?.toString(),
      location: json['Location']?.toString(),
      id: _parseInt(json['Id']),
      partNumber: json['PartNumber']?.toString(),
      description: json['Description']?.toString(),
      mrp: _parseDouble(json['Mrp']),
      rate: _parseDouble(json['Rate']),
      remarks: json['Remarks']?.toString(),
      qty: _parseDouble(json['Qty']),
      requestDate: json['RequestDate']?.toString(),
      statusName: json['StatusName']?.toString(),
    );
  }

  /// ✅ Convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      "Brand": brand,
      "Dealer": dealer,
      "Location": location,
      "Id": id,
      "PartNumber": partNumber,
      "Description": description,
      "Mrp": mrp,
      "Rate": rate,
      "Remarks": remarks,
      "Qty": qty,
      "RequestDate": requestDate,
      "StatusName": statusName,
    };
  }

  /// 🔒 Safe int parser
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  /// 🔒 Safe double parser
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}