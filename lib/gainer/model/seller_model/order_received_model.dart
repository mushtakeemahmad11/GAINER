// class OrderReceivedModel {
//   final String status;
//   final String? sellerResponseDate;
//   final String? poConfirmationDate;
//   final String? manifestationDate;
//   final String? receivingDate;
//   final String oemCode;
//   final String sellerClusters;
//   final String buyerClusters;
//   final String? lspStatus;
//   final String? invoiceNumber;
//   final String? invoiceCopy;
//   final String? crnCopy;
//   final double? crnAmount;
//   final String? transporterType;
//   final String pickupRequest;
//   final String? companyCode;
//   final String status1;
//   final String? lrNumber;
//   final String? lrDate;
//   final String? manifestDate;
//   final String? companyName;
//   final String? manifestRemarks;
//   final double? reminder;
//   final bool reminderStatus;
//   final int buyerLocationId;
//   final String orderNo;
//   final int bigId;
//   final String partNumber;
//   final String partDesc;
//   final double price;
//   final double mrp;
//   final double partValue;
//   final int buyerDealerId;
//   final String? buyerDealer;
//   final String buyerLocation;
//   final int qty;
//   final int discount;
//   final int sellerStockQty;
//   final double latestStock;
//   final int sellerFreeStock;
//   final String stockDate;
//   final String requestDate;
//   final String? courierType;
//   final String? dispatchDate;
//   final String remarks;
//   final String? requestAcceptRemarks;
//   final int? dispatchQty;
//   final String? dispatchOrderNo;
//   final String orderType;
//   final String? deliverDate;
//   final String deliverStatus;
//   final String status2;
//   final String? receiverRemarks;
//   final String partImageBuyer;
//   final String orderFor;
//   final String? furtherDetailsRemarks;
//   final String? responseConfirmRemarks;
//   final String? poNumber;
//   final String escalationStage;
//   final int? poQty;
//   final String dispatchRejectionBtnShow;
//   final String deliverStatus1;
//   final int eta;
//   final String dealerVerified;
//   final String scsVerified;
//   final String? sWeFastTrackUrl;
//   final String? bWeFastTrackUrl;
//   final String brand;
//   final String allowCreditNote;
//   final String stockCat;
//   final String stockCatType;
//   final String? bufferAction;
//   final String? packingSlip;
//
//   OrderReceivedModel({
//     required this.status,
//     this.sellerResponseDate,
//     this.poConfirmationDate,
//     this.manifestationDate,
//     this.receivingDate,
//     required this.oemCode,
//     required this.sellerClusters,
//     required this.buyerClusters,
//     this.lspStatus,
//     this.invoiceNumber,
//     this.invoiceCopy,
//     this.crnCopy,
//     this.crnAmount,
//     this.transporterType,
//     required this.pickupRequest,
//     this.companyCode,
//     required this.status1,
//     this.lrNumber,
//     this.lrDate,
//     this.manifestDate,
//     this.companyName,
//     this.manifestRemarks,
//     this.reminder,
//     required this.reminderStatus,
//     required this.buyerLocationId,
//     required this.orderNo,
//     required this.bigId,
//     required this.partNumber,
//     required this.partDesc,
//     required this.price,
//     required this.mrp,
//     required this.partValue,
//     required this.buyerDealerId,
//     required this.buyerDealer,
//     required this.buyerLocation,
//     required this.qty,
//     required this.discount,
//     required this.sellerStockQty,
//     required this.latestStock,
//     required this.sellerFreeStock,
//     required this.stockDate,
//     required this.requestDate,
//     this.courierType,
//     this.dispatchDate,
//     required this.remarks,
//     this.requestAcceptRemarks,
//     this.dispatchQty,
//     this.dispatchOrderNo,
//     required this.orderType,
//     this.deliverDate,
//     required this.deliverStatus,
//     required this.status2,
//     this.receiverRemarks,
//     required this.partImageBuyer,
//     required this.orderFor,
//     this.furtherDetailsRemarks,
//     this.responseConfirmRemarks,
//     this.poNumber,
//     required this.escalationStage,
//     this.poQty,
//     required this.dispatchRejectionBtnShow,
//     required this.deliverStatus1,
//     required this.eta,
//     required this.dealerVerified,
//     required this.scsVerified,
//     this.sWeFastTrackUrl,
//     this.bWeFastTrackUrl,
//     required this.brand,
//     required this.allowCreditNote,
//     required this.stockCat,
//     required this.stockCatType,
//     this.bufferAction,
//     this.packingSlip,
//   });
//
//   // factory OrderReceivedModel.fromJson(Map<String, dynamic> json) => OrderReceivedModel(
//   //   status: json['Status'] ?? '',
//   //   sellerResponseDate: json['SellerResponseDate'] ?? '',
//   //   poConfirmationDate: json['POConfirmationDate'] ?? '',
//   //   manifestationDate: json['ManifestationDate'] ?? '',
//   //   receivingDate: json['ReceivingDate'] ?? '',
//   //   oemCode: json['OEMCode'] ?? '',
//   //   sellerClusters: json['SellerClusters'] ?? '',
//   //   buyerClusters: json['BuyerClusters'] ?? '',
//   //   lspStatus: json['LSPStatus'] ?? '',
//   //   invoiceNumber: json['InvoiceNumber'] ?? '',
//   //   invoiceCopy: json['InvoiceCopy'] ?? '',
//   //   crnCopy: json['CrnCopy'] ?? '',
//   //   crnAmount: (json['CrnAmount'] as num?)?.toDouble() ?? 0.0,
//   //   transporterType: json['TransporterType'] ?? '',
//   //   pickupRequest: json['PickupRequest'] ?? '',
//   //   companyCode: json['CompanyCode'] ?? '',
//   //   status1: json['STATUS1'] ?? '',
//   //   lrNumber: json['LRNumber'] ?? '',
//   //   lrDate: json['LRDate'] ?? '',
//   //   manifestDate: json['ManifestDate'] ?? '',
//   //   companyName: json['CompanyName'] ?? '',
//   //   manifestRemarks: json['ManifestRemarks'] ?? '',
//   //   reminder: json['rEMINDER'] ?? '',
//   //   reminderStatus: json['REMINDERSTATUS'] ?? false,
//   //   buyerLocationId: json['BUYERLOCATIONID'] ?? 0,
//   //   orderNo: json['ORDERNO'] ?? '',
//   //   bigId: json['BIGID'] ?? 0,
//   //   partNumber: json['PARTNUMBER'] ?? '',
//   //   partDesc: json['partdesc'] ?? '',
//   //   price: (json['Price'] as num?)?.toDouble() ?? 0.0,
//   //   mrp: (json['MRP'] as num?)?.toDouble() ?? 0.0,
//   //   partValue: (json['PARTVALUE'] as num?)?.toDouble() ?? 0.0,
//   //   buyerDealerId: json['BuyerDealerID'] ?? 0,
//   //   buyerDealer: json['BUYERDEALER'] ?? '',
//   //   buyerLocation: json['BUYERLOCATION'] ?? '',
//   //   qty: json['QTY'] ?? 0,
//   //   discount: (json['DISCOUNT'] as num?)?.toInt() ?? 0,
//   //   sellerStockQty: json['SELLERSTOCKQTY'] ?? 0,
//   //   latestStock: (json['LATESTSTOCK'] as num?)?.toDouble() ?? 0.0,
//   //   sellerFreeStock: json['SellerFreeStock'] ?? 0,
//   //   stockDate: json['STOCKDATE'] ?? '',
//   //   requestDate: json['REQUESTDATE'] ?? '',
//   //   remarks: json['REMARKS'] ?? '',
//   //   orderType: json['OrderType'] ?? '',
//   //   deliverStatus: json['DeliverStatus'] ?? '',
//   //   status2: json['STATUS2'] ?? '',
//   //   partImageBuyer: json['PARTIMAGEBUYER'] ?? '',
//   //   orderFor: json['ORDERFOR'] ?? '',
//   //   escalationStage: json['ESCALATIONSTAGE'] ?? '',
//   //   dispatchRejectionBtnShow: json['DispatchRejectionBtnShow'] ?? false,
//   //   deliverStatus1: json['DeliverStatus1'] ?? '',
//   //   eta: json['ETA'] ?? '',
//   //   dealerVerified: json['DealerVerified'] ?? '',
//   //   scsVerified: json['SCSVerified'] ?? '',
//   //   brand: json['Brand'] ?? '',
//   //   allowCreditNote: json['AllowCreditNote'] ?? false,
//   //   stockCat: json['StockCat'] ?? '',
//   //   stockCatType: json['StockCatType'] ?? '',
//   // );
//
// factory OrderReceivedModel.fromJson(Map<String, dynamic> json) => OrderReceivedModel(
//     status: json['Status'],
//     sellerResponseDate: json['SellerResponseDate'],
//     poConfirmationDate: json['POConfirmationDate'],
//     manifestationDate: json['ManifestationDate'],
//     receivingDate: json['ReceivingDate'],
//     oemCode: json['OEMCode'],
//     sellerClusters: json['SellerClusters'],
//     buyerClusters: json['BuyerClusters'],
//     lspStatus: json['LSPStatus'],
//     invoiceNumber: json['InvoiceNumber'],
//     invoiceCopy: json['InvoiceCopy'],
//     crnCopy: json['CrnCopy'],
//     crnAmount: (json['CrnAmount'] as num?)?.toDouble(),
//     transporterType: json['TransporterType'],
//     pickupRequest: json['PickupRequest'] ?? '',
//     companyCode: json['CompanyCode'],
//     status1: json['STATUS1'],
//     lrNumber: json['LRNumber'],
//     lrDate: json['LRDate'],
//     manifestDate: json['ManifestDate'],
//     companyName: json['CompanyName'],
//     manifestRemarks: json['ManifestRemarks'],
//     reminder: json['rEMINDER'],
//     reminderStatus: json['REMINDERSTATUS'],
//     buyerLocationId: json['BUYERLOCATIONID'],
//     orderNo: json['ORDERNO'],
//     bigId: json['BIGID'],
//     partNumber: json['PARTNUMBER'],
//     partDesc: json['partdesc'],
//     price: json['Price'].toDouble(),
//     mrp: json['MRP'].toDouble(),
//     partValue: json['PARTVALUE'].toDouble(),
//     buyerDealerId: json['BuyerDealerID'],
//     buyerDealer: json['BUYERDEALER'],
//     buyerLocation: json['BUYERLOCATION'],
//     qty: json['QTY'],
//     discount: json['DISCOUNT'].toInt(),
//     sellerStockQty: json['SELLERSTOCKQTY'],
//     latestStock: json['LATESTSTOCK'].toDouble(),
//     sellerFreeStock: json['SellerFreeStock'],
//     stockDate: json['STOCKDATE'],
//     requestDate: json['REQUESTDATE'],
//     remarks: json['REMARKS'] ?? '',
//     orderType: json['OrderType'],
//     deliverStatus: json['DeliverStatus'],
//     status2: json['STATUS2'],
//     partImageBuyer: json['PARTIMAGEBUYER'],
//     orderFor: json['ORDERFOR'],
//     escalationStage: json['ESCALATIONSTAGE'],
//     dispatchRejectionBtnShow: json['DispatchRejectionBtnShow'],
//     deliverStatus1: json['DeliverStatus1'],
//     eta: json['ETA'],
//     dealerVerified: json['DealerVerified'],
//     scsVerified: json['SCSVerified'],
//     brand: json['Brand'],
//     allowCreditNote: json['AllowCreditNote'],
//     stockCat: json['StockCat']??'',
//     stockCatType: json['StockCatType'],
//   );
// }


