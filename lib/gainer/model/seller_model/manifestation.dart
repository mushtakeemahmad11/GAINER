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


// class ManifestationModel {
//   String? status;
//   String? sellerResponseDate;
//   String? pOConfirmationDate;
//   Null? manifestationDate;
//   Null? receivingDate;
//   String? oEMCode;
//   String? sellerClusters;
//   String? buyerClusters;
//   Null? lSPStatus;
//   Null? invoiceNumber;
//   Null? invoiceCopy;
//   Null? crnCopy;
//   Null? crnAmount;
//   String? transporterType;
//   String? pickupRequest;
//   Null? companyCode;
//   String? sTATUS1;
//   Null? lRNumber;
//   Null? lRDate;
//   Null? manifestDate;
//   Null? companyName;
//   Null? manifestRemarks;
//   double? rEMINDER;
//   bool? rEMINDERSTATUS;
//   int? bUYERLOCATIONID;
//   String? oRDERNO;
//   int? bIGID;
//   String? pARTNUMBER;
//   String? partdesc;
//   int? price;
//   int? mRP;
//   double? pARTVALUE;
//   int? buyerDealerID;
//   String? bUYERDEALER;
//   String? bUYERLOCATION;
//   int? qTY;
//   int? dISCOUNT;
//   int? sELLERSTOCKQTY;
//   int? lATESTSTOCK;
//   int? sellerFreeStock;
//   String? sTOCKDATE;
//   String? rEQUESTDATE;
//   String? courierType;
//   Null? dISPATCHDATE;
//   String? rEMARKS;
//   String? rEQUESTACCEPTREMARKS;
//   int? dISPATCHQTY;
//   Null? dispatchOrderNo;
//   String? orderType;
//   Null? deliverDate;
//   String? deliverStatus;
//   String? sTATUS2;
//   Null? rECEIVEREMARKS;
//   String? pARTIMAGEBUYER;
//   String? oRDERFOR;
//   Null? fURTHERDETAILSREMARKS;
//   String? rESPONSECONFIRMREMARKS;
//   String? pONUMBER;
//   String? eSCALATIONSTAGE;
//   int? pOQTY;
//   String? dispatchRejectionBtnShow;
//   String? deliverStatus1;
//   int? eTA;
//   String? dealerVerified;
//   String? sCSVerified;
//   Null? sWeFastTrackUrl;
//   Null? bWeFastTrackUrl;
//   String? brand;
//   String? allowCreditNote;
//   Null? stockCat;
//   String? stockCatType;
//   Null? bufferAction;
//   Null? packingSlip;
//
//   ManifestationModel(
//       {this.status,
//         this.sellerResponseDate,
//         this.pOConfirmationDate,
//         this.manifestationDate,
//         this.receivingDate,
//         this.oEMCode,
//         this.sellerClusters,
//         this.buyerClusters,
//         this.lSPStatus,
//         this.invoiceNumber,
//         this.invoiceCopy,
//         this.crnCopy,
//         this.crnAmount,
//         this.transporterType,
//         this.pickupRequest,
//         this.companyCode,
//         this.sTATUS1,
//         this.lRNumber,
//         this.lRDate,
//         this.manifestDate,
//         this.companyName,
//         this.manifestRemarks,
//         this.rEMINDER,
//         this.rEMINDERSTATUS,
//         this.bUYERLOCATIONID,
//         this.oRDERNO,
//         this.bIGID,
//         this.pARTNUMBER,
//         this.partdesc,
//         this.price,
//         this.mRP,
//         this.pARTVALUE,
//         this.buyerDealerID,
//         this.bUYERDEALER,
//         this.bUYERLOCATION,
//         this.qTY,
//         this.dISCOUNT,
//         this.sELLERSTOCKQTY,
//         this.lATESTSTOCK,
//         this.sellerFreeStock,
//         this.sTOCKDATE,
//         this.rEQUESTDATE,
//         this.courierType,
//         this.dISPATCHDATE,
//         this.rEMARKS,
//         this.rEQUESTACCEPTREMARKS,
//         this.dISPATCHQTY,
//         this.dispatchOrderNo,
//         this.orderType,
//         this.deliverDate,
//         this.deliverStatus,
//         this.sTATUS2,
//         this.rECEIVEREMARKS,
//         this.pARTIMAGEBUYER,
//         this.oRDERFOR,
//         this.fURTHERDETAILSREMARKS,
//         this.rESPONSECONFIRMREMARKS,
//         this.pONUMBER,
//         this.eSCALATIONSTAGE,
//         this.pOQTY,
//         this.dispatchRejectionBtnShow,
//         this.deliverStatus1,
//         this.eTA,
//         this.dealerVerified,
//         this.sCSVerified,
//         this.sWeFastTrackUrl,
//         this.bWeFastTrackUrl,
//         this.brand,
//         this.allowCreditNote,
//         this.stockCat,
//         this.stockCatType,
//         this.bufferAction,
//         this.packingSlip});
//
//   ManifestationModel.fromJson(Map<String, dynamic> json) {
//     status = json['Status'];
//     sellerResponseDate = json['SellerResponseDate'];
//     pOConfirmationDate = json['POConfirmationDate'];
//     manifestationDate = json['ManifestationDate'];
//     receivingDate = json['ReceivingDate'];
//     oEMCode = json['OEMCode'];
//     sellerClusters = json['SellerClusters'];
//     buyerClusters = json['BuyerClusters'];
//     lSPStatus = json['LSPStatus'];
//     invoiceNumber = json['InvoiceNumber'];
//     invoiceCopy = json['InvoiceCopy'];
//     crnCopy = json['CrnCopy'];
//     crnAmount = json['CrnAmount'];
//     transporterType = json['TransporterType'];
//     pickupRequest = json['PickupRequest'];
//     companyCode = json['CompanyCode'];
//     sTATUS1 = json['STATUS1'];
//     lRNumber = json['LRNumber'];
//     lRDate = json['LRDate'];
//     manifestDate = json['ManifestDate'];
//     companyName = json['CompanyName'];
//     manifestRemarks = json['ManifestRemarks'];
//     rEMINDER = json['rEMINDER'];
//     rEMINDERSTATUS = json['REMINDERSTATUS'];
//     bUYERLOCATIONID = json['BUYERLOCATIONID'];
//     oRDERNO = json['ORDERNO'];
//     bIGID = json['BIGID'];
//     pARTNUMBER = json['PARTNUMBER'];
//     partdesc = json['partdesc'];
//     price = json['Price'];
//     mRP = json['MRP'];
//     pARTVALUE = json['PARTVALUE'];
//     buyerDealerID = json['BuyerDealerID'];
//     bUYERDEALER = json['BUYERDEALER'];
//     bUYERLOCATION = json['BUYERLOCATION'];
//     qTY = json['QTY'];
//     dISCOUNT = json['DISCOUNT'];
//     sELLERSTOCKQTY = json['SELLERSTOCKQTY'];
//     lATESTSTOCK = json['LATESTSTOCK'];
//     sellerFreeStock = json['SellerFreeStock'];
//     sTOCKDATE = json['STOCKDATE'];
//     rEQUESTDATE = json['REQUESTDATE'];
//     courierType = json['CourierType'];
//     dISPATCHDATE = json['DISPATCHDATE'];
//     rEMARKS = json['REMARKS'];
//     rEQUESTACCEPTREMARKS = json['REQUESTACCEPTREMARKS'];
//     dISPATCHQTY = json['DISPATCHQTY'];
//     dispatchOrderNo = json['DispatchOrderNo'];
//     orderType = json['OrderType'];
//     deliverDate = json['DeliverDate'];
//     deliverStatus = json['DeliverStatus'];
//     sTATUS2 = json['STATUS2'];
//     rECEIVEREMARKS = json['RECEIVEREMARKS'];
//     pARTIMAGEBUYER = json['PARTIMAGEBUYER'];
//     oRDERFOR = json['ORDERFOR'];
//     fURTHERDETAILSREMARKS = json['FURTHERDETAILSREMARKS'];
//     rESPONSECONFIRMREMARKS = json['RESPONSECONFIRMREMARKS'];
//     pONUMBER = json['PONUMBER'];
//     eSCALATIONSTAGE = json['ESCALATIONSTAGE'];
//     pOQTY = json['POQTY'];
//     dispatchRejectionBtnShow = json['DispatchRejectionBtnShow'];
//     deliverStatus1 = json['DeliverStatus1'];
//     eTA = json['ETA'];
//     dealerVerified = json['DealerVerified'];
//     sCSVerified = json['SCSVerified'];
//     sWeFastTrackUrl = json['sWeFastTrackUrl'];
//     bWeFastTrackUrl = json['bWeFastTrackUrl'];
//     brand = json['Brand'];
//     allowCreditNote = json['AllowCreditNote'];
//     stockCat = json['StockCat'];
//     stockCatType = json['StockCatType'];
//     bufferAction = json['BufferAction'];
//     packingSlip = json['PackingSlip'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Status'] = this.status;
//     data['SellerResponseDate'] = this.sellerResponseDate;
//     data['POConfirmationDate'] = this.pOConfirmationDate;
//     data['ManifestationDate'] = this.manifestationDate;
//     data['ReceivingDate'] = this.receivingDate;
//     data['OEMCode'] = this.oEMCode;
//     data['SellerClusters'] = this.sellerClusters;
//     data['BuyerClusters'] = this.buyerClusters;
//     data['LSPStatus'] = this.lSPStatus;
//     data['InvoiceNumber'] = this.invoiceNumber;
//     data['InvoiceCopy'] = this.invoiceCopy;
//     data['CrnCopy'] = this.crnCopy;
//     data['CrnAmount'] = this.crnAmount;
//     data['TransporterType'] = this.transporterType;
//     data['PickupRequest'] = this.pickupRequest;
//     data['CompanyCode'] = this.companyCode;
//     data['STATUS1'] = this.sTATUS1;
//     data['LRNumber'] = this.lRNumber;
//     data['LRDate'] = this.lRDate;
//     data['ManifestDate'] = this.manifestDate;
//     data['CompanyName'] = this.companyName;
//     data['ManifestRemarks'] = this.manifestRemarks;
//     data['rEMINDER'] = this.rEMINDER;
//     data['REMINDERSTATUS'] = this.rEMINDERSTATUS;
//     data['BUYERLOCATIONID'] = this.bUYERLOCATIONID;
//     data['ORDERNO'] = this.oRDERNO;
//     data['BIGID'] = this.bIGID;
//     data['PARTNUMBER'] = this.pARTNUMBER;
//     data['partdesc'] = this.partdesc;
//     data['Price'] = this.price;
//     data['MRP'] = this.mRP;
//     data['PARTVALUE'] = this.pARTVALUE;
//     data['BuyerDealerID'] = this.buyerDealerID;
//     data['BUYERDEALER'] = this.bUYERDEALER;
//     data['BUYERLOCATION'] = this.bUYERLOCATION;
//     data['QTY'] = this.qTY;
//     data['DISCOUNT'] = this.dISCOUNT;
//     data['SELLERSTOCKQTY'] = this.sELLERSTOCKQTY;
//     data['LATESTSTOCK'] = this.lATESTSTOCK;
//     data['SellerFreeStock'] = this.sellerFreeStock;
//     data['STOCKDATE'] = this.sTOCKDATE;
//     data['REQUESTDATE'] = this.rEQUESTDATE;
//     data['CourierType'] = this.courierType;
//     data['DISPATCHDATE'] = this.dISPATCHDATE;
//     data['REMARKS'] = this.rEMARKS;
//     data['REQUESTACCEPTREMARKS'] = this.rEQUESTACCEPTREMARKS;
//     data['DISPATCHQTY'] = this.dISPATCHQTY;
//     data['DispatchOrderNo'] = this.dispatchOrderNo;
//     data['OrderType'] = this.orderType;
//     data['DeliverDate'] = this.deliverDate;
//     data['DeliverStatus'] = this.deliverStatus;
//     data['STATUS2'] = this.sTATUS2;
//     data['RECEIVEREMARKS'] = this.rECEIVEREMARKS;
//     data['PARTIMAGEBUYER'] = this.pARTIMAGEBUYER;
//     data['ORDERFOR'] = this.oRDERFOR;
//     data['FURTHERDETAILSREMARKS'] = this.fURTHERDETAILSREMARKS;
//     data['RESPONSECONFIRMREMARKS'] = this.rESPONSECONFIRMREMARKS;
//     data['PONUMBER'] = this.pONUMBER;
//     data['ESCALATIONSTAGE'] = this.eSCALATIONSTAGE;
//     data['POQTY'] = this.pOQTY;
//     data['DispatchRejectionBtnShow'] = this.dispatchRejectionBtnShow;
//     data['DeliverStatus1'] = this.deliverStatus1;
//     data['ETA'] = this.eTA;
//     data['DealerVerified'] = this.dealerVerified;
//     data['SCSVerified'] = this.sCSVerified;
//     data['sWeFastTrackUrl'] = this.sWeFastTrackUrl;
//     data['bWeFastTrackUrl'] = this.bWeFastTrackUrl;
//     data['Brand'] = this.brand;
//     data['AllowCreditNote'] = this.allowCreditNote;
//     data['StockCat'] = this.stockCat;
//     data['StockCatType'] = this.stockCatType;
//     data['BufferAction'] = this.bufferAction;
//     data['PackingSlip'] = this.packingSlip;
//     return data;
//   }
// }



