// To parse this JSON data, do

//     final getLocation = getLocationFromJson(jsonString);

import 'dart:convert';

List<GetLocation> getLocationFromJson(String str) => List<GetLocation>.from(json.decode(str).map((x) => GetLocation.fromJson(x)));

String getLocationToJson(List<GetLocation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetLocation {
  int brandId;
  int dealerId;
  int locationId;
  String brand;
  String dealer;
  String location;
  String stockDate;
  double stockVal;

  GetLocation({
    required this.brandId,
    required this.dealerId,
    required this.locationId,
    required this.brand,
    required this.dealer,
    required this.location,
    required this.stockDate,
    required this.stockVal,
  });

  factory GetLocation.fromJson(Map<String, dynamic> json) => GetLocation(
    brandId: json["BrandID"],
    dealerId: json["DealerID"],
    locationId: json["LocationID"],
    brand: json["Brand"],
    dealer: json["Dealer"],
    location: json["Location"],
    stockDate: json["StockDate"],
    stockVal: json["StockVal"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "BrandID": brandId,
    "DealerID": dealerId,
    "LocationID": locationId,
    "Brand": brand,
    "Dealer": dealer,
    "Location": location,
    "StockDate": stockDate,
    "StockVal": stockVal,
  };
}
