import 'package:get/get.dart';

class OrderPlacedController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    checkLogin();
  }

  Future<void> checkLogin() async {
    print("You are in order Placed");
  }

  final orders = <OrderModel>[
    OrderModel(
      seller: 'Honda Service',
      location: 'Gurgaon',
      orderDate: 'Nov 17 2025',
      orderedQty: 5,
      pricePerQty: 591,
      discount: 30,
      remark: 'send clear part image',
    ),
    OrderModel(
      seller: 'Honda Service',
      location: 'Gurgaon',
      orderDate: 'Nov 17 2025',
      orderedQty: 5,
      pricePerQty: 591,
      discount: 30,
      remark: 'send clear part image',
    ),
  ].obs;

  void removeOrder(int index) {
    // orders.removeAt(index);
  }
}

class OrderModel {
  final String seller;
  final String location;
  final String orderDate;
  final int orderedQty;
  final int pricePerQty;
  final int discount;
  final String remark;

  OrderModel({
    required this.seller,
    required this.location,
    required this.orderDate,
    required this.orderedQty,
    required this.pricePerQty,
    required this.discount,
    required this.remark,
  });
}
