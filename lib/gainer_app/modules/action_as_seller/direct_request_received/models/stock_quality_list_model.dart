class StockQualityListModel {
  final String stockQuality;
  final int stockQualityId;

  StockQualityListModel({
    required this.stockQuality,
    required this.stockQualityId,
  });

  factory StockQualityListModel.fromJson(Map<String, dynamic> json) {
    return StockQualityListModel(
      stockQuality: json['StockQuality'] ?? '',
      stockQualityId: json['StockQualityId'] ?? 0,
    );
  }
}
