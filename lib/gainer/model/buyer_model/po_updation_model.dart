class PoUpdationModel {
  final String status;
  final String? sellerResponseDate;
  final String? poConfirmationDate;
  final String? manifestationDate;
  final String? receivingDate;
  final String oemCode;
  final String? lspStatus;
  final String? invoiceNumber;
  final String? invoiceCopy;
  final String? crnCopy;
  final double? crnAmount;
  final String transporterType;
  final String courierType;
  final String? pickupRequest;
  final String? companyCode;
  final String? lrNumber;
  final String? lrDate;
  final String? manifestDate;
  final String? companyName;
  final String? manifestRemarks;
  final String? poNumber;
  final String buyerLatestDate;
  final int sellerLocationId;
  final bool? reminderStatus;
  final String orderNo;
  final int bigId;
  final String status1;
  final String partNumber;
  final String partDesc;
  final double price;
  final double mrp;
  final double partValue;
  final int sellerDealerId;
  final String dealerName;
  final String sellerLocation;
  final int qty;
  final double discount;
  final int sellerStockQty;
  final double sellerLatestStock;
  final double sellerFreeStock;
  final String sellerStockDate;
  final int buyerStockQty;
  final double buyerLatestStock;
  final String requestDate;
  final String? dispatchDate;
  final String? remarks;
  final String? requestAcceptRemarks;
  final String? partImage;
  final int dispatchQty;
  final int poQty;
  final String? docketNo;
  final String? dispatchDate1;
  final String? dispatchDetails;
  final String? dispatchedPart;
  final String orderFor;
  final String? furtherDetailsRemarks;
  final String? responseConfirmRemarks;
  final String orderStatus;
  final String? escalationStage;
  final String? dispatchOrderNo;
  final String orderType;
  final String? deliverDate;
  final String deliverStatus;
  final int eta;
  final String dealerVerified;
  final String scsVerified;
  final String? sWeFastTrackUrl;
  final String? bWeFastTrackUrl;
  final String stockCat;
  final String? bufferAction;
  final String? packingSlip;

  PoUpdationModel({
    required this.status,
    this.sellerResponseDate,
    this.poConfirmationDate,
    this.manifestationDate,
    this.receivingDate,
    required this.oemCode,
    this.lspStatus,
    this.invoiceNumber,
    this.invoiceCopy,
    this.crnCopy,
    this.crnAmount,
    required this.transporterType,
    required this.courierType,
    this.pickupRequest,
    this.companyCode,
    this.lrNumber,
    this.lrDate,
    this.manifestDate,
    this.companyName,
    this.manifestRemarks,
    this.poNumber,
    required this.buyerLatestDate,
    required this.sellerLocationId,
    this.reminderStatus,
    required this.orderNo,
    required this.bigId,
    required this.status1,
    required this.partNumber,
    required this.partDesc,
    required this.price,
    required this.mrp,
    required this.partValue,
    required this.sellerDealerId,
    required this.dealerName,
    required this.sellerLocation,
    required this.qty,
    required this.discount,
    required this.sellerStockQty,
    required this.sellerLatestStock,
    required this.sellerFreeStock,
    required this.sellerStockDate,
    required this.buyerStockQty,
    required this.buyerLatestStock,
    required this.requestDate,
    this.dispatchDate,
    this.remarks,
    this.requestAcceptRemarks,
    this.partImage,
    required this.dispatchQty,
    required this.poQty,
    this.docketNo,
    this.dispatchDate1,
    this.dispatchDetails,
    this.dispatchedPart,
    required this.orderFor,
    this.furtherDetailsRemarks,
    this.responseConfirmRemarks,
    required this.orderStatus,
    required this.escalationStage,
    this.dispatchOrderNo,
    required this.orderType,
    this.deliverDate,
    required this.deliverStatus,
    required this.eta,
    required this.dealerVerified,
    required this.scsVerified,
    this.sWeFastTrackUrl,
    this.bWeFastTrackUrl,
    required this.stockCat,
    this.bufferAction,
    this.packingSlip,
  });

  factory PoUpdationModel.fromJson(Map<String, dynamic> json) {
    return PoUpdationModel(
      status: json["Status"] ?? "",
      sellerResponseDate: json["SellerResponseDate"],
      poConfirmationDate: json["POConfirmationDate"],
      manifestationDate: json["ManifestationDate"],
      receivingDate: json["ReceivingDate"],
      oemCode: json["OEMCode"] ?? "",
      lspStatus: json["LSPStatus"],
      invoiceNumber: json["InvoiceNumber"],
      invoiceCopy: json["InvoiceCopy"],
      crnCopy: json["CrnCopy"],
      crnAmount: (json["CrnAmount"] as num?)?.toDouble(),
      transporterType: json["TransporterType"] ?? "",
      courierType: json["CourierType"] ?? "",
      pickupRequest: json["PickupRequest"],
      companyCode: json["CompanyCode"],
      lrNumber: json["LRNumber"],
      lrDate: json["LRDate"],
      manifestDate: json["ManifestDate"],
      companyName: json["CompanyName"],
      manifestRemarks: json["ManifestRemarks"],
      poNumber: json["PONUMBER"],
      buyerLatestDate: json["BUYERLATESTDATE"] ?? "",
      sellerLocationId: json["SELLERLOCATIONID"] ?? 0,
      reminderStatus: json["REMINDERSTATUS"],
      orderNo: json["ORDERNO"] ?? "",
      bigId: json["BIGID"] ?? 0,
      status1: json["STATUS1"] ?? "",
      partNumber: json["PARTNUMBER"] ?? "",
      partDesc: json["partdesc"] ?? "",
      price: (json["Price"] as num?)?.toDouble() ?? 0.0,
      mrp: (json["MRP"] as num?)?.toDouble() ?? 0.0,
      partValue: (json["PARTVALUE"] as num?)?.toDouble() ?? 0.0,
      sellerDealerId: json["SellerDealerID"] ?? 0,
      dealerName: json["DealerName"] ?? "",
      sellerLocation: json["SELLERLOCATION"] ?? "",
      qty: json["QTY"] ?? 0,
      discount: (json["DISCOUNT"] as num?)?.toDouble() ?? 0.0,
      sellerStockQty: json["SELLERSTOCKQTY"] ?? 0,
      sellerLatestStock: (json["SELLERLATESTSTOCK"] as num?)?.toDouble() ?? 0.0,
      sellerFreeStock: (json["SellerFreeStock"] as num?)?.toDouble() ?? 0.0,
      sellerStockDate: json["SELLERSTOCKDATE"] ?? "",
      buyerStockQty: json["BUYERSTOCKQTY"] ?? 0,
      buyerLatestStock: (json["BUYERLATESTSTOCK"] as num?)?.toDouble() ?? 0.0,
      requestDate: json["REQUESTDATE"] ?? "",
      dispatchDate: json["DispatchDate"],
      remarks: json["REMARKS"],
      requestAcceptRemarks: json["REQUESTACCEPTREMARKS"],
      partImage: json["PARTIMAGE"],
      dispatchQty: json["DISPATCHQTY"] ?? 0,
      poQty: json["POQty"] ?? 0,
      docketNo: json["DocketNo"],
      dispatchDate1: json["DispatchDate1"],
      dispatchDetails: json["DispatchDetails"],
      dispatchedPart: json["DispatchedPart"],
      orderFor: json["ORDERFOR"] ?? "",
      furtherDetailsRemarks: json["FurtherDetailsRemarks"],
      responseConfirmRemarks: json["ResponseConfirmRemarks"],
      orderStatus: json["ORDERSTATUS"] ?? "",
      escalationStage: json["ESCALATIONSTAGE"],
      dispatchOrderNo: json["DispatchOrderNo"],
      orderType: json["OrderType"] ?? "",
      deliverDate: json["DeliverDate"],
      deliverStatus: json["DeliverStatus"] ?? "",
      eta: json["ETA"] ?? 0,
      dealerVerified: json["DealerVerified"] ?? "No",
      scsVerified: json["SCSVerified"] ?? "No",
      sWeFastTrackUrl: json["SWeFastTrackUrl"],
      bWeFastTrackUrl: json["BWeFastTrackUrl"],
      stockCat: json["StockCat"] ?? "",
      bufferAction: json["BufferAction"],
      packingSlip: json["PackingSlip"],
    );
  }


  // factory PoUpdationModel.fromJson(Map<String, dynamic> json) {
  //   return PoUpdationModel(
  //     status: json["Status"] ?? "",
  //     sellerResponseDate: json["SellerResponseDate"],
  //     poConfirmationDate: json["POConfirmationDate"],
  //     manifestationDate: json["ManifestationDate"],
  //     receivingDate: json["ReceivingDate"],
  //     oemCode: json["OEMCode"] ?? "",
  //     lspStatus: json["LSPStatus"],
  //     invoiceNumber: json["InvoiceNumber"],
  //     invoiceCopy: json["InvoiceCopy"],
  //     crnCopy: json["CrnCopy"],
  //     crnAmount: (json["CrnAmount"] as num?)?.toDouble(),
  //     transporterType: json["TransporterType"] ?? "",
  //     courierType: json["CourierType"] ?? "",
  //     pickupRequest: json["PickupRequest"],
  //     companyCode: json["CompanyCode"],
  //     lrNumber: json["LRNumber"],
  //     lrDate: json["LRDate"],
  //     manifestDate: json["ManifestDate"],
  //     companyName: json["CompanyName"],
  //     manifestRemarks: json["ManifestRemarks"],
  //     poNumber: json["PONUMBER"],
  //     buyerLatestDate: json["BUYERLATESTDATE"] ?? "",
  //     sellerLocationId: json["SELLERLOCATIONID"] ?? 0,
  //     reminderStatus: json["REMINDERSTATUS"],
  //     orderNo: json["ORDERNO"] ?? "",
  //     bigId: json["BIGID"] ?? 0,
  //     status1: json["STATUS1"] ?? "",
  //     partNumber: json["PARTNUMBER"] ?? "",
  //     partDesc: json["partdesc"] ?? "",
  //     price: (json["Price"] as num?)?.toDouble() ?? 0.0,
  //     mrp: (json["MRP"] as num?)?.toDouble() ?? 0.0,
  //     partValue: (json["PARTVALUE"] as num?)?.toDouble() ?? 0.0,
  //     sellerDealerId: json["SellerDealerID"] ?? 0,
  //     dealerName: json["DealerName"] ?? "",
  //     sellerLocation: json["SELLERLOCATION"] ?? "",
  //     qty: json["QTY"] ?? 0,
  //     discount: (json["DISCOUNT"] as num?)?.toDouble() ?? 0.0,
  //     sellerStockQty: json["SELLERSTOCKQTY"] ?? 0,
  //     sellerLatestStock: (json["SELLERLATESTSTOCK"]  as num?)?.toDouble() ?? 0.0,
  //     sellerFreeStock: (json["SellerFreeStock"]  as num?)?.toDouble() ?? 0.0,
  //     sellerStockDate: json["SELLERSTOCKDATE"] ?? "",
  //     buyerStockQty: json["BUYERSTOCKQTY"] ?? 0,
  //     buyerLatestStock: (json["BUYERLATESTSTOCK"]  as num?)?.toDouble() ?? 0.0,
  //     requestDate: json["REQUESTDATE"] ?? "",
  //     dispatchQty: json["DISPATCHQTY"] ?? 0,
  //     poQty: json["POQty"] ?? 0,
  //     orderFor: json["ORDERFOR"] ?? "",
  //     orderStatus: json["ORDERSTATUS"] ?? "",
  //     escalationStage: json["ESCALATIONSTAGE"] ?? "",
  //     orderType: json["OrderType"] ?? "",
  //     deliverStatus: json["DeliverStatus"] ?? "",
  //     eta: json["ETA"] ?? 0,
  //     dealerVerified: json["DealerVerified"] ?? "No",
  //     scsVerified: json["SCSVerified"] ?? "No",
  //     stockCat: json["StockCat"] ?? "",
  //   );
  // }
}