// class ManifestationModel {
//   StatusEnum status;
//   String sellerResponseDate;
//   String poConfirmationDate;
//   dynamic manifestationDate;
//   dynamic receivingDate;
//   OemCode oemCode;
//   String sellerClusters;
//   String buyerClusters;
//   dynamic lspStatus;
//   dynamic invoiceNumber;
//   dynamic invoiceCopy;
//   dynamic crnCopy;
//   dynamic crnAmount;
//   TransporterType transporterType;
//   String pickupRequest;
//   dynamic companyCode;
//   Status status1;
//   dynamic lrNumber;
//   dynamic lrDate;
//   dynamic manifestDate;
//   dynamic companyName;
//   dynamic manifestRemarks;
//   double rEminder;
//   bool reminderstatus;
//   int buyerlocationid;
//   String orderno;
//   int bigid;
//   String partnumber;
//   String partdesc;
//   int price;
//   int mrp;
//   double partvalue;
//   int buyerDealerId;
//   Buyerdealer buyerdealer;
//   Buyerlocation buyerlocation;
//   int qty;
//   int discount;
//   int sellerstockqty;
//   int lateststock;
//   int sellerFreeStock;
//   Stockdate stockdate;
//   String requestdate;
//   CourierType courierType;
//   dynamic dispatchdate;
//   String remarks;
//   String requestacceptremarks;
//   int dispatchqty;
//   dynamic dispatchOrderNo;
//   OrderType orderType;
//   dynamic deliverDate;
//   DeliverStatus deliverStatus;
//   Status status2;
//   dynamic receiveremarks;
//   String partimagebuyer;
//   Orderfor orderfor;
//   String? furtherdetailsremarks;
//   String responseconfirmremarks;
//   String ponumber;
//   String escalationstage;
//   int poqty;
//   AllowCreditNote dispatchRejectionBtnShow;
//   DeliverStatus deliverStatus1;
//   int eta;
//   Verified dealerVerified;
//   Verified scsVerified;
//   dynamic sWeFastTrackUrl;
//   dynamic bWeFastTrackUrl;
//   Brand brand;
//   AllowCreditNote allowCreditNote;
//   String? stockCat;
//   AllowCreditNote stockCatType;
//   dynamic bufferAction;
//   dynamic packingSlip;
//
//   ManifestationModel({
//     required this.status,
//     required this.sellerResponseDate,
//     required this.poConfirmationDate,
//     required this.manifestationDate,
//     required this.receivingDate,
//     required this.oemCode,
//     required this.sellerClusters,
//     required this.buyerClusters,
//     required this.lspStatus,
//     required this.invoiceNumber,
//     required this.invoiceCopy,
//     required this.crnCopy,
//     required this.crnAmount,
//     required this.transporterType,
//     required this.pickupRequest,
//     required this.companyCode,
//     required this.status1,
//     required this.lrNumber,
//     required this.lrDate,
//     required this.manifestDate,
//     required this.companyName,
//     required this.manifestRemarks,
//     required this.rEminder,
//     required this.reminderstatus,
//     required this.buyerlocationid,
//     required this.orderno,
//     required this.bigid,
//     required this.partnumber,
//     required this.partdesc,
//     required this.price,
//     required this.mrp,
//     required this.partvalue,
//     required this.buyerDealerId,
//     required this.buyerdealer,
//     required this.buyerlocation,
//     required this.qty,
//     required this.discount,
//     required this.sellerstockqty,
//     required this.lateststock,
//     required this.sellerFreeStock,
//     required this.stockdate,
//     required this.requestdate,
//     required this.courierType,
//     required this.dispatchdate,
//     required this.remarks,
//     required this.requestacceptremarks,
//     required this.dispatchqty,
//     required this.dispatchOrderNo,
//     required this.orderType,
//     required this.deliverDate,
//     required this.deliverStatus,
//     required this.status2,
//     required this.receiveremarks,
//     required this.partimagebuyer,
//     required this.orderfor,
//     required this.furtherdetailsremarks,
//     required this.responseconfirmremarks,
//     required this.ponumber,
//     required this.escalationstage,
//     required this.poqty,
//     required this.dispatchRejectionBtnShow,
//     required this.deliverStatus1,
//     required this.eta,
//     required this.dealerVerified,
//     required this.scsVerified,
//     required this.sWeFastTrackUrl,
//     required this.bWeFastTrackUrl,
//     required this.brand,
//     required this.allowCreditNote,
//     required this.stockCat,
//     required this.stockCatType,
//     required this.bufferAction,
//     required this.packingSlip,
//   });
//
// }
//
// enum AllowCreditNote {
//   M,
//   N
// }
//
// enum Brand {
//   MAHINDRA
// }
//
// enum Buyerdealer {
//   MAHINDRA_TEST
// }
//
// enum Buyerlocation {
//   TEST_1
// }
//
// enum CourierType {
//   SPARE_CARE_APPOINTED
// }
//
// enum Verified {
//   NO
// }
//
// enum DeliverStatus {
//   NOT_DELIVERED
// }
//
// enum OemCode {
//   TEST001
// }
//
// enum OrderType {
//   NEW
// }
//
// enum Orderfor {
//   STOCK,
//   VEHICLE
// }
//
// enum StatusEnum {
//   SUCCESS
// }
//
// enum Status {
//   RESPONSECONFIRM
// }
//
// enum Stockdate {
//   THE_18_FEB_2025
// }
//
// enum TransporterType {
//   SCOPE
// }
