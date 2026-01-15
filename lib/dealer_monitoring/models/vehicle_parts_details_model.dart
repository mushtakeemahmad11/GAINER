class VehiclePartsDetailsModel {
  final String partNumber;
  final String description;
  final String category;
  final double ndp;
  final int qty;
  final int demandedQty;
  final double value;
  final String alltimestk;

  VehiclePartsDetailsModel({
    required this.partNumber,
    required this.description,
    required this.category,
    required this.ndp,
    required this.qty,
    required this.demandedQty,
    required this.value,
    required this.alltimestk,
  });

  factory VehiclePartsDetailsModel.fromJson(Map<String, dynamic> json) {
    return VehiclePartsDetailsModel(
      partNumber: json['partNumber'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      ndp: (json['ndp'] ?? 0).toDouble(),
      qty: (json['StockQty'] ?? 0).toInt(),
      demandedQty: (json['DemandedQty'] ?? 0).toInt(),
      value: (json['value'] ?? 0).toDouble(),
      alltimestk: json['alltimestk'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'partNumber': partNumber,
        'description': description,
        'category': category,
        'ndp': ndp,
        'qty': qty,
        'demandedQty': demandedQty,
        'value': value,
        'alltimestk': alltimestk,
      };
}

class VehiclePPNI {
  final String vehicleNumber;
  final double ppniValue;
  final int inStockCount;
  final int notIssued;
  final String dealerID;
  final String locationID;
  // final List<VehiclePartsDetailsModel> parts;

  VehiclePPNI({
    required this.vehicleNumber,
    required this.ppniValue,
    required this.inStockCount,
    required this.notIssued,
    required this.dealerID,
    required this.locationID,
    // required this.parts,
  });

  // factory VehiclePPNI.fromJson(Map<String, dynamic> json) {
  //   return VehiclePPNI(
  //     vehicleNumber: json['vehicleNumber'] ?? '',
  //     ppniValue: (json['ppniValue'] ?? 0).toDouble(),
  //     parts: (json['parts'] as List<dynamic>)
  //         .map((item) => VehiclePartsDetailsModel.fromJson(item))
  //         .toList(),
  //   );
  // }

  factory VehiclePPNI.fromJson(Map<String, dynamic> json) {
    return VehiclePPNI(
      vehicleNumber: json['Vehiclenumber'] ?? '',
      ppniValue: (json['PPNI_Value'] ?? 0).toDouble(),
      notIssued: (json['NotIssued'] ?? 0).toInt(),
      inStockCount: (json['InstockCount'] ?? 0).toInt(),
      locationID: json['LocationID'].toString(),
      dealerID: json['DealerID'].toString(),
      // parts: (json['parts'] != null && json['parts'] is List)
      //     ? (json['parts'] as List<dynamic>)
      //     .map((item) => VehiclePartsDetailsModel.fromJson(item))
      //     .toList()
      //     : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'vehicleNumber': vehicleNumber,
        'ppniValue': ppniValue,
        'inStockCount': inStockCount,
        'notIssued': notIssued,
        'LocationId': locationID,
        'DealerId': dealerID,
        // 'parts': parts.map((e) => e.toJson()).toList(),
      };
}
