///for old API https://scope.sparecare.in/AppServices.asmx/CalculateFreightCost
class CalculateFreightCostModel {
  final int? companyCode;
  final String? companyName;
  final double? ratePerKg;
  final double? volumetricWt;
  final double? weight;
  final double? calCost;
  final double? fuelSurcharge;
  final double? costDueToFuelSurcharge;
  final double? insuranceCharge;
  final double? costDueToInsuranceCharge;
  final double? additionalCharge;
  final double? costDueToAdditionalCharge;
  final double? odaChargePickup;
  final double? odaChargeDelivery;
  final double? handlingCharges;
  final double? minFreightCost;
  final double? totalCost;
  final double? estCost;
  final int? tat;
  final String? buyerZone;
  final String? sellerZone;
  final double? fov;
  final double? toPay;
  final double? docketFee;
  final double? ecc;
  final String? eccType;
  final double? minChargeableWeight;
  final String? tokenNo;
  final String? sellerPincode;
  final String? buyerPincode;
  final int? defaultCompany;

  CalculateFreightCostModel({
    this.companyCode,
    this.companyName,
    this.ratePerKg,
    this.volumetricWt,
    this.weight,
    this.calCost,
    this.fuelSurcharge,
    this.costDueToFuelSurcharge,
    this.insuranceCharge,
    this.costDueToInsuranceCharge,
    this.additionalCharge,
    this.costDueToAdditionalCharge,
    this.odaChargePickup,
    this.odaChargeDelivery,
    this.handlingCharges,
    this.minFreightCost,
    this.totalCost,
    this.estCost,
    this.tat,
    this.buyerZone,
    this.sellerZone,
    this.fov,
    this.toPay,
    this.docketFee,
    this.ecc,
    this.eccType,
    this.minChargeableWeight,
    this.tokenNo,
    this.sellerPincode,
    this.buyerPincode,
    this.defaultCompany,
  });