class OrderReceivedModel {
  final String status;
  final String? sellerResponseDate;
  final String? poConfirmationDate;
  final String? manifestationDate;
  final String? receivingDate;
  final String? oemCode;
  final String sellerClusters;
  final String buyerClusters;
  final String? lspStatus;
  final String? invoiceNumber;
  final String? invoiceCopy;
  final String? crnCopy;
  final double? crnAmount;
  final String? transporterType;
  final String pickupRequest;
  final String? companyCode;
  final String status1;
  final String? lrNumber;
  final String? lrDate;
  final String? manifestDate;
  final String? companyName;
  final String? manifestRemarks;
  final String? reminder;
  final bool reminderStatus;
  final int buyerLocationId;
  final String orderNo;
  final int bigId;
  final String partNumber;
  final String partDesc;
  final double price;
  final double mrp;
  final double partValue;
  final int buyerDealerId;
  final String buyerDealer;
  final String buyerLocation;
  final int qty;
  final int discount;
  final int sellerStockQty;
  final double latestStock;
  final int sellerFreeStock;
  final String stockDate;
  final String requestDate;
  final String? courierType;
  final String? dispatchDate;
  final String remarks;
  final String? requestAcceptRemarks;
  final int? dispatchQty;
  final String? dispatchOrderNo;
  final String orderType;
  final String? deliverDate;
  final String deliverStatus;
  final String status2;
  final String? receiverRemarks;
  final String partImageBuyer;
  final String orderFor;
  final String? furtherDetailsRemarks;
  final String? responseConfirmRemarks;
  final String? poNumber;
  final String escalationStage;
  final int? poQty;
  final String dispatchRejectionBtnShow;
  final String deliverStatus1;
  final int eta;
  final String dealerVerified;
  final String scsVerified;
  final String? sweFastTrackUrl;
  final String? bweFastTrackUrl;
  final String brand;
  final String allowCreditNote;
  final String? stockCat;
  final String stockCatType;
  final String? bufferAction;
  final String? packingSlip;

