class OrderPlacedModel {
  final String? status;
  final String? sellerResponseDate;
  final String? poConfirmationDate;
  final String? manifestationDate;
  final String? receivingDate;
  final String? oemCode;
  final String? lspStatus;
  final String? invoiceNumber;
  final String? invoiceCopy;
  final String? crnCopy;
  final double? crnAmount;
  final String? transporterType;
  final String? courierType;
  final String? pickupRequest;
  final String? companyCode;
  final String? lrNumber;
  final String? lrDate;
  final String? manifestDate;
  final String? companyName;
  final String? manifestRemarks;
  final String? poNumber;
  final String? buyerLatestDate;
  final int? sellerLocationId;
  final String? reminder;
  final bool? reminderStatus;
  final String? orderNo;
  final int? bigId;
  final String? status1;
  final String? partNumber;
  final String? partDesc;
  final double? price;
  final double? mrp;
  final double? partValue;
  final int? sellerDealerId;
  final String? dealerName;
  final String? sellerLocation;
  final int? qty;
  final int discount;
  final int? sellerStockQty;
  final int? sellerLatestStock;
  final int? sellerFreeStock;
  final String? sellerStockDate;
  final int? buyerStockQty;
  final int? buyerLatestStock;
  final String? requestDate;
  final String? dispatchDate;
  final String? remarks;
  final String? requestAcceptRemarks;
  final String? partImage;
  final int? dispatchQty;
  final dynamic poQty;
  final String? docketNo;
  final String? dispatchDate1;
  final String? dispatchDetails;
  final String? dispatchedPart;
  final String? orderFor;
  final String? furtherDetailsRemarks;
  final String? responseConfirmRemarks;
  final String? orderStatus;
  final String? escalationStage;
  final String? dispatchOrderNo;
  final String? orderType;
  final String? deliverDate;
  final String? deliverStatus;
  final int? eta;
  final String? dealerVerified;
  final String? scsVerified;
  final String? sWeFastTrackUrl;
  final String? bWeFastTrackUrl;
  final String? stockCat;
  final String? bufferAction;
  final String? packingSlip;

  OrderPlacedModel({
    this.status,
    this.sellerResponseDate,
    this.poConfirmationDate,
    this.manifestationDate,
    this.receivingDate,
    this.oemCode,
    this.lspStatus,
    this.invoiceNumber,
    this.invoiceCopy,
    this.crnCopy,
    this.crnAmount,
    this.transporterType,
    this.courierType,
    this.pickupRequest,
    this.companyCode,
    this.lrNumber,
    this.lrDate,
    this.manifestDate,
    this.companyName,
    this.manifestRemarks,
    this.poNumber,
    this.buyerLatestDate,
    this.sellerLocationId,
    this.reminder,
    this.reminderStatus,
    this.orderNo,
    this.bigId,
    this.status1,
    this.partNumber,
    this.partDesc,
    this.price,
    this.mrp,
    this.partValue,
    this.sellerDealerId,
    this.dealerName,
    this.sellerLocation,
    this.qty,
    required this.discount,   //edit after
    this.sellerStockQty,
    this.sellerLatestStock,
    this.sellerFreeStock,
    this.sellerStockDate,
    this.buyerStockQty,
    this.buyerLatestStock,
    this.requestDate,
    this.dispatchDate,
    this.remarks,
    this.requestAcceptRemarks,
    this.partImage,
    this.dispatchQty,
    this.poQty,
    this.docketNo,
    this.dispatchDate1,
    this.dispatchDetails,
    this.dispatchedPart,
    this.orderFor,
    this.furtherDetailsRemarks,
    this.responseConfirmRemarks,
    this.orderStatus,
    this.escalationStage,
    this.dispatchOrderNo,
    this.orderType,
    this.deliverDate,
    this.deliverStatus,
    this.eta,
    this.dealerVerified,
    this.scsVerified,
    this.sWeFastTrackUrl,
    this.bWeFastTrackUrl,
    this.stockCat,
    this.bufferAction,
    this.packingSlip,
  });

