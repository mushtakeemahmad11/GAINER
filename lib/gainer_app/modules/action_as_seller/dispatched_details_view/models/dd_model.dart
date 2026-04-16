class DDModel {
  final int lspCode;
  final String lsp;
  final String lrNumber;
  final String dispatchOrderNo;
  final String lrDate;
  final double length;
  final double width;
  final double height;
  final double weight;
  final int tCode;
  final int buyerLocationID;
  final String buyerLocation;
  final double val;
  final String? withPkgSlipImg;
  final String? img1;
  final String? img2;
  final String? signedCopyPkgSlipImg;
  final String? otherDetailImg;

  DDModel({
    required this.lspCode,
    required this.lsp,
    required this.lrNumber,
    required this.dispatchOrderNo,
    required this.lrDate,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
    required this.tCode,
    required this.buyerLocationID,
    required this.buyerLocation,
    required this.val,
    this.withPkgSlipImg,
    this.img1,
    this.img2,
    this.signedCopyPkgSlipImg,
    this.otherDetailImg,
  });

  factory DDModel.fromJson(Map<String, dynamic> json) {
    return DDModel(
      lspCode: json["LspCode"],
      lsp: json["Lsp"],
      lrNumber: json["LRNumber"],
      dispatchOrderNo: json["DispatchOrderNo"],
      lrDate: json["LRDate"],
      length: (json["Length"] ?? 0).toDouble(),
      width: (json["Width"] ?? 0).toDouble(),
      height: (json["Height"] ?? 0).toDouble(),
      weight: (json["Weight"] ?? 0),
      tCode: json["tCode"],
      buyerLocationID: json["BuyerLocationID"],
      buyerLocation: json["BuyerLocation"],
      val: json["Val"].toDouble(),
      withPkgSlipImg: json["WithPkgSlipImg"],
      img1: json["Img1"],
      img2: json["Img2"],
      signedCopyPkgSlipImg: json["SignedCopyPkgSlipImg"],
      otherDetailImg: json["OtherDetailImg"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "LspCode": lspCode,
      "Lsp": lsp,
      "LRNumber": lrNumber,
      "DispatchOrderNo": dispatchOrderNo,
      "LRDate": lrDate,
      "Length": length,
      "Width": width,
      "Height": height,
      "Weight": weight,
      "tCode": tCode,
      "BuyerLocationID": buyerLocationID,
      "BuyerLocation": buyerLocation,
      "Val": val,
      "WithPkgSlipImg": withPkgSlipImg,
      "Img1": img1,
      "Img2": img2,
      "SignedCopyPkgSlipImg": signedCopyPkgSlipImg,
      "OtherDetailImg": otherDetailImg,
    };
  }
}
