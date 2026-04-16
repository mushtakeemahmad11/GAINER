class ManifestationModel {
  String? status;
  String? sellerResponseDate;
  String? poConfirmationDate;
  String? manifestationDate;
  String? receivingDate;
  String? oemCode;
  String? sellerClusters;
  String? buyerClusters;
  String? lspStatus;
  String? invoiceNumber;
  String? invoiceCopy;
  String? crnCopy;
  String? crnAmount;
  String? transporterType;
  String? pickupRequest;
  String? companyCode;
  String? status1;
  String? lrNumber;
  String? lrDate;
  String? manifestDate;
  String? companyName;
  String? manifestRemarks;
  double? reminder;
  bool? reminderStatus;
  int? buyerLocationId;
  String? orderNo;
  int? bigId;
  String? partNumber;
  String? partDesc;
  int? price;
  double? mrp;
  double? partValue;
  int? buyerDealerId;
  String? buyerDealer;
  String? buyerLocation;
  int? qty;
  double? discount;
  int? sellerStockQty;
  double? latestStock;
  int? sellerFreeStock;
  String? stockDate;
  String? requestDate;
  String? courierType;
  String? dispatchDate;
  String? remarks;
  String? requestAcceptRemarks;
  int? dispatchQty;
  String? dispatchOrderNo;
  String? orderType;
  String? deliverDate;
  String? deliverStatus;
  String? status2;
  String? receiverRemarks;
  String? partImageBuyer;
  String? orderFor;
  String? furtherDetailsRemarks;
  String? responseConfirmRemarks;
  String? poNumber;
  String? escalationStage;
  int? poQty;
  String? dispatchRejectionBtnShow;
  String? deliverStatus1;
  int? eta;
  String? dealerVerified;
  String? scsVerified;
  String? sweFastTrackUrl;
  String? bweFastTrackUrl;
  String? brand;
  String? allowCreditNote;
  String? stockCat;
  String? stockCatType;
  String? bufferAction;
  String? packingSlip;

  ManifestationModel({
    this.status,
    this.sellerResponseDate,
    this.poConfirmationDate,
    this.manifestationDate,
    this.receivingDate,
    this.oemCode,
    this.sellerClusters,
    this.buyerClusters,
    this.lspStatus,
    this.invoiceNumber,
    this.invoiceCopy,
    this.crnCopy,
    this.crnAmount,
    this.transporterType,
    this.pickupRequest,
    this.companyCode,
    this.status1,
    this.lrNumber,
    this.lrDate,
    this.manifestDate,
    this.companyName,
    this.manifestRemarks,
    this.reminder,
    this.reminderStatus,
    this.buyerLocationId,
    this.orderNo,
    this.bigId,
    this.partNumber,
    this.partDesc,
    this.price,
    this.mrp,
    this.partValue,
    this.buyerDealerId,
    this.buyerDealer,
    this.buyerLocation,
    this.qty,
    this.discount,
    this.sellerStockQty,
    this.latestStock,
    this.sellerFreeStock,
    this.stockDate,
    this.requestDate,
    this.courierType,
    this.dispatchDate,
    this.remarks,
    this.requestAcceptRemarks,
    this.dispatchQty,
    this.dispatchOrderNo,
    this.orderType,
    this.deliverDate,
    this.deliverStatus,
    this.status2,
    this.receiverRemarks,
    this.partImageBuyer,
    this.orderFor,
    this.furtherDetailsRemarks,
    this.responseConfirmRemarks,
    this.poNumber,
    this.escalationStage,
    this.poQty,
    this.dispatchRejectionBtnShow,
    this.deliverStatus1,
    this.eta,
    this.dealerVerified,
    this.scsVerified,
    this.sweFastTrackUrl,
    this.bweFastTrackUrl,
    this.brand,
    this.allowCreditNote,
    this.stockCat,
    this.stockCatType,
    this.bufferAction,
    this.packingSlip,
  });

  factory ManifestationModel.fromJson(Map<String, dynamic> json) {
    return ManifestationModel(
      status: json['Status'],
      sellerResponseDate: json['SellerResponseDate'],
      poConfirmationDate: json['POConfirmationDate'],
      manifestationDate: json['ManifestationDate'],
      receivingDate: json['ReceivingDate'],
      oemCode: json['OEMCode'],
      sellerClusters: json['SellerClusters'],
      buyerClusters: json['BuyerClusters'],
      lspStatus: json['LSPStatus'],
      invoiceNumber: json['InvoiceNumber'],
      invoiceCopy: json['InvoiceCopy'],
      crnCopy: json['CrnCopy'],
      crnAmount: json['CrnAmount'],
      transporterType: json['TransporterType'],
      pickupRequest: json['PickupRequest'],
      companyCode: json['CompanyCode'],
      status1: json['STATUS1'],
      lrNumber: json['LRNumber'],
      lrDate: json['LRDate'],
      manifestDate: json['ManifestDate'],
      companyName: json['CompanyName'],
      manifestRemarks: json['ManifestRemarks'],
      reminder: json['REMINDER']?.toDouble(),
      reminderStatus: json['REMINDERSTATUS'],
      buyerLocationId: json['BUYERLOCATIONID'],
      orderNo: json['ORDERNO'],
      bigId: json['BIGID'],
      partNumber: json['PARTNUMBER'],
      partDesc: json['partdesc'],
      price: json['Price'],
      mrp: json['MRP'],
      partValue: json['PARTVALUE']?.toDouble(),
      buyerDealerId: json['BuyerDealerID'],
      buyerDealer: json['BUYERDEALER'],
      buyerLocation: json['BUYERLOCATION'],
      qty: json['QTY'],
      discount: json['DISCOUNT'],
      sellerStockQty: json['SELLERSTOCKQTY'],
      latestStock: json['LATESTSTOCK'],
      sellerFreeStock: json['SellerFreeStock'],
      stockDate: json['STOCKDATE'],
      requestDate: json['REQUESTDATE'],
      courierType: json['CourierType'],
      dispatchDate: json['DISPATCHDATE'],
      remarks: json['REMARKS'],
      requestAcceptRemarks: json['REQUESTACCEPTREMARKS'],
      dispatchQty: json['DISPATCHQTY'],
      dispatchOrderNo: json['DispatchOrderNo'],
      orderType: json['OrderType'],
      deliverDate: json['DeliverDate'],
      deliverStatus: json['DeliverStatus'],
      status2: json['STATUS2'],
      receiverRemarks: json['RECEIVEREMARKS'],
      partImageBuyer: json['PARTIMAGEBUYER'],
      orderFor: json['ORDERFOR'],
      furtherDetailsRemarks: json['FURTHERDETAILSREMARKS'],
      responseConfirmRemarks: json['RESPONSECONFIRMREMARKS'],
      poNumber: json['PONUMBER'],
      escalationStage: json['ESCALATIONSTAGE'],
      poQty: json['POQTY'],
      dispatchRejectionBtnShow: json['DispatchRejectionBtnShow'],
      deliverStatus1: json['DeliverStatus1'],
      eta: json['ETA'],
      dealerVerified: json['DealerVerified'],
      scsVerified: json['SCSVerified'],
      sweFastTrackUrl: json['sWeFastTrackUrl'],
      bweFastTrackUrl: json['bWeFastTrackUrl'],
      brand: json['Brand'],
      allowCreditNote: json['AllowCreditNote'],
      stockCat: json['StockCat'],
      stockCatType: json['StockCatType'],
      bufferAction: json['BufferAction'],
      packingSlip: json['PackingSlip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'SellerResponseDate': sellerResponseDate,
      'POConfirmationDate': poConfirmationDate,
      'ManifestationDate': manifestationDate,
      'ReceivingDate': receivingDate,
      'OEMCode': oemCode,
      'SellerClusters': sellerClusters,
      'BuyerClusters': buyerClusters,
      'LSPStatus': lspStatus,
      'InvoiceNumber': invoiceNumber,
      'InvoiceCopy': invoiceCopy,
      'CrnCopy': crnCopy,
      'CrnAmount': crnAmount,
      'TransporterType': transporterType,
      'PickupRequest': pickupRequest,
      'CompanyCode': companyCode,
      'STATUS1': status1,
      'LRNumber': lrNumber,
      'LRDate': lrDate,
      'ManifestDate': manifestDate,
      'CompanyName': companyName,
      'ManifestRemarks': manifestRemarks,
      'REMINDER': reminder,
      'REMINDERSTATUS': reminderStatus,
      'BUYERLOCATIONID': buyerLocationId,
      'ORDERNO': orderNo,
      'BIGID': bigId,
      'PARTNUMBER': partNumber,
      'partdesc': partDesc,
      'Price': price,
      'MRP': mrp,
      'PARTVALUE': partValue,
      'BuyerDealerID': buyerDealerId,
      'BUYERDEALER': buyerDealer,
      'BUYERLOCATION': buyerLocation,
      'QTY': qty,
      'DISCOUNT': discount,
      'SELLERSTOCKQTY': sellerStockQty,
      'LATESTSTOCK': latestStock,
      'SellerFreeStock': sellerFreeStock,
      'STOCKDATE': stockDate,
      'REQUESTDATE': requestDate,
      'CourierType': courierType,
      'DISPATCHDATE': dispatchDate,
      'REMARKS': remarks,
      'REQUESTACCEPTREMARKS': requestAcceptRemarks,
      'DISPATCHQTY': dispatchQty,
      'DispatchOrderNo': dispatchOrderNo,
      'OrderType': orderType,
      'DeliverDate': deliverDate,
      'DeliverStatus': deliverStatus,
      'STATUS2': status2,
      'RECEIVEREMARKS': receiverRemarks,
      'PARTIMAGEBUYER': partImageBuyer,
      'ORDERFOR': orderFor,
      'FURTHERDETAILSREMARKS': furtherDetailsRemarks,
      'RESPONSECONFIRMREMARKS': responseConfirmRemarks,
      'PONUMBER': poNumber,
      'ESCALATIONSTAGE': escalationStage,
      'POQTY': poQty,
      'DispatchRejectionBtnShow': dispatchRejectionBtnShow,
      'DeliverStatus1': deliverStatus1,
      'ETA': eta,
      'DealerVerified': dealerVerified,
      'SCSVerified': scsVerified,
      'sWeFastTrackUrl': sweFastTrackUrl,
      'bWeFastTrackUrl': bweFastTrackUrl,
      'Brand': brand,
      'AllowCreditNote': allowCreditNote,
      'StockCat': stockCat,
      'StockCatType': stockCatType,
      'BufferAction': bufferAction,
      'PackingSlip': packingSlip,
    };
  }
}