  factory OrderPlacedModel.fromJson(Map<String, dynamic> json) {
    return OrderPlacedModel(
      status: json["Status"] as String?,
      sellerResponseDate: json["SellerResponseDate"] as String?,
      poConfirmationDate: json["POConfirmationDate"] as String?,
      manifestationDate: json["ManifestationDate"] as String?,
      receivingDate: json["ReceivingDate"] as String?,
      oemCode: json["OEMCode"] as String?,
      lspStatus: json["LSPStatus"] as String?,
      invoiceNumber: json["InvoiceNumber"] as String?,
      invoiceCopy: json["InvoiceCopy"] as String?,
      crnCopy: json["CrnCopy"] as String?,
      crnAmount: json["CrnAmount"] != null
          ? (json["CrnAmount"] as num).toDouble()
          : null,
      transporterType: json["TransporterType"] as String?,
      courierType: json["CourierType"] as String?,
      pickupRequest: json["PickupRequest"] as String?,
      companyCode: json["CompanyCode"] as String?,
      lrNumber: json["LRNumber"] as String?,
      lrDate: json["LRDate"] as String?,
      manifestDate: json["ManifestDate"] as String?,
      companyName: json["CompanyName"] as String?,
      manifestRemarks: json["ManifestRemarks"] as String?,
      poNumber: json["PONUMBER"] as String?,
      buyerLatestDate: json["BUYERLATESTDATE"] as String?,
      sellerLocationId: json["SELLERLOCATIONID"] == null
          ? null
          : (json["SELLERLOCATIONID"] as num).toInt(),
      reminder: json["rEMINDER"] as String?,
      reminderStatus: json["REMINDERSTATUS"] as bool?,
      orderNo: json["ORDERNO"] as String?,
      bigId: json["BIGID"] == null ? null : (json["BIGID"] as num).toInt(),
      status1: json["STATUS1"] as String?,
      partNumber: json["PARTNUMBER"] as String?,
      partDesc: json["partdesc"] as String?,
      price: json["Price"] != null ? (json["Price"] as num).toDouble() : null,
      mrp: json["MRP"] != null ? (json["MRP"] as num).toDouble() : null,
      partValue: json["PARTVALUE"] != null
          ? (json["PARTVALUE"] as num).toDouble()
          : null,
      sellerDealerId: json["SellerDealerID"] == null
          ? null
          : (json["SellerDealerID"] as num).toInt(),
      dealerName: json["DealerName"] as String?,
      sellerLocation: json["SELLERLOCATION"] as String?,
      qty: json["QTY"] == null ? null : (json["QTY"] as num).toInt(),
      discount:
          json["DISCOUNT"] == null ? 0 : (json["DISCOUNT"] as num).toInt(),
      sellerStockQty: json["SELLERSTOCKQTY"] == null
          ? null
          : (json["SELLERSTOCKQTY"] as num).toInt(),
      sellerLatestStock: json["SELLERLATESTSTOCK"] == null
          ? null
          : (json["SELLERLATESTSTOCK"] as num).toInt(),
      sellerFreeStock: json["SellerFreeStock"] == null
          ? null
          : (json["SellerFreeStock"] as num).toInt(),
      sellerStockDate: json["SELLERSTOCKDATE"] as String?,
      buyerStockQty: json["BUYERSTOCKQTY"] == null
          ? null
          : (json["BUYERSTOCKQTY"] as num).toInt(),
      buyerLatestStock: json["BUYERLATESTSTOCK"] == null
          ? null
          : (json["BUYERLATESTSTOCK"] as num).toInt(),
      requestDate: json["REQUESTDATE"] as String?,
      dispatchDate: json["DISPATCHDATE"] as String?,
      remarks: json["REMARKS"] as String?,
      requestAcceptRemarks: json["REQUESTACCEPTREMARKS"] as String?,
      partImage: json["PARTIMAGE"] as String?,
      dispatchQty: json["DISPATCHQTY"] == null
          ? null
          : (json["DISPATCHQTY"] as num).toInt(),
      poQty: json["POQty"],
      docketNo: json["DOCKETNO"] as String?,
      dispatchDate1: json["DISPATCHDATE1"] as String?,
      dispatchDetails: json["DISPATCHDETAILS"] as String?,
      dispatchedPart: json["DISPATCHEDPART"] as String?,
      orderFor: json["ORDERFOR"] as String?,
      furtherDetailsRemarks: json["FURTHERDETAILSREMARKS"] as String?,
      responseConfirmRemarks: json["RESPONSECONFIRMREMARKS"] as String?,
      orderStatus: json["ORDERSTATUS"] as String?,
      escalationStage: json["ESCALATIONSTAGE"] as String?,
      dispatchOrderNo: json["DispatchOrderNo"] as String?,
      orderType: json["OrderType"] as String?,
      deliverDate: json["DeliverDate"] as String?,
      deliverStatus: json["DeliverStatus"] as String?,
      eta: json["ETA"] == null ? null : (json["ETA"] as num).toInt(),
      dealerVerified: json["DealerVerified"] as String?,
      scsVerified: json["SCSVerified"] as String?,
      sWeFastTrackUrl: json["sWeFastTrackUrl"] as String?,
      bWeFastTrackUrl: json["bWeFastTrackUrl"] as String?,
      stockCat: json["StockCat"] as String?,
      bufferAction: json["BufferAction"] as String?,
      packingSlip: json["PackingSlip"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Status": status,
      "SellerResponseDate": sellerResponseDate,
      "POConfirmationDate": poConfirmationDate,
      "ManifestationDate": manifestationDate,
      "ReceivingDate": receivingDate,
      "OEMCode": oemCode,
      "LSPStatus": lspStatus,
      "InvoiceNumber": invoiceNumber,
      "InvoiceCopy": invoiceCopy,
      "CrnCopy": crnCopy,
      "CrnAmount": crnAmount,
      "TransporterType": transporterType,
      "CourierType": courierType,
      "PickupRequest": pickupRequest,
      "CompanyCode": companyCode,
      "LRNumber": lrNumber,
      "LRDate": lrDate,
      "ManifestDate": manifestDate,
      "CompanyName": companyName,
      "ManifestRemarks": manifestRemarks,
      "PONUMBER": poNumber,
      "BUYERLATESTDATE": buyerLatestDate,
      "SELLERLOCATIONID": sellerLocationId,
      "rEMINDER": reminder,
      "REMINDERSTATUS": reminderStatus,
      "ORDERNO": orderNo,
      "BIGID": bigId,
      "STATUS1": status1,
      "PARTNUMBER": partNumber,
      "partdesc": partDesc,
      "Price": price,
      "MRP": mrp,
      "PARTVALUE": partValue,
      "SellerDealerID": sellerDealerId,
      "DealerName": dealerName,
      "SELLERLOCATION": sellerLocation,
      "QTY": qty,
      "DISCOUNT": discount,
      "SELLERSTOCKQTY": sellerStockQty,
      "SELLERLATESTSTOCK": sellerLatestStock,
      "SellerFreeStock": sellerFreeStock,
      "SELLERSTOCKDATE": sellerStockDate,
      "BUYERSTOCKQTY": buyerStockQty,
      "BUYERLATESTSTOCK": buyerLatestStock,
      "REQUESTDATE": requestDate,
      "DISPATCHDATE": dispatchDate,
      "REMARKS": remarks,
      "REQUESTACCEPTREMARKS": requestAcceptRemarks,
      "PARTIMAGE": partImage,
      "DISPATCHQTY": dispatchQty,
      "POQty": poQty,
      "DOCKETNO": docketNo,
      "DISPATCHDATE1": dispatchDate1,
      "DISPATCHDETAILS": dispatchDetails,
      "DISPATCHEDPART": dispatchedPart,
      "ORDERFOR": orderFor,
      "FURTHERDETAILSREMARKS": furtherDetailsRemarks,
      "RESPONSECONFIRMREMARKS": responseConfirmRemarks,
      "ORDERSTATUS": orderStatus,
      "ESCALATIONSTAGE": escalationStage,
      "DispatchOrderNo": dispatchOrderNo,
      "OrderType": orderType,
      "DeliverDate": deliverDate,
      "DeliverStatus": deliverStatus,
      "ETA": eta,
      "DealerVerified": dealerVerified,
      "SCSVerified": scsVerified,
      "sWeFastTrackUrl": sWeFastTrackUrl,
      "bWeFastTrackUrl": bWeFastTrackUrl,
      "StockCat": stockCat,
      "BufferAction": bufferAction,
      "PackingSlip": packingSlip,
    };
  }
}
