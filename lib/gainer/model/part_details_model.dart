class PartDetails {
  int? brandid;
  String? partnumber;
  String? partnumber1;
  String? partdesc;
  String? oldCategory;
  double? landedcost;
  double? mrp;
  DateTime? dateadded;
  DateTime? lastupdated;
  String? subpartnumber;
  String? subpartnumber1;
  String? moq;
  String? partIntelligence;
  String? seasonal;
  String? pms;
  String? model;
  String? campaign;
  String? kitid;
  String? runningBodyPart;
  int? qtyPerVehicle;
  String? orderPartNumber;
  String? addedBy;
  String? updatedBy;
  String? hsnCode;
  double? gstPer;
  String? subCategory1;
  String? subCategory2;
  String? subCategory3;
  int? maxPartNatureID;
  int? maxModelAgedID;
  int? maxWarrantyTypeID;
  int? maxSeasonalID;
  int? maxLocPerID;
  int? partID;
  String? orderPartNo;
  String? partNo;
  int? partTypeID;
  double? retailPrice;
  int? hsnID;
  int? catID;
  bool? partStatus;
  String? category;

  PartDetails({
    this.brandid,
    this.partnumber,
    this.partnumber1,
    this.partdesc,
    this.oldCategory,
    this.landedcost,
    this.mrp,
    this.dateadded,
    this.lastupdated,
    this.subpartnumber,
    this.subpartnumber1,
    this.moq,
    this.partIntelligence,
    this.seasonal,
    this.pms,
    this.model,
    this.campaign,
    this.kitid,
    this.runningBodyPart,
    this.qtyPerVehicle,
    this.orderPartNumber,
    this.addedBy,
    this.updatedBy,
    this.hsnCode,
    this.gstPer,
    this.subCategory1,
    this.subCategory2,
    this.subCategory3,
    this.maxPartNatureID,
    this.maxModelAgedID,
    this.maxWarrantyTypeID,
    this.maxSeasonalID,
    this.maxLocPerID,
    this.partID,
    this.orderPartNo,
    this.partNo,
    this.partTypeID,
    this.retailPrice,
    this.hsnID,
    this.catID,
    this.partStatus,
    this.category,
  });

  factory PartDetails.fromJson(Map<String, dynamic> json) {
    return PartDetails(
      brandid: json['brandid'],
      partnumber: json['partnumber'],
      partnumber1: json['partnumber1'],
      partdesc: json['partdesc'],
      oldCategory: json['OldCategory'],
      landedcost: (json['landedcost'] as num?)?.toDouble(),
      mrp: (json['MRP'] as num?)?.toDouble(),
      dateadded: json['Dateadded'] != null ? _parseDate(json['Dateadded']) : null,
      lastupdated: json['Lastupdated'] != null ? _parseDate(json['Lastupdated']) : null,
      subpartnumber: json['subpartnumber'],
      subpartnumber1: json['subpartnumber1'],
      moq: json['MOQ'],
      partIntelligence: json['PARTINTELLIGENCE'],
      seasonal: json['SEASONAL'],
      pms: json['PMS'],
      model: json['MODEL'],
      campaign: json['CAMPAIGN'],
      kitid: json['KITID'],
      runningBodyPart: json['RUNNINGBODYPART'],
      qtyPerVehicle: json['QTYPERVEHICLE'],
      orderPartNumber: json['OrderPartNumber'],
      addedBy: json['AddedBy'],
      updatedBy: json['UpdatedBy'],
      hsnCode: json['HSNCode'],
      gstPer: (json['GSTPer'] as num?)?.toDouble(),
      subCategory1: json['SubCategory1'],
      subCategory2: json['SubCategory2'],
      subCategory3: json['SubCategory3'],
      maxPartNatureID: json['Max_PartNatureID'],
      maxModelAgedID: json['Max_ModelAgedID'],
      maxWarrantyTypeID: json['Max_WarrantyTypeID'],
      maxSeasonalID: json['Max_SeasonalID'],
      maxLocPerID: json['Max_LocPerID'],
      partID: json['PartID'],
      orderPartNo: json['OrderPartNo'],
      partNo: json['PartNo'],
      partTypeID: json['PartTypeID'],
      retailPrice: (json['RetailPrice'] as num?)?.toDouble(),
      hsnID: json['HSNID'],
      catID: json['CatID'],
      partStatus: json['PartStatus'],
      category: json['Category'],
    );
  }

  static DateTime _parseDate(String dateStr) {
    final timestamp = int.parse(RegExp(r"\d+").firstMatch(dateStr)!.group(0)!);
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  Map<String, dynamic> toJson() {
    return {
      'brandid': brandid,
      'partnumber': partnumber,
      'partnumber1': partnumber1,
      'partdesc': partdesc,
      'OldCategory': oldCategory,
      'landedcost': landedcost,
      'MRP': mrp,
      'Dateadded': dateadded?.toIso8601String(),
      'Lastupdated': lastupdated?.toIso8601String(),
      'subpartnumber': subpartnumber,
      'subpartnumber1': subpartnumber1,
      'MOQ': moq,
      'PARTINTELLIGENCE': partIntelligence,
      'SEASONAL': seasonal,
      'PMS': pms,
      'MODEL': model,
      'CAMPAIGN': campaign,
      'KITID': kitid,
      'RUNNINGBODYPART': runningBodyPart,
      'QTYPERVEHICLE': qtyPerVehicle,
      'OrderPartNumber': orderPartNumber,
      'AddedBy': addedBy,
      'UpdatedBy': updatedBy,
      'HSNCode': hsnCode,
      'GSTPer': gstPer,
      'SubCategory1': subCategory1,
      'SubCategory2': subCategory2,
      'SubCategory3': subCategory3,
      'Max_PartNatureID': maxPartNatureID,
      'Max_ModelAgedID': maxModelAgedID,
      'Max_WarrantyTypeID': maxWarrantyTypeID,
      'Max_SeasonalID': maxSeasonalID,
      'Max_LocPerID': maxLocPerID,
      'PartID': partID,
      'OrderPartNo': orderPartNo,
      'PartNo': partNo,
      'PartTypeID': partTypeID,
      'RetailPrice': retailPrice,
      'HSNID': hsnID,
      'CatID': catID,
      'PartStatus': partStatus,
      'Category': category,
    };
  }
}
