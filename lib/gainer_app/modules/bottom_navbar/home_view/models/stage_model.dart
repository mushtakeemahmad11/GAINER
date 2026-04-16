// class StageModel {
//   final String stage;
//   final int partsCount;
//   final double val;
//   final double walletBalance;
//   final double fundBalance;
//
//   StageModel({
//     required this.stage,
//     required this.partsCount,
//     required this.val,
//     required this.walletBalance,
//     required this.fundBalance,
//   });
//
//   factory StageModel.fromJson(Map<String, dynamic> json) {
//     double parseVal(dynamic value) {
//       if (value == null) return 0.0;
//
//       final cleaned = value.toString().replaceAll(' L', '');
//       return double.tryParse(cleaned) ?? 0.0;
//     }
//
//     double parseDouble(dynamic value) {
//       if (value == null) return 0.0;
//       if (value is int) return value.toDouble();
//       if (value is double) return value;
//       return double.tryParse(value.toString()) ?? 0.0;
//     }
//
//     return StageModel(
//       stage: json['Stage']?.toString() ?? '',
//       partsCount: json['PartsCount'] ?? 0,
//       val: parseVal(json['Val']),
//       walletBalance: parseDouble(json['WalletBalance']),
//       fundBalance: parseDouble(json['FundBalance']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'Stage': stage,
//       'PartsCount': partsCount,
//       'Val': val,
//       'WalletBalance': walletBalance,
//       'FundBalance': fundBalance,
//     };
//   }
// }

import 'package:intl/intl.dart';

class StageModel {
  final String stage;
  final int partsCount;
  final double val;
  final double walletBalance;
  final double fundBalance;
  final String stageDate;

  StageModel({
    required this.stage,
    required this.partsCount,
    required this.val,
    required this.walletBalance,
    required this.fundBalance,
    required this.stageDate,
  });

  // Factory constructor to create an object from a map
  factory StageModel.fromJson(Map<String, dynamic> json) {
    // String? formattedDate = '2026-03-05';
    // String? formattedDate = json['StageDate'];
    // try {
    //   if (formattedDate != null && formattedDate.isNotEmpty) {
    //     DateTime date = DateTime.parse(formattedDate);
    //     formattedDate = DateFormat('MMM dd, yyyy').format(date);
    //   }
    // } catch (e) {
    //   formattedDate = '';
    // }

    // formattedDate = dateParse(json['StageDate']);
    String? formattedDate = dateParse(json['StageDate']);

    return StageModel(
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
      // stageDate: formattedDate ?? 'MM/DD/YYYY',
      stageDate: formattedDate,
      // stageDate: DateFormat('MMM dd, yyyy').format(DateTime.parse(json['StageDate'])),
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
      'StageDate': stageDate,
    };
  }

  static String dateParse(String? d) {
    try {
      if (d != null && d.isNotEmpty) {
        DateTime date = DateTime.parse(d);
        return DateFormat('MMM dd, yyyy').format(date);
      }
      return '';
    } catch (e) {
      return '';
    }
  }
}

// DateTime date = DateTime.parse('2026-02-18 13:08:34.283');
//
// String result = DateFormat('MMM dd, yyyy').format(date);
