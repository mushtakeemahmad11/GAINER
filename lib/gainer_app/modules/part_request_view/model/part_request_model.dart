import 'package:flutter/material.dart';

class PartRequestModel {
  final String status;
  final int id;
  final int clusterCode;
  final int sellerDealerID;
  final int sellerLocationID;
  final String sellerDealer;
  final String sellerLocation;
  final int stateCode;
  final int cityCode;
  final String dealerVerified;
  final String scsVerified;
  final double discount;
  final String partNumber;
  final double sellerStock;
  final double freeStock;
  final String sellerZoneName;
  final String buyerZoneName;
  final int tat;
  final String description;
  final String category;
  final double mrp;
  final double price;
  final double rate;
  final String moq;
  final String weFastClusterSeller;
  final String stockCat;
  final double latestStock;

  final TextEditingController reqQtyCtl = TextEditingController();
  final TextEditingController remarkCtl = TextEditingController();

  int get requestedQty => int.tryParse(reqQtyCtl.text) ?? 0;

  bool get hasQty => requestedQty > 0;

  void dispose() {
    reqQtyCtl.dispose();
    remarkCtl.dispose();
  }

  PartRequestModel({
    required this.status,
    required this.id,
    required this.clusterCode,
    required this.sellerDealerID,
    required this.sellerLocationID,
    required this.sellerDealer,
    required this.sellerLocation,
    required this.stateCode,
    required this.cityCode,
    required this.dealerVerified,
    required this.scsVerified,
    required this.discount,
    required this.partNumber,
    required this.sellerStock,
    required this.freeStock,
    required this.sellerZoneName,
    required this.buyerZoneName,
    required this.tat,
    required this.description,
    required this.category,
    required this.mrp,
    required this.price,
    required this.rate,
    required this.moq,
    required this.weFastClusterSeller,
    required this.stockCat,
    required this.latestStock,
  });

  factory PartRequestModel.fromJson(Map<String, dynamic> json) {
    return PartRequestModel(
      status: json["Status"] ?? "",
      id: json["ID"] ?? 0,
      clusterCode: json["ClusterCode"] ?? 0,
      sellerDealerID: json["SellerDealerID"] ?? 0,
      sellerLocationID: json["SellerLocationID"] ?? 0,
      sellerDealer: json["SellerDealer"] ?? "",
      sellerLocation: json["SellerLocation"] ?? "",
      stateCode: json["StateCode"] ?? 0,
      cityCode: json["CityCode"] ?? 0,
      dealerVerified: json["DealerVerified"] ?? "",
      scsVerified: json["SCSVerified"] ?? "",
      discount: double.tryParse(json["Discount"]?.toString() ?? "0") ?? 0.0,
      // discount: json["Discount"] ?? "",
      partNumber: json["PartNumber"] ?? "",
      sellerStock: (json["SellerStock"] ?? 0).toDouble(),
      freeStock: (json["FreeStock"] ?? 0).toDouble(),
      sellerZoneName: json["SellerZoneName"] ?? "",
      buyerZoneName: json["BuyerZoneName"] ?? "",
      tat: json["TAT"] ?? 0,
      description: json["Description"] ?? "",
      category: json["Category"] ?? "",
      mrp: (json["MRP"] ?? 0).toDouble(),
      price: (json["Price"] ?? 0).toDouble(),
      rate: (json["Rate"] ?? 0).toDouble(),
      moq: json["MOQ"] ?? "",
      weFastClusterSeller: json["WeFastClusterSeller"] ?? "",
      stockCat: json["StockCat"] ?? "",
      latestStock: (json["LatestStock"] ?? 0).toDouble(),
    );
  }

}
