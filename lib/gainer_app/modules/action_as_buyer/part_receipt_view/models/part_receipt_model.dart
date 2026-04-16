class PartReceiptModel {
  String status;
  String sellerResponseDate;
  String poConfirmationDate;
  String manifestationDate;
  dynamic receivingDate;
  String oemCode;
  String lspStatus;
  String invoiceNumber;
  String invoiceCopy;
  dynamic crnCopy;
  double crnAmount;
  String transporterType;
  String courierType;
  String pickupRequest;
  int companyCode;
  String lrNumber;
  String lrDate;
  String manifestDate;
  String companyName;
  String manifestRemarks;
  String ponumber;
  String buyerlatestdate;
  int sellerlocationid;
  double rEminder;
  bool reminderstatus;
  String orderno;
  int bigid;
  String status1;
  String partnumber;
  String partdesc;
  int price;
  double mrp;
  double partvalue;
  int sellerDealerId;
  String dealerName;
  String sellerlocation;
  int qty;
  double discount;
  int sellerstockqty;
  double sellerlateststock;
  double sellerFreeStock;
  String sellerstockdate;
  int buyerstockqty;
  double buyerlateststock;
  String requestdate;
  String dispatchdate;
  String remarks;
  String requestacceptremarks;
  String partimage;
  int dispatchqty;
  int poQty;
  dynamic docketno;
  String dispatchdate1;
  dynamic dispatchdetails;
  dynamic dispatchedpart;
  String orderfor;
  dynamic furtherdetailsremarks;
  String responseconfirmremarks;
  String orderstatus;
  String escalationstage;
  String dispatchOrderNo;
  String orderType;
  String deliverDate;
  String deliverStatus;
  int eta;
  String dealerVerified;
  String scsVerified;
  dynamic sWeFastTrackUrl;
  dynamic bWeFastTrackUrl;
  String stockCat;
  String bufferAction;
  dynamic packingSlip;

  PartReceiptModel({
    required this.status,
    required this.sellerResponseDate,
    required this.poConfirmationDate,
    required this.manifestationDate,
    required this.receivingDate,
    required this.oemCode,
    required this.lspStatus,
    required this.invoiceNumber,
    required this.invoiceCopy,
    required this.crnCopy,
    required this.crnAmount,
    required this.transporterType,
    required this.courierType,
    required this.pickupRequest,
    required this.companyCode,
    required this.lrNumber,
    required this.lrDate,
    required this.manifestDate,
    required this.companyName,
    required this.manifestRemarks,
    required this.ponumber,
    required this.buyerlatestdate,
    required this.sellerlocationid,
    required this.rEminder,
    required this.reminderstatus,
    required this.orderno,
    required this.bigid,
    required this.status1,
    required this.partnumber,
    required this.partdesc,
    required this.price,
    required this.mrp,
    required this.partvalue,
    required this.sellerDealerId,
    required this.dealerName,
    required this.sellerlocation,
    required this.qty,
    required this.discount,
    required this.sellerstockqty,
    required this.sellerlateststock,
    required this.sellerFreeStock,
    required this.sellerstockdate,
    required this.buyerstockqty,
    required this.buyerlateststock,
    required this.requestdate,
    required this.dispatchdate,
    required this.remarks,
    required this.requestacceptremarks,
    required this.partimage,
    required this.dispatchqty,
    required this.poQty,
    required this.docketno,
    required this.dispatchdate1,
    required this.dispatchdetails,
    required this.dispatchedpart,
    required this.orderfor,
    required this.furtherdetailsremarks,
    required this.responseconfirmremarks,
    required this.orderstatus,
    required this.escalationstage,
    required this.dispatchOrderNo,
    required this.orderType,
    required this.deliverDate,
    required this.deliverStatus,
    required this.eta,
    required this.dealerVerified,
    required this.scsVerified,
    required this.sWeFastTrackUrl,
    required this.bWeFastTrackUrl,
    required this.stockCat,
    required this.bufferAction,
    required this.packingSlip,
  });

  factory PartReceiptModel.fromJson(Map<String, dynamic> json) {
    return PartReceiptModel(
      status: json["Status"] ?? "",
      sellerResponseDate: json["SellerResponseDate"] ?? "",
      poConfirmationDate: json["POConfirmationDate"] ?? "",
      manifestationDate: json["ManifestationDate"] ?? "",
      receivingDate: json["ReceivingDate"],
      oemCode: json["OEMCode"] ?? "",
      lspStatus: json["LSPStatus"] ?? "",
      invoiceNumber: json["InvoiceNumber"] ?? "",
      invoiceCopy: json["InvoiceCopy"] ?? "",
      crnCopy: json["CrnCopy"],
      crnAmount: json["CrnAmount"] ?? 0,
      transporterType: json["TransporterType"] ?? "",
      courierType: json["CourierType"] ?? "",
      pickupRequest: json["PickupRequest"] ?? "",
      companyCode: json["CompanyCode"] ?? 0,
      lrNumber: json["LRNumber"] ?? "",
      lrDate: json["LRDate"] ?? "",
      manifestDate: json["ManifestDate"] ?? "",
      companyName: json["CompanyName"] ?? "",
      manifestRemarks: json["ManifestRemarks"] ?? "",
      ponumber: json["PONUMBER"] ?? "",
      buyerlatestdate: json["BUYERLATESTDATE"] ?? "",
      sellerlocationid: json["SELLERLOCATIONID"] ?? 0,
      rEminder: (json["rEMINDER"] ?? 0.0).toDouble(),
      reminderstatus: json["REMINDERSTATUS"] ?? false,
      orderno: json["ORDERNO"] ?? "",
      bigid: json["BIGID"] ?? 0,
      status1: json["STATUS1"] ?? "",
      partnumber: json["PARTNUMBER"] ?? "",
      partdesc: json["partdesc"] ?? "",
      price: json["Price"] ?? 0,
      mrp: json["MRP"] ?? 0,
      partvalue: (json["PARTVALUE"] ?? 0.0).toDouble(),
      sellerDealerId: json["SellerDealerID"] ?? 0,
      dealerName: json["DealerName"] ?? "",
      sellerlocation: json["SELLERLOCATION"] ?? "",
      qty: json["QTY"] ?? 0,
      discount: json["DISCOUNT"] ?? 0,
      sellerstockqty: json["SELLERSTOCKQTY"] ?? 0,
      sellerlateststock: json["SELLERLATESTSTOCK"] ?? 0,
      sellerFreeStock: json["SellerFreeStock"] ?? 0,
      sellerstockdate: json["SELLERSTOCKDATE"] ?? "",
      buyerstockqty: json["BUYERSTOCKQTY"] ?? 0,
      buyerlateststock: json["BUYERLATESTSTOCK"] ?? 0,
      requestdate: json["REQUESTDATE"] ?? "",
      dispatchdate: json["DISPATCHDATE"] ?? "",
      remarks: json["REMARKS"] ?? "",
      requestacceptremarks: json["REQUESTACCEPTREMARKS"] ?? "",
      partimage: json["PARTIMAGE"] ?? "",
      dispatchqty: json["DISPATCHQTY"] ?? 0,
      poQty: json["POQty"] ?? 0,
      docketno: json["DOCKETNO"],
      dispatchdate1: json["DISPATCHDATE1"] ?? "",
      dispatchdetails: json["DISPATCHDETAILS"],
      dispatchedpart: json["DISPATCHEDPART"],
      orderfor: json["ORDERFOR"] ?? "",
      furtherdetailsremarks: json["FURTHERDETAILSREMARKS"],
      responseconfirmremarks: json["RESPONSECONFIRMREMARKS"] ?? "",
      orderstatus: json["ORDERSTATUS"] ?? "",
      escalationstage: json["ESCALATIONSTAGE"] ?? "",
      dispatchOrderNo: json["DispatchOrderNo"] ?? "",
      orderType: json["OrderType"] ?? "",
      deliverDate: json["DeliverDate"]??"",
      deliverStatus: json["DeliverStatus"] ?? "",
      eta: json["ETA"] ?? 0,
      dealerVerified: json["DealerVerified"] ?? "",
      scsVerified: json["SCSVerified"] ?? "",
      sWeFastTrackUrl: json["sWeFastTrackUrl"],
      bWeFastTrackUrl: json["bWeFastTrackUrl"],
      stockCat: json["StockCat"] ?? "",
      bufferAction: json["BufferAction"] ?? "",
      packingSlip: json["PackingSlip"],
    );
  }

}