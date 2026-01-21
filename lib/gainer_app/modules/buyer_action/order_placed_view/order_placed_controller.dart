import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../../../gainer/apis_functionality/api_service.dart';
import 'models/grouped_part_model.dart';
import 'models/grouped_seller_model.dart';
import 'order_placed_model.dart';

/// 🔹 GROUP TYPE (WRITE HERE)
enum GroupType {
  partNumber,
  sellerLocation,
}

class OrderPlacedController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // checkLogin();
    orderPlacedAsBuyer();
  }

  /// Original API data
  final RxList<OrderPlacedModel> originalList = <OrderPlacedModel>[].obs;

  /// Grouped data for UI
  final RxMap<String, List<OrderPlacedModel>> groupedData =
      <String, List<OrderPlacedModel>>{}.obs;

  /// Current grouping
  final Rx<GroupType> currentGroupType = GroupType.partNumber.obs;

  /// API RESPONSE HANDLING
  void setOrdersFromApi(String responseData) {
    List<dynamic> jsonList = jsonDecode(responseData);

    originalList.value =
        jsonList.map((e) => OrderPlacedModel.fromJson(e)).toList();

    groupOrders(currentGroupType.value);
  }

  /// 🔹 GROUPING LOGIC
  void groupOrders(GroupType type) {
    final Map<String, List<OrderPlacedModel>> tempMap = {};

    for (var order in originalList) {
      late String key;

      switch (type) {
        case GroupType.partNumber:
          key = order.partNumber ?? 'Unknown Part';
          break;

        case GroupType.sellerLocation:
          key = order.sellerLocation ?? 'Unknown Location';
          break;
      }

      tempMap.putIfAbsent(key, () => []);
      tempMap[key]!.add(order);
    }

    groupedData.value = tempMap;
  }

  /// 🔹 BUTTON CLICK HANDLER
  void toggleGrouping() {
    currentGroupType.value = currentGroupType.value == GroupType.partNumber
        ? GroupType.sellerLocation
        : GroupType.partNumber;

    groupOrders(currentGroupType.value);
  }

  List<GroupedPartModel> groupByPart(
      List<OrderPlacedModel> list) {
    final Map<String, List<OrderPlacedModel>> map = {};

    for (var item in list) {
      map.putIfAbsent(item.partNumber!, () => []);
      map[item.partNumber!]!.add(item);
    }

    return map.entries.map((e) {
      final items = e.value;
      final totalQty =
      items.fold<int>(0, (sum, i) => sum + (i.qty ?? 0));

      return GroupedPartModel(
        partNumber: e.key,
        partDesc: items.first.partDesc ?? '',
        totalQty: totalQty,
        items: items,
      );
    }).toList();
  }

  List<GroupedSellerModel> groupBySeller(
      List<OrderPlacedModel> list) {
    final Map<String, List<OrderPlacedModel>> map = {};

    for (var item in list) {
      final key = '${item.dealerName}_${item.sellerLocation}';
      map.putIfAbsent(key, () => []);
      map[key]!.add(item);
    }

    return map.entries.map((e) {
      final items = e.value;
      final totalQty =
      items.fold<int>(0, (sum, i) => sum + (i.qty ?? 0));

      return GroupedSellerModel(
        sellerName: items.first.dealerName ?? '',
        location: items.first.sellerLocation ?? '',
        totalQty: totalQty,
        items: items,
      );
    }).toList();
  }



  RxBool isLoading = false.obs;

  //for store error msg which comes when api hit
  RxnString errorMsg = RxnString(null);

  // for store response meg which comes after tap delete icon
  RxnString odrDltResMsg = RxnString(null);
  RxnString odrDltErrorMsg = RxnString(null);

  // The list of seller data
  var orderPlacedList = <OrderPlacedModel>[].obs;

  // API Call to fetch Order placed
  Future<void> orderPlacedAsBuyer() async {
    final locationId = await AuthService.getLocationId();
    errorMsg.value = null;
    isLoading.value = true;
    final response =
        await ApiService().getBuyerStages(locationId, 'REQUESTSENT');
    isLoading.value = false;

    if (response['success']) {
      final data = response['data'];
      setOrdersFromApi(data);

      // List<dynamic> jsonList = jsonDecode(response['data']);
      //
      // // use of model data
      // orderPlacedList.value =
      //     jsonList.map((json) => OrderPlacedModel.fromJson(json)).toList();
    } else {
      errorMsg.value = response['message'];
      orderPlacedList.clear();
    }
  }

  //Api for order place delete
  Future<void> orderPlacedDeleteAsBuyer(String bigID) async {
    isLoading.value = true;
    final response = await ApiService().orderPlacedDelete(bigID);
    isLoading.value = false;

    if (response['success']) {
      odrDltResMsg.value = response['data'];
    } else {
      odrDltErrorMsg.value = response['message'];
    }
  }

  final orders = <OrderModel>[
    OrderModel(
      seller: 'Honda Service',
      location: 'Delhi',
      orderDate: 'Nov 17 2025',
      orderedQty: 15,
      mrp: 1000,
      discount: 30,
      pricePerQty: 700, // 1000 - 30%
      remark:
          'Send clear part image Send clear part image Send clear part image Send clear part image',
    ),
    OrderModel(
      seller: 'Hero MotoCorp',
      location: 'Gurgaon',
      orderDate: 'Nov 18 2025',
      orderedQty: 8,
      mrp: 800,
      discount: 15,
      pricePerQty: 680, // 800 - 15%
      remark: 'Urgent delivery required',
    ),
    OrderModel(
      seller: 'Bajaj Auto',
      location: 'Noida',
      orderDate: 'Nov 16 2025',
      orderedQty: 12,
      mrp: 600,
      discount: 25,
      pricePerQty: 450, // 600 - 25%
      remark: 'Confirm part compatibility',
    ),
    OrderModel(
      seller: 'TVS Motors',
      location: 'Faridabad',
      orderDate: 'Nov 19 2025',
      orderedQty: 6,
      mrp: 1200,
      discount: 30,
      pricePerQty: 840, // 1200 - 30%
      remark: 'Send invoice with parcel',
    ),
    OrderModel(
      seller: 'Royal Enfield',
      location: 'Jaipur',
      orderDate: 'Nov 15 2025',
      orderedQty: 4,
      mrp: 1500,
      discount: 25,
      pricePerQty: 1125, // 1500 - 25%
      remark: 'Premium quality only',
    ),
    OrderModel(
      seller: 'Suzuki Motors',
      location: 'Chandigarh',
      orderDate: 'Nov 14 2025',
      orderedQty: 5,
      mrp: 1200,
      pricePerQty: 960, // MRP 1200 - 20%
      discount: 20,
      remark: 'Call before dispatch',
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
  final int mrp;
  final int pricePerQty;
  final int discount;
  final String remark;

  OrderModel({
    required this.seller,
    required this.location,
    required this.orderDate,
    required this.orderedQty,
    required this.mrp,
    required this.pricePerQty,
    required this.discount,
    required this.remark,
  });
}
