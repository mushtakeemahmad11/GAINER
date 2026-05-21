class DealerListModel {
  final String dealer;
  final int dealerId;

  DealerListModel({
    required this.dealer,
    required this.dealerId,
  });

  factory DealerListModel.fromJson(Map<String, dynamic> json) {
    return DealerListModel(
      dealer: json['Dealer'] ?? '',
      dealerId: json['DealerId'] ?? 0,
    );
  }
}