  OrderReceivedModel({
    required this.status,
    this.sellerResponseDate,
    this.poConfirmationDate,
    this.manifestationDate,
    this.receivingDate,
    this.oemCode,
    required this.sellerClusters,
    required this.buyerClusters,
    this.lspStatus,
    this.invoiceNumber,
    this.invoiceCopy,
    this.crnCopy,
    this.crnAmount,
    this.transporterType,
    required this.pickupRequest,
    this.companyCode,
    required this.status1,
    this.lrNumber,
    this.lrDate,
    this.manifestDate,
    this.companyName,
    this.manifestRemarks,
    this.reminder,
    required this.reminderStatus,
    required this.buyerLocationId,
    required this.orderNo,
    required this.bigId,
    required this.partNumber,
    required this.partDesc,
    required this.price,
    required this.mrp,
    required this.partValue,
    required this.buyerDealerId,
    required this.buyerDealer,
    required this.buyerLocation,
    required this.qty,
    required this.discount,
    required this.sellerStockQty,
    required this.latestStock,
    required this.sellerFreeStock,
    required this.stockDate,
    required this.requestDate,
    this.courierType,
    this.dispatchDate,
    required this.remarks,
    this.requestAcceptRemarks,
    this.dispatchQty,
    this.dispatchOrderNo,
    required this.orderType,
    this.deliverDate,
    required this.deliverStatus,
    required this.status2,
    this.receiverRemarks,
    required this.partImageBuyer,
    required this.orderFor,
    this.furtherDetailsRemarks,
    this.responseConfirmRemarks,
    this.poNumber,
    required this.escalationStage,
    this.poQty,
    required this.dispatchRejectionBtnShow,
    required this.deliverStatus1,
    required this.eta,
    required this.dealerVerified,
    required this.scsVerified,
    this.sweFastTrackUrl,
    this.bweFastTrackUrl,
    required this.brand,
    required this.allowCreditNote,
    this.stockCat,
    required this.stockCatType,
    this.bufferAction,
    this.packingSlip,
  });

