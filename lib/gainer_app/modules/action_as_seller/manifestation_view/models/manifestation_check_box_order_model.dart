class CheckBoxOrderModel {
  final String orderId; // UNIQUE (poNumber or backend ID)
  final String oemCode;
  final String poNumber;
  final int poQty;

  bool isSelected;

  CheckBoxOrderModel({
    required this.orderId,
    required this.oemCode,
    required this.poNumber,
    required this.poQty,
    this.isSelected = false,
  });
}