  factory CalculateFreightCostModel.fromJson(Map<String, dynamic> json) {
    return CalculateFreightCostModel(
      companyCode: json['CompanyCode'],
      companyName: json['CompanyName'],
      ratePerKg: (json['RatePerKg'] ?? 0).toDouble(),
      volumetricWt: (json['VolumetricWt'] ?? 0).toDouble(),
      weight: (json['Weight'] ?? 0).toDouble(),
      calCost: (json['CalCost'] ?? 0).toDouble(),
      fuelSurcharge: (json['FuelSurcharge'] ?? 0).toDouble(),
      costDueToFuelSurcharge: (json['CostDueToFuelSurcharge'] ?? 0).toDouble(),
      insuranceCharge: (json['InsuranceCharge'] ?? 0).toDouble(),
      costDueToInsuranceCharge:
      (json['CostDueToInsuranceCharge'] ?? 0).toDouble(),
      additionalCharge: (json['AdditionalCharge'] ?? 0).toDouble(),
      costDueToAdditionalCharge:
      (json['CostDueToAdditionalCharge'] ?? 0).toDouble(),
      odaChargePickup: (json['ODAChargePickup'] ?? 0).toDouble(),
      odaChargeDelivery: (json['ODAChargeDelivery'] ?? 0).toDouble(),
      handlingCharges: (json['HandlingCharges'] ?? 0).toDouble(),
      minFreightCost: (json['MinFrieghtCost'] ?? 0).toDouble(),
      totalCost: (json['TotalCost'] ?? 0).toDouble(),
      estCost: (json['EstCost'] ?? 0).toDouble(),
      tat: json['TAT'],
      buyerZone: json['BuyerZone'],
      sellerZone: json['SellerZone'],
      fov: json['FOV'] != null ? (json['FOV'] ?? 0).toDouble() : null,
      toPay: json['ToPay'] != null ? (json['ToPay'] ?? 0).toDouble() : null,
      docketFee:
      json['DocketFee'] != null ? (json['DocketFee'] ?? 0).toDouble() : null,
      ecc: json['Ecc'] != null ? (json['Ecc'] ?? 0).toDouble() : null,
      eccType: json['EccType'],
      // minChargeableWeight: json['MinChargeableWeight'],
      minChargeableWeight: (json['MinChargeableWeight'] ?? 0).toDouble(),
      tokenNo: json['TokenNo'],
      sellerPincode: json['SellerPincode'],
      buyerPincode: json['BuyerPincode'],
      defaultCompany: json['DefaultCompany'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "CompanyCode": companyCode,
      "CompanyName": companyName,
      "RatePerKg": ratePerKg,
      "VolumetricWt": volumetricWt,
      "Weight": weight,
      "CalCost": calCost,
      "FuelSurcharge": fuelSurcharge,
      "CostDueToFuelSurcharge": costDueToFuelSurcharge,
      "InsuranceCharge": insuranceCharge,
      "CostDueToInsuranceCharge": costDueToInsuranceCharge,
      "AdditionalCharge": additionalCharge,
      "CostDueToAdditionalCharge": costDueToAdditionalCharge,
      "ODAChargePickup": odaChargePickup,
      "ODAChargeDelivery": odaChargeDelivery,
      "HandlingCharges": handlingCharges,
      "MinFrieghtCost": minFreightCost,
      "TotalCost": totalCost,
      "EstCost": estCost,
      "TAT": tat,
      "BuyerZone": buyerZone,
      "SellerZone": sellerZone,
      "FOV": fov,
      "ToPay": toPay,
      "DocketFee": docketFee,
      "Ecc": ecc,
      "EccType": eccType,
      "MinChargeableWeight": minChargeableWeight,
      "TokenNo": tokenNo,
      "SellerPincode": sellerPincode,
      "BuyerPincode": buyerPincode,
      "DefaultCompany": defaultCompany,
    };
  }
}


///for new API https://scope.sparecare.in/AppServices.asmx/CalculateFreightCost
// class CalculateFreightCostModel {
//   final int? companyCode;
//   final String? companyName;
//   final double? ratePerKg;
//   final double? volumetricWt;
//   final double? weight;
//   final double? calCost;
//   final double? fuelSurcharge;
//   final double? costDueToFuelSurcharge;
//   final double? insuranceCharge;
//   final double? costDueToInsuranceCharge;
//   final double? additionalCharge;
//   final double? costDueToAdditionalCharge;
//   final double? minFreightCost;
//   final double? totalCost;
//   final double? estCost;
//   final int? tat;
//   final String? buyerZone;
//   final String? sellerZone;
//   final dynamic fov;
//   final dynamic toPay;
//   final dynamic docketFee;
//   final dynamic ecc;
//   final dynamic eccType;
//   final double? minChargeableWeight;
//   final String? tokenNo;
//   final dynamic sellerPincode;
//   final dynamic buyerPincode;
//   final int? defaultCompany;
//   final String? paymentAmount;
//   final String? deliveryFeeAmount;
//   final String? intercityDeliveryFeeAmount;
//   final String? weightFeeAmount;
//   final String? insuranceAmount;
//   final String? insuranceFeeAmount;
//   final String? loadingFeeAmount;
//   final String? moneyTransferFeeAmount;
//   final String? suburbanDeliveryFeeAmount;
//   final String? overnightFeeAmount;
//   final String? discountAmount;
//   final String? backpaymentAmount;
//   final String? codFeeAmount;
//
//   CalculateFreightCostModel({
//     this.companyCode,
//     this.companyName,
//     this.ratePerKg,
//     this.volumetricWt,
//     this.weight,
//     this.calCost,
//     this.fuelSurcharge,
//     this.costDueToFuelSurcharge,
//     this.insuranceCharge,
//     this.costDueToInsuranceCharge,
//     this.additionalCharge,
//     this.costDueToAdditionalCharge,
//     this.minFreightCost,
//     this.totalCost,
//     this.estCost,
//     this.tat,
//     this.buyerZone,
//     this.sellerZone,
//     this.fov,
//     this.toPay,
//     this.docketFee,
//     this.ecc,
//     this.eccType,
//     this.minChargeableWeight,
//     this.tokenNo,
//     this.sellerPincode,
//     this.buyerPincode,
//     this.defaultCompany,
//     this.paymentAmount,
//     this.deliveryFeeAmount,
//     this.intercityDeliveryFeeAmount,
//     this.weightFeeAmount,
//     this.insuranceAmount,
//     this.insuranceFeeAmount,
//     this.loadingFeeAmount,
//     this.moneyTransferFeeAmount,
//     this.suburbanDeliveryFeeAmount,
//     this.overnightFeeAmount,
//     this.discountAmount,
//     this.backpaymentAmount,
//     this.codFeeAmount,
//   });
//
//   factory CalculateFreightCostModel.fromJson(Map<String, dynamic> json) {
//     return CalculateFreightCostModel(
//       companyCode: json['CompanyCode'],
//       companyName: json['CompanyName'],
//       ratePerKg: (json['RatePerKg'] ?? 0).toDouble(),
//       volumetricWt: (json['VolumetricWt'] ?? 0).toDouble(),
//       weight: (json['Weight'] ?? 0).toDouble(),
//       calCost: (json['CalCost'] ?? 0).toDouble(),
//       fuelSurcharge: (json['FuelSurcharge'] ?? 0).toDouble(),
//       costDueToFuelSurcharge: (json['CostDueToFuelSurcharge'] ?? 0).toDouble(),
//       insuranceCharge: (json['InsuranceCharge'] ?? 0).toDouble(),
//       costDueToInsuranceCharge: (json['CostDueToInsuranceCharge'] ?? 0).toDouble(),
//       additionalCharge: (json['AdditionalCharge'] ?? 0).toDouble(),
//       costDueToAdditionalCharge: (json['CostDueToAdditionalCharge'] ?? 0).toDouble(),
//       minFreightCost: (json['MinFrieghtCost'] ?? 0).toDouble(),
//       totalCost: (json['TotalCost'] ?? 0).toDouble(),
//       estCost: (json['EstCost'] ?? 0).toDouble(),
//       tat: json['TAT'],
//       buyerZone: json['BuyerZone'],
//       sellerZone: json['SellerZone'],
//       fov: json['FOV'],
//       toPay: json['ToPay'],
//       docketFee: json['DocketFee'],
//       ecc: json['Ecc'],
//       eccType: json['EccType'],
//       minChargeableWeight: (json['MinChargeableWeight'] ?? 0).toDouble(),
//       tokenNo: json['TokenNo'],
//       sellerPincode: json['SellerPincode'],
//       buyerPincode: json['BuyerPincode'],
//       defaultCompany: json['DefaultCompany'],
//       paymentAmount: json['payment_amount'],
//       deliveryFeeAmount: json['delivery_fee_amount'],
//       intercityDeliveryFeeAmount: json['intercity_delivery_fee_amount'],
//       weightFeeAmount: json['weight_fee_amount'],
//       insuranceAmount: json['insurance_amount'],
//       insuranceFeeAmount: json['insurance_fee_amount'],
//       loadingFeeAmount: json['loading_fee_amount'],
//       moneyTransferFeeAmount: json['money_transfer_fee_amount'],
//       suburbanDeliveryFeeAmount: json['suburban_delivery_fee_amount'],
//       overnightFeeAmount: json['overnight_fee_amount'],
//       discountAmount: json['discount_amount'],
//       backpaymentAmount: json['backpayment_amount'],
//       codFeeAmount: json['cod_fee_amount'],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "CompanyCode": companyCode,
//     "CompanyName": companyName,
//     "RatePerKg": ratePerKg,
//     "VolumetricWt": volumetricWt,
//     "Weight": weight,
//     "CalCost": calCost,
//     "FuelSurcharge": fuelSurcharge,
//     "CostDueToFuelSurcharge": costDueToFuelSurcharge,
//     "InsuranceCharge": insuranceCharge,
//     "CostDueToInsuranceCharge": costDueToInsuranceCharge,
//     "AdditionalCharge": additionalCharge,
//     "CostDueToAdditionalCharge": costDueToAdditionalCharge,
//     "MinFrieghtCost": minFreightCost,
//     "TotalCost": totalCost,
//     "EstCost": estCost,
//     "TAT": tat,
//     "BuyerZone": buyerZone,
//     "SellerZone": sellerZone,
//     "FOV": fov,
//     "ToPay": toPay,
//     "DocketFee": docketFee,
//     "Ecc": ecc,
//     "EccType": eccType,
//     "MinChargeableWeight": minChargeableWeight,
//     "TokenNo": tokenNo,
//     "SellerPincode": sellerPincode,
//     "BuyerPincode": buyerPincode,
//     "DefaultCompany": defaultCompany,
//     "payment_amount": paymentAmount,
//     "delivery_fee_amount": deliveryFeeAmount,
//     "intercity_delivery_fee_amount": intercityDeliveryFeeAmount,
//     "weight_fee_amount": weightFeeAmount,
//     "insurance_amount": insuranceAmount,
//     "insurance_fee_amount": insuranceFeeAmount,
//     "loading_fee_amount": loadingFeeAmount,
//     "money_transfer_fee_amount": moneyTransferFeeAmount,
//     "suburban_delivery_fee_amount": suburbanDeliveryFeeAmount,
//     "overnight_fee_amount": overnightFeeAmount,
//     "discount_amount": discountAmount,
//     "backpayment_amount": backpaymentAmount,
//     "cod_fee_amount": codFeeAmount,
//   };
// }
