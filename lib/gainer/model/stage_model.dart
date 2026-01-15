// class Stage {
//   String? stage;
//   int? partsCount;
//   String? val;
//   double? walletBalance;
//   double? fundBalance;
//
//   Stage({
//         this.stage,
//         this.partsCount,
//         this.val,
//         this.walletBalance,
//         this.fundBalance
//       });
//
//   Stage.fromJson(Map<String, dynamic> json) {
//     stage = json['Stage'];
//     partsCount = json['PartsCount'];
//     val = json['Val'];
//     walletBalance = json['WalletBalance'];
//     fundBalance = json['FundBalance'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Stage'] = stage;
//     data['PartsCount'] = partsCount;
//     data['Val'] = val;
//     data['WalletBalance'] = walletBalance;
//     data['FundBalance'] = fundBalance;
//     return data;
//   }
// }

import 'dart:convert';

class StageData {
  final String stage;
  final int partsCount;
  final double val;
  final double walletBalance;
  final double fundBalance;

  StageData({
    required this.stage,
    required this.partsCount,
    required this.val,
    required this.walletBalance,
    required this.fundBalance,
  });

  // Factory constructor to create an object from a map
  factory StageData.fromJson(Map<String, dynamic> json) {
    return StageData(
      stage: json['Stage'] as String,
      partsCount: json['PartsCount'] as int,
      val: (json['Val'] != null)
          ? double.parse(json['Val'].toString().replaceAll(' L', ''))
          : 0.0,
      walletBalance: (json['WalletBalance'] is int)
          ? (json['WalletBalance'] as int).toDouble()
          : json['WalletBalance'] as double,
      fundBalance: (json['FundBalance'] is int)
          ? (json['FundBalance'] as int).toDouble()
          : json['FundBalance'] as double,
    );
  }

  // Method to convert the object to a map
  Map<String, dynamic> toJson() {
    return {
      'Stage': stage,
      'PartsCount': partsCount,
      'Val': val,
      'WalletBalance': walletBalance,
      'FundBalance': fundBalance,
    };
  }
}

class StageDataManager {
  // List to store the data
  List<StageData> stageDataList = [];

  // Function to parse and store the data
  void parseAndStoreData(String responseData) {
    // Decode the JSON response
    final List<dynamic> jsonData = jsonDecode(responseData);

    // Convert each item to a StageData object and store it in the list
    stageDataList = jsonData.map((item) => StageData.fromJson(item)).toList();
  }
}
