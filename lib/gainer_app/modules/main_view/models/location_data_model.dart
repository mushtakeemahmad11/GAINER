class LocationDataModel {
  final int brandId;
  final int dealerId;
  final int locationId;
  final String brand;
  final String dealer;
  final String location;
  final String? stockDate;
  final double stockVal;

  LocationDataModel({
    required this.brandId,
    required this.dealerId,
    required this.locationId,
    required this.brand,
    required this.dealer,
    required this.location,
    required this.stockDate,
    required this.stockVal,
  });

  factory LocationDataModel.fromJson(Map<String, dynamic> json) {
    return LocationDataModel(
      brandId: json['BrandID'] ?? '',
      dealerId: json['DealerID'] ?? '',
      locationId: json['LocationID'] ?? '',
      brand: json['Brand'] ?? '',
      dealer: json['Dealer'] ?? '',
      location: json['Location'] ?? '',
      stockDate: json['StockDate'] ?? '',
      stockVal: (json['StockVal'] as num).toDouble(),
    );
  }
}
