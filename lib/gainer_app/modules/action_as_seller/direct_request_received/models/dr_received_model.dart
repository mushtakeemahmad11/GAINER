import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class DrReceivedModel {
  final String? buyingBrand;
  final String? buyingDealer;
  final String? buyingLocation;
  final int? id;
  final String? partNumber;
  final String? description;
  final double? mrp;
  final double? rate;
  final String? remarks;
  final double? qty;
  final String? requestDate;

  final double? stock;
  final int? stockCat;

  // ✅ Controllers for user input
  final TextEditingController stockCtl = TextEditingController();
  final TextEditingController discountCtl = TextEditingController();

  // ✅ Reactive dropdown value (GetX)
  final RxnInt selectedStockQuality = RxnInt();

  DrReceivedModel({
    this.buyingBrand,
    this.buyingDealer,
    this.buyingLocation,
    this.id,
    this.partNumber,
    this.description,
    this.mrp,
    this.rate,
    this.remarks,
    this.qty,
    this.requestDate,
    this.stock,
    this.stockCat,
  });

  factory DrReceivedModel.fromJson(Map<String, dynamic> json) {
    final model = DrReceivedModel(
      buyingBrand: json['BuyingBrand']?.toString(),
      buyingDealer: json['BuyingDealer']?.toString(),
      buyingLocation: json['BuyingLocation']?.toString(),
      id: _parseInt(json['Id']),
      partNumber: json['PartNumber']?.toString(),
      description: json['Description']?.toString(),
      mrp: _parseDouble(json['Mrp']),
      rate: _parseDouble(json['Rate']),
      remarks: json['Remarks']?.toString(),
      qty: _parseDouble(json['Qty']),
      requestDate: json['RequestDate']?.toString(),
      stock: _parseDouble(json['Stock']),
      stockCat: _parseInt(json['StockCat']),
    );

    // // ✅ Set default values if needed
    // model.selectedStockQuality.value = model.stockCat ?? 0;

    return model;
  }

  Map<String, dynamic> toJson() {
    return {
      "BuyingBrand": buyingBrand,
      "BuyingDealer": buyingDealer,
      "BuyingLocation": buyingLocation,
      "Id": id,
      "PartNumber": partNumber,
      "Description": description,
      "Mrp": mrp,
      "Rate": rate,
      "Remarks": remarks,
      "Qty": qty,
      "RequestDate": requestDate,
      "Discount": discountCtl.text,
      "Stock": stockCtl.text,
      "StockCat": stockCat,
    };
  }

  // /// 🔥 Payload for submit
  // Map<String, dynamic> toSubmitJson() {
  //   return {
  //     "Id": id,
  //     "Stock": double.tryParse(stockCtl.text) ?? 0,
  //     "Discount": double.tryParse(discountCtl.text) ?? 0,
  //     "StockCat": selectedStockQuality.value,
  //   };
  // }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

// class DrReceivedModel {
//   final String? buyingBrand;
//   final String? buyingDealer;
//   final String? buyingLocation;
//   final int? id;
//   final String? partNumber;
//   final String? description;
//   final double? mrp;
//   final double? rate;
//   final String? remarks;
//   final double? qty;
//   final String? requestDate;
//   final double? discount;
//   final double? stock;
//   final int? stockCat;
//
//   DrReceivedModel({
//     this.buyingBrand,
//     this.buyingDealer,
//     this.buyingLocation,
//     this.id,
//     this.partNumber,
//     this.description,
//     this.mrp,
//     this.rate,
//     this.remarks,
//     this.qty,
//     this.requestDate,
//     this.discount,
//     this.stock,
//     this.stockCat,
//   });
//
//   /// ✅ Factory constructor with safe parsing
//   factory DrReceivedModel.fromJson(Map<String, dynamic> json) {
//     return DrReceivedModel(
//       buyingBrand: json['BuyingBrand']?.toString(),
//       buyingDealer: json['BuyingDealer']?.toString(),
//       buyingLocation: json['BuyingLocation']?.toString(),
//       id: _parseInt(json['Id']),
//       partNumber: json['PartNumber']?.toString(),
//       description: json['Description']?.toString(),
//       mrp: _parseDouble(json['Mrp']),
//       rate: _parseDouble(json['Rate']),
//       remarks: json['Remarks']?.toString(),
//       qty: _parseDouble(json['Qty']),
//       requestDate: json['RequestDate']?.toString(),
//       discount: _parseDouble(json['Discount']),
//       stock: _parseDouble(json['Stock']),
//       stockCat: _parseInt(json['StockCat']),
//     );
//   }
//
//   /// ✅ Convert back to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       "BuyingBrand": buyingBrand,
//       "BuyingDealer": buyingDealer,
//       "BuyingLocation": buyingLocation,
//       "Id": id,
//       "PartNumber": partNumber,
//       "Description": description,
//       "Mrp": mrp,
//       "Rate": rate,
//       "Remarks": remarks,
//       "Qty": qty,
//       "RequestDate": requestDate,
//       "Discount": discount,
//       "Stock": stock,
//       "StockCat": stockCat,
//     };
//   }
//
//   /// 🔒 Safe int parser
//   static int? _parseInt(dynamic value) {
//     if (value == null) return null;
//     if (value is int) return value;
//     return int.tryParse(value.toString());
//   }
//
//   /// 🔒 Safe double parser
//   static double? _parseDouble(dynamic value) {
//     if (value == null) return null;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     return double.tryParse(value.toString());
//   }
// }
