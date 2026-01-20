class StageModel {
  final String stage;
  final int partsCount;
  final double val;
  final double walletBalance;
  final double fundBalance;

  StageModel({
    required this.stage,
    required this.partsCount,
    required this.val,
    required this.walletBalance,
    required this.fundBalance,
  });

  // Factory constructor to create an object from a map
  factory StageModel.fromJson(Map<String, dynamic> json) {
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
