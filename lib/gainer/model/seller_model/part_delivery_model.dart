class PartDeliveryModel {
  final String status;
  final String sellerResponseDate;
  final String poConfirmationDate;
  final String manifestationDate;
  final String? receivingDate;
  final String oemCode;
  final String sellerClusters;
  final String buyerClusters;
  final String lspStatus;
  final String invoiceNumber;
  final String invoiceCopy;
  final String? crnCopy;
  final num? crnAmount;
  final String? transporterType;
  final String pickupRequest;
  final int companyCode;
  final String status1;
  final String lrNumber;
  final String lrDate;
  final String manifestDate;
  final String companyName;
  final String manifestRemarks;
  final double reminder;
  final bool reminderStatus;
  final int buyerLocationId;
  final String orderNo;
  final int bigId;
  final String partNumber;
  final String partdesc;
  final num price;
  final num mrp;
  final double partvalue;
  final int buyerDealerId;
  final String buyerDealer;
  final String buyerLocation;
  final int qty;
  final double discount;
  final int sellerStockQty;
  final double latestStock;
  final int sellerFreeStock;
  final String stockDate;
  final String? requestDate;
  final String? courierType;
  final String dispatchDate;
  final String? remarks;
  final String? requestAcceptRemarks;
  final int dispatchQty;
  final String dispatchOrderNo;
  final String orderType;
  final String? deliverDate;
  final String deliverStatus;
  final String status2;
  final String? receiverRemarks;
  final String partImageBuyer;
  final String orderFor;
  final String? furtherDetailsRemarks;
  final String responseConfirmRemarks;
  final String poNumber;
  final String escalationStage;
  final int poQty;
  final String dispatchRejectionBtnShow;
  final String deliverStatus1;
  final int eta;
  final String dealerVerified;
  final String scsVerified;
  final String? sWeFastTrackUrl;
  final String? bWeFastTrackUrl;
  final String brand;
  final String allowCreditNote;
  final String? stockCat;
  final String stockCatType;
  final String bufferAction;
  final String? packingSlip;

  PartDeliveryModel({
    required this.status,
    required this.sellerResponseDate,
    required this.poConfirmationDate,
    required this.manifestationDate,
    this.receivingDate,
    required this.oemCode,
    required this.sellerClusters,
    required this.buyerClusters,
    required this.lspStatus,
    required this.invoiceNumber,
    required this.invoiceCopy,
    this.crnCopy,
    this.crnAmount,
    this.transporterType,
    required this.pickupRequest,
    required this.companyCode,
    required this.status1,
    required this.lrNumber,
    required this.lrDate,
    required this.manifestDate,
    required this.companyName,
    required this.manifestRemarks,
    required this.reminder,
    required this.reminderStatus,
    required this.buyerLocationId,
    required this.orderNo,
    required this.bigId,
    required this.partNumber,
    required this.partdesc,
    required this.price,
    required this.mrp,
    required this.partvalue,
    required this.buyerDealerId,
    required this.buyerDealer,
    required this.buyerLocation,
    required this.qty,
    required this.discount,
    required this.sellerStockQty,
    required this.latestStock,
    required this.sellerFreeStock,
    required this.stockDate,
    this.requestDate,
    this.courierType,
    required this.dispatchDate,
    this.remarks,
    this.requestAcceptRemarks,
    required this.dispatchQty,
    required this.dispatchOrderNo,
    required this.orderType,
    this.deliverDate,
    required this.deliverStatus,
    required this.status2,
    this.receiverRemarks,
    required this.partImageBuyer,
    required this.orderFor,
    this.furtherDetailsRemarks,
    required this.responseConfirmRemarks,
    required this.poNumber,
    required this.escalationStage,
    required this.poQty,
    required this.dispatchRejectionBtnShow,
    required this.deliverStatus1,
    required this.eta,
    required this.dealerVerified,
    required this.scsVerified,
    this.sWeFastTrackUrl,
    this.bWeFastTrackUrl,
    required this.brand,
    required this.allowCreditNote,
    this.stockCat,
    required this.stockCatType,
    required this.bufferAction,
    this.packingSlip,
  });

  factory PartDeliveryModel.fromJson(Map<String, dynamic> json) {
    return PartDeliveryModel(
      status: json['Status'] as String,
      sellerResponseDate: json['SellerResponseDate'] as String,
      poConfirmationDate: json['POConfirmationDate'] as String,
      manifestationDate: json['ManifestationDate'] as String,
      receivingDate: json['ReceivingDate'] as String?,
      oemCode: json['OEMCode'] as String,
      sellerClusters: json['SellerClusters'] as String,
      buyerClusters: json['BuyerClusters'] as String,
      lspStatus: json['LSPStatus'] as String,
      invoiceNumber: json['InvoiceNumber'] as String,
      invoiceCopy: json['InvoiceCopy'] as String,
      crnCopy: json['CrnCopy'] as String?,
      crnAmount: json['CrnAmount'] is int
          ? (json['CrnAmount'] as int).toDouble()
          : json['CrnAmount'] as double?,
      transporterType: json['TransporterType'] as String?,
      pickupRequest: json['PickupRequest'] as String,
      companyCode: json['CompanyCode'] as int,
      status1: json['STATUS1'] as String,
      lrNumber: json['LRNumber'] as String,
      lrDate: json['LRDate'] as String,
      manifestDate: json['ManifestDate'] as String,
      companyName: json['CompanyName'] as String,
      manifestRemarks: json['ManifestRemarks'] as String,
      reminder: json['rEMINDER'] is int
          ? (json['rEMINDER'] as int).toDouble()
          : json['rEMINDER'] as double,
      reminderStatus: json['REMINDERSTATUS'] as bool,
      buyerLocationId: json['BUYERLOCATIONID'] as int,
      orderNo: json['ORDERNO'] as String,
      bigId: json['BIGID'] as int,
      partNumber: json['PARTNUMBER'] as String,
      partdesc: json['partdesc'] as String,
      price: json['Price'] as num,
      mrp: json['MRP'] as num,
      partvalue: json['PARTVALUE'] is int
          ? (json['PARTVALUE'] as int).toDouble()
          : json['PARTVALUE'] as double,
      buyerDealerId: json['BuyerDealerID'] as int,
      buyerDealer: json['BUYERDEALER'] as String,
      buyerLocation: json['BUYERLOCATION'] as String,
      qty: json['QTY'] as int,
      discount: json['DISCOUNT'] as double,
      sellerStockQty: json['SELLERSTOCKQTY'] as int,
      latestStock: json['LATESTSTOCK'] as double,
      sellerFreeStock: json['SellerFreeStock'] as int,
      stockDate: json['STOCKDATE'] as String,
      requestDate: json['REQUESTDATE'] as String?,
      courierType: json['CourierType'] as String?,
      dispatchDate: json['DISPATCHDATE'] as String,
      remarks: json['REMARKS'] as String?,
      requestAcceptRemarks: json['REQUESTACCEPTREMARKS'] as String?,
      dispatchQty: json['DISPATCHQTY'] as int,
      dispatchOrderNo: json['DispatchOrderNo'] as String,
      orderType: json['OrderType'] as String,
      deliverDate: json['DeliverDate'] as String?,
      deliverStatus: json['DeliverStatus'] as String,
      status2: json['STATUS2'] as String,
      receiverRemarks: json['RECEIVEREMARKS'] as String?,
      partImageBuyer: json['PARTIMAGEBUYER'] as String,
      orderFor: json['ORDERFOR'] as String,
      furtherDetailsRemarks: json['FURTHERDETAILSREMARKS'] as String?,
      responseConfirmRemarks: json['RESPONSECONFIRMREMARKS'] as String,
      poNumber: json['PONUMBER'] as String,
      escalationStage: json['ESCALATIONSTAGE'] as String,
      poQty: json['POQTY'] as int,
      dispatchRejectionBtnShow: json['DispatchRejectionBtnShow'] as String,
      deliverStatus1: json['DeliverStatus1'] as String,
      eta: json['ETA'] as int,
      dealerVerified: json['DealerVerified'] as String,
      scsVerified: json['SCSVerified'] as String,
      sWeFastTrackUrl: json['sWeFastTrackUrl'] as String?,
      bWeFastTrackUrl: json['bWeFastTrackUrl'] as String?,
      brand: json['Brand'] as String,
      allowCreditNote: json['AllowCreditNote'] as String,
      stockCat: json['StockCat'] as String?,
      stockCatType: json['StockCatType'] as String,
      bufferAction: json['BufferAction'] as String,
      packingSlip: json['PackingSlip'] as String?,
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
      'rEMINDER': reminder,
      'REMINDERSTATUS': reminderStatus,
      'BUYERLOCATIONID': buyerLocationId,
      'ORDERNO': orderNo,
      'BIGID': bigId,
      'PARTNUMBER': partNumber,
      'partdesc': partdesc,
      'Price': price,
      'MRP': mrp,
      'PARTVALUE': partvalue,
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
      'sWeFastTrackUrl': sWeFastTrackUrl,
      'bWeFastTrackUrl': bWeFastTrackUrl,
      'Brand': brand,
      'AllowCreditNote': allowCreditNote,
      'StockCat': stockCat,
      'StockCatType': stockCatType,
      'BufferAction': bufferAction,
      'PackingSlip': packingSlip,
    };
  }
}