  factory OrderReceivedModel.fromJson(Map<String, dynamic> json) {
    return OrderReceivedModel(
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
      crnAmount: json['CrnAmount']?.toDouble(),
      transporterType: json['TransporterType'],
      pickupRequest: json['PickupRequest'],
      companyCode: json['CompanyCode'],
      status1: json['STATUS1'],
      lrNumber: json['LRNumber'],
      lrDate: json['LRDate'],
      manifestDate: json['ManifestDate'],
      companyName: json['CompanyName'],
      manifestRemarks: json['ManifestRemarks'],
      reminder: json['rEMINDER'].toString(),
      reminderStatus: json['REMINDERSTATUS'],
      buyerLocationId: json['BUYERLOCATIONID'],
      orderNo: json['ORDERNO'],
      bigId: json['BIGID'],
      partNumber: json['PARTNUMBER'],
      partDesc: json['partdesc'],
      price: json['Price']?.toDouble() ?? 0.0,
      mrp: json['MRP']?.toDouble() ?? 0.0,
      partValue: json['PARTVALUE']?.toDouble() ?? 0.0,
      buyerDealerId: json['BuyerDealerID'],
      buyerDealer: json['BUYERDEALER'],
      buyerLocation: json['BUYERLOCATION'],
      qty: json['QTY'],
      discount: json['DISCOUNT'].toInt(),
      sellerStockQty: json['SELLERSTOCKQTY'],
      latestStock: (json['LATESTSTOCK'] as num?)?.toDouble() ?? 0.0,
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
}

