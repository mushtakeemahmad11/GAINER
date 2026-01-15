import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../main.dart';
import '../../apis_functionality/api_service.dart';
import '../../controllers/buyer_controller/order_placed_controller.dart';
import '../../controllers/buyer_controller/part_receipt_controller.dart';
import '../../controllers/buyer_controller/po_updation_controller.dart';
import '../../controllers/check_internet/no_internet_screen.dart';
import '../../controllers/help_controller.dart';
import '../../controllers/home_screen_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../controllers/seller_controller/dispatch_details_controller.dart';
import '../../controllers/seller_controller/manifestation_controller.dart';
import '../../controllers/seller_controller/order_received_controller.dart';
import '../../controllers/seller_controller/part_delivery_controller.dart';
import '../../model/stage_model.dart';
import '../../shared_preferences/shared_preferences_set_data.dart';
import '../../widget/circular_progress_indicator.dart';
import '../../widget/error_msg.dart';
import '../../widget/reusable_icon_text.dart';
import '../check_internet/check_internet_connectivity.dart';
import '../colors.dart';
import '../home_buyers_stage/order_placed_screen.dart';
import '../home_buyers_stage/part_receipt/part_receipt_screen.dart';
import '../home_buyers_stage/po_updation/po_updation_screen.dart';
import '../home_sellers_stage/dispatch_details_screen.dart';
import '../home_sellers_stage/manifestation/manifestation_screen.dart';
import '../home_sellers_stage/order_received/order_received_screen.dart';
import '../home_sellers_stage/part_delivery_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationController locationController = Get.put(LocationController());
  final OrderPlacedController _orderPlacedController =
      Get.put(OrderPlacedController());
  final OrderReceivedController _orderReceivedController =
      Get.put(OrderReceivedController());
  final PoUpdationController _poUpdationController =
      Get.put(PoUpdationController());
  final ManifestationController _manifestationController =
      Get.put(ManifestationController());
  final PartReceiptController _partReceiptController =
      Get.put(PartReceiptController());
  final DispatchDetailsController _dispatchDetailsController =
      Get.put(DispatchDetailsController());
  final PartDeliveryController _partDeliveryController =
      Get.put(PartDeliveryController());
  final HelpController _helpController =
      Get.put(HelpController()); // for get Help Issue
  final NotificationController _notificationController =
      Get.put(NotificationController());

  // // late Map<String, dynamic> stockDetails;
  // List<StageData> users = [];
  // Map<String, StageData> usersMap = {};
  String? locationId;

  @override
  void initState() {
    super.initState();
    getBuyer();
  }

  String? selectedValue1;
  String? selectedValue2;

  Future<void> getBuyer() async {
    // final token = await GetServerKey().getServerKey(); //comment
    String? selectedLocation = locationController.selectedLocation.value;
    selectedLocation ??=
        locationController.locationIdMap.keys.elementAt(0).toString();
    locationId = locationController.locationIdMap[selectedLocation].toString();

    if (locationId != null) {
      setStringData('selectedLocationID', locationId!);
      setStringData('selectedLocationName', selectedLocation);
      getBuyerDetails(locationId!);
      locationController.updateStockDetails(int.parse(locationId!));
    }

    // get help section issue option
    _helpController.fetchIssues();
    // int tCode = await getIntData("tCode");
    // String selectedLocationID = await getIntData("selectedLocationID");
    // _notificationController.fetchNotifications(selectedLocationID);
    // print("Notication Length: ${_notificationController.notifications.length}");
  }

  // Map<String, dynamic>? getStockDetails(
  //     List<Map<String, dynamic>> stockList, int selectedLocationID) {
  //   return stockList.firstWhere(
  //     (stock) => stock['LocationID'] == selectedLocationID,
  //     orElse: () => {},
  //   );
  // }

  // Future<void> fetchVersionFromFirestore() async {
  //   try {
  //     DocumentSnapshot doc = await FirebaseFirestore.instance
  //         .collection('update')
  //         .doc('QjH2VV7Q5oX6uyMg8MOJ')
  //         .get();
  //     if (doc.exists) {
  //       int version = doc['version'];
  //       // check version if match then go forward otherwise show update
  //       if (version == 3) {
  //         // Get.off(() => DMMainScreen());
  //       } else {
  //         Get.dialog(
  //           barrierDismissible: false,
  //           AlertDialog(
  //             title: const Text('Update Available'),
  //             content: const Text(
  //                 'A newer version of the app is available. Please update to continue.'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () async {
  //                   downloadApk('1QKgVWI_XNhMJnOX3wqIVSg6tEJ2CItDh');
  //                 },
  //                 child: const Text('Update Now'),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     } else {
  //       // print('Document does not exist');
  //     }
  //   } catch (e) {
  //     // print('Error fetching version: $e');
  //   }
  // }

  // void downloadApk(String fileId) async {
  //   final url = 'https://drive.google.com/uc?export=download&id=$fileId';
  //   final uri = Uri.parse(url);
  //
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     // print("❌ Could not launch $url");
  //     Get.snackbar('Error', 'Could not launch update link.');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // var stockVal = locationController.stockDetails['StockVal'];
    // // var liStkShow = getFormattedStockValue(stockVal);
    // locationController.listedStockShow.value = getFormattedStockValue(stockVal);
    // print("listedStockVaLUE: ${locationController.listedStockShow.value}");

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .02),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () {
                      return (locationController.errorMsg.value != null)
                          ? Center(
                              child: CustomErrorMsg(
                                  text:
                                      locationController.errorMsg.value ?? ''))
                          : SizedBox.shrink();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0), // Horizontal margin
                    child: Material(
                      // Ensures the dropdown renders properly
                      color: Colors.transparent,
                      child: Obx(
                        () => DropdownButtonFormField<String>(
                          initialValue: locationController
                                  .selectedLocation.value!.isNotEmpty
                              ? locationController.selectedLocation.value
                              : null,
                          iconEnabledColor: Colors.white,
                          dropdownColor: AppColor.primary,
                          isExpanded:
                              true, // Ensures full width & dropdown below
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColor.primary,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                // borderSide: const BorderSide(
                                //     color: Colors.white, width: 2),
                                borderSide: BorderSide.none),
                          ),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          items: locationController.locationIdMap.entries
                              .map((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(
                                entry.key,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null &&
                                locationController.selectedLocation.value !=
                                    value) {
                              locationController.selectedLocation.value =
                                  value; // Update the title
                              String locationId = locationController
                                  .locationIdMap[value]
                                  .toString();
                              setStringData('selectedLocationID', locationId);
                              setStringData('selectedLocationName', value);
                              getBuyerDetails(locationId);
                              locationController
                                  .updateStockDetails(int.parse(locationId));
                            }
                          },
                          hint: const Text(
                            'Select Location',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: AppColor.primary,
                    // margin: EdgeInsets.symmetric(horizontal: mq.width*.02,vertical: mq.height*.02),
                    child: Column(
                      children: [
                        // Obx(
                        //   () => ExpansionTile(
                        //     key: UniqueKey(),
                        //     iconColor: AppColor.white,
                        //     collapsedIconColor: AppColor.white,
                        //     textColor: AppColor.white,
                        //     collapsedTextColor: AppColor.white,
                        //     title: locationController.locationIdMap.isNotEmpty
                        //         ? Text(
                        //             locationController.selectedLocation.value ??
                        //                 '',
                        //             style: const TextStyle(
                        //                 fontWeight: FontWeight.bold),
                        //           )
                        //         : const Center(
                        //             child: CircularProgressIndicator(
                        //             color: Colors.white,
                        //           )),
                        //     backgroundColor: AppColor.primary,
                        //     collapsedBackgroundColor: AppColor.primary,
                        //     collapsedShape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //     children: [
                        //       const Divider(),
                        //       locationController.locationIdMap.isNotEmpty
                        //           ? ListView.builder(
                        //               physics:
                        //                   const NeverScrollableScrollPhysics(),
                        //               shrinkWrap:
                        //                   true, // Constrains the ListView to only take the necessary space
                        //               itemCount: locationController
                        //                   .locationIdMap.length,
                        //               itemBuilder: (context, index) {
                        //                 return _buildTileOption(
                        //                     locationController
                        //                         .locationIdMap.keys
                        //                         .elementAt(index));
                        //               },
                        //             )
                        //           : const SizedBox.shrink(),
                        //     ],
                        //   ),
                        // ),
                        // const Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: mq.width * .02,
                              vertical: mq.height * .02),
                          child: Row(
                            children: [
                              SizedBox(
                                width: mq.width * .42,
                                child: Obx(() => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _cardStock(
                                            'Listed Stock',
                                            locationController
                                                .listedStockShow.value),
                                        SizedBox(
                                          height: mq.height * .01,
                                        ),
                                        _cardStock(
                                            'Last Stock Update',
                                            locationController.stockDetails[
                                                    'StockDate'] ??
                                                'N/A'),
                                      ],
                                    )),
                              ),
                              SizedBox(
                                width: mq.width * .01,
                              ),
                              Obx(() => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _cardBalance(
                                          'Fund Avl for Order',
                                          locationController.users.isNotEmpty
                                              ? locationController
                                                  .users[0].walletBalance
                                              : 0.00),
                                      SizedBox(height: mq.height * .01),
                                      _cardBalance(
                                          'Fund Balance',
                                          locationController.users.isNotEmpty
                                              ? locationController
                                                  .users[0].fundBalance
                                              : 0.00),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: mq.height * .02,
                  ),
                  Obx(() => Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: mq.width * .02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Buyer's Stage Section
                            const Text(
                              "Buyer's Stage",
                              style: TextStyle(fontSize: 20),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            buildStageRow([
                              buildIconWithLabel(
                                Icons.shopping_cart,
                                () async => await _orderPlaced(),
                                'Order Placed',
                                locationController
                                        .usersMap['OrderPlaced']?.partsCount ??
                                    0,
                                locationController
                                        .usersMap['OrderPlaced']?.val ??
                                    0.0,
                                // url: Constants.orderPlaced,

                                // locationController.users.isNotEmpty ? locationController.users[0].partsCount : 0,
                                // locationController.users.isNotEmpty ? locationController.users[0].val : 0.00,
                                // 0, 00.0
                              ),
                              buildIconWithLabel(
                                Icons.security_update_good,
                                () async => await _poUpdation(),
                                'PO Updation',
                                locationController
                                        .usersMap['PoUpdation']?.partsCount ??
                                    0,
                                locationController
                                        .usersMap['PoUpdation']?.val ??
                                    0.0,
                                // locationController.users.isNotEmpty ? locationController.users[1].partsCount : 0,
                                // locationController.users.isNotEmpty ? locationController.users[1].val : 0.00,
                                // 1, 0.02
                              ),
                              buildIconWithLabel(
                                Icons.receipt,
                                () async => await _partReceipt(),
                                // () {
                                //   Get.to(() => const PartReceiptScreen());
                                // },
                                'Part Receipt',
                                locationController
                                        .usersMap['PartsReceipt']?.partsCount ??
                                    0,
                                locationController
                                        .usersMap['PartsReceipt']?.val ??
                                    0.0,
                                // locationController.users.isNotEmpty ? locationController.users[2].partsCount : 0,
                                // locationController.users.isNotEmpty ? locationController.users[2].val : 0.00,
                                // 2, 0.04
                              ),
                            ]),
                            SizedBox(height: mq.height * .02),

                            // Seller's Stage Section
                            const Text(
                              "Seller's Stage",
                              style: TextStyle(fontSize: 20),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            buildStageRow([
                              buildIconWithLabel(
                                Icons.call_received,
                                () async => await _orderReceived(),
                                'Order Received',
                                locationController
                                        .usersMap['OrderDue']?.partsCount ??
                                    0,
                                locationController.usersMap['OrderDue']?.val ??
                                    0.0,
                                // locationController.users.isNotEmpty ? locationController.users[3].partsCount : 0,
                                // locationController.users.isNotEmpty ? locationController.users[3].val : 0.00,
                                // 0, 0.00
                              ),
                              buildIconWithLabel(
                                Icons.receipt_long,
                                () async => await _manifestation(),
                                'Manifestation',
                                locationController.usersMap['Manifestation']
                                        ?.partsCount ??
                                    0,
                                locationController
                                        .usersMap['Manifestation']?.val ??
                                    0.0,
                                // locationController.users.isNotEmpty ? locationController.users[4].partsCount : 0,
                                // locationController.users.isNotEmpty ? locationController.users[4].val : 0.00,
                                // 0, 0.00
                              ),
                              buildIconWithLabel(
                                Icons.summarize,
                                // () {
                                //   Get.to(() => const DispatchDetailsScreen());
                                // },
                                () => _dispatchDetails(),
                                'Dispatch Details',
                                locationController.usersMap['DispatchDetail']
                                        ?.partsCount ??
                                    0,
                                locationController
                                        .usersMap['DispatchDetail']?.val ??
                                    0.0,
                                // locationController.users.isNotEmpty ? locationController.users[6].partsCount : 0,
                                // locationController.users.isNotEmpty ? locationController.users[6].val : 0.00,
                                // 0, 0.00
                              ),
                            ]),
                            SizedBox(
                              height: mq.height * .02,
                            ),
                            buildStageRow([
                              buildIconWithLabel(
                                Icons.local_shipping,
                                // () {
                                //   Get.to(() => const PartDeliveryScreen());
                                // },
                                () => _partDelivery(),
                                'Part Delivery',
                                locationController.usersMap['PartsDelivery']
                                        ?.partsCount ??
                                    0,
                                locationController
                                        .usersMap['PartsDelivery']?.val ??
                                    0.0,
                              ),
                            ]),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          Obx(() => locationController.isLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  //card widget for listed Stock and balance
  Widget _cardBalance(String text, double val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: mq.width * .4,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Text(
          val.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  // Helper method to build the information row for listed stock and last update
  Widget _cardStock(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: mq.width * .4,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text('  $label',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        Text('  ${value.toString()}',
            style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  // Widget _buildTileOption(String text) {
  //   return InkWell(
  //     onTap: () {
  //       locationController.selectedLocation.value = text; // Update the title
  //       String locationId = locationController.locationIdMap[text].toString();
  //
  //       setStringData('selectedLocationID', locationId);
  //       setStringData('selectedLocationName', text);
  //       //
  //       // final selectedStock =
  //       //     locationController.getStockDetails(int.parse(locationId));
  //       // if (selectedStock != null) {
  //       //   setStringData("dealerID", selectedStock['DealerID'].toString());
  //       //   setStringData("brandID", selectedStock['BrandID'].toString());
  //       // }
  //       getBuyerDetails(locationId);
  //       locationController.updateStockDetails(int.parse(locationId));
  //       setState(() {});
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.all(14.0),
  //       child: Row(
  //         children: [
  //           Text(
  //             text,
  //             style: const TextStyle(color: Colors.white),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> getBuyerDetails(String id) async {
    // fetchVersionFromFirestore(); //check for update
    // for notification fetch
    await _notificationController.fetchNotifications(id);
    // print(
    //     "location: $id, Notification Length: ${_notificationController.notifications.length}");

    locationController.errorMsg.value = null;
    locationController.isLoading.value = true;
    final response = await ApiService().getBuyerValues(id);
    locationController.isLoading.value = false;

    if (response['success']) {
      var data = jsonDecode(response['data'].toString());
      locationController.users.clear();
      for (Map<String, dynamic> index in data) {
        locationController.users.add(StageData.fromJson(index));
      }
      locationController.usersMap.assignAll({
        for (var user in locationController.users) user.stage: user,
      });
      // locationController.usersMap = {for (var user in locationController.users) user.stage: user};

      var stockVal = locationController.stockDetails['StockVal'];
      locationController.listedStockShow.value =
          getFormattedStockValue(stockVal);

      // setState(() {});
    } else {}
  }

// Order Placed
  _orderPlaced() async {
    String locationId = locationController
        .locationIdMap[locationController.selectedLocation.value]
        .toString();

    bool isConnected = await checkInternet();
    if (isConnected) {
      locationController.isLoading.value = true;
      await _orderPlacedController.orderPlacedAsBuyer(
          locationId, 'REQUESTSENT');
      locationController.isLoading.value = false;

      // Navigate and wait for result
      await Get.to(() => const OrderPlacedScreen())?.then((val) => getBuyer());
    } else {
      internetNotAvl();
      // Get.to(()=>NoInternetScreen());
    }
  }

  //part Receipt
  _partReceipt() async {
    String locationId = locationController
        .locationIdMap[locationController.selectedLocation.value]
        .toString();

    bool isConnected = await checkInternet();
    if (isConnected) {
      locationController.isLoading.value = true;
      await _partReceiptController.partReceiptAsBuyer(locationId, 'DISPATCHED');
      locationController.isLoading.value = false;

      // Navigate and wait for result
      await Get.to(() => const PartReceiptScreen())?.then((val) => getBuyer());
    } else {
      internetNotAvl();
      // Get.to(()=>NoInternetScreen());
    }
  }

  // PO Updation as Buyer stage
  _poUpdation() async {
    String locationId = locationController
        .locationIdMap[locationController.selectedLocation.value]
        .toString();

    bool isConnected = await checkInternet();
    if (isConnected) {
      locationController.isLoading.value = true;
      await _poUpdationController.poUpdationAsBuyer(
          locationId, 'REQUESTACCEPTED');
      locationController.isLoading.value = false;

      // Navigate to PoUpdationScreen and wait for result
      await Get.to(() => const PoUpdationScreen())?.then((val) => getBuyer());
    } else {
      internetNotAvl();
      // Get.to(()=>NoInternetScreen());
    }
  }

// Order Received
  _orderReceived() async {
    String locationId = locationController
        .locationIdMap[locationController.selectedLocation.value]
        .toString();

    bool isConnected = await checkInternet();
    if (isConnected) {
      locationController.isLoading.value = true;
      await _orderReceivedController.orderReceivedAsSeller(
          locationId, 'REQUESTSENT');
      locationController.isLoading.value = false;

      // Navigate and wait for result
      await Get.to(() => const OrderReceivedScreen())
          ?.then((val) => getBuyer());
    } else {
      internetNotAvl();
      // await Get.to(()=>NoInternetScreen());
    }
  }

  // Manifestation
  _manifestation() async {
    String locationId = locationController
        .locationIdMap[locationController.selectedLocation.value]
        .toString();

    bool isConnected = await checkInternet();
    if (isConnected) {
      locationController.isLoading.value = true;
      await _manifestationController.manifestationAsSeller(
          locationId, 'RESPONSECONFIRM');
      locationController.isLoading.value = false;

      // Navigate and wait for result
      await Get.to(() => const ManifestationScreen())
          ?.then((val) => getBuyer());
    } else {
      internetNotAvl();
      // await Get.to(()=>NoInternetScreen());
    }
  }

  // Dispatch Details
  void _dispatchDetails() async {
    String brandId = locationController.stockDetails['BrandID'].toString();
    String dealerId = locationController.stockDetails['DealerID'].toString();
    String sellerLocationId =
        locationController.stockDetails['LocationID'].toString();

    bool isConnected = await checkInternet();
    if (isConnected) {
      locationController.isLoading.value = true;
      await _dispatchDetailsController.dispatchDetailsAsSeller(
          brandId, dealerId, sellerLocationId);
      locationController.isLoading.value = false;

      // Navigate and wait for result
      await Get.to(() => const DispatchDetailsScreen())
          ?.then((val) => getBuyer());
    } else {
      internetNotAvl();
      // await Get.to(()=>NoInternetScreen());
    }
  }

  // Part Delivery
  void _partDelivery() async {
    String locationId = locationController
        .locationIdMap[locationController.selectedLocation.value]
        .toString();

    bool isConnected = await checkInternet();
    if (isConnected) {
      locationController.isLoading.value = true;
      await _partDeliveryController.partDeliveryAsSeller(
          locationId, 'DISPATCHED');
      locationController.isLoading.value = false;

      // Navigate and wait for result
      await Get.to(() => const PartDeliveryScreen())?.then((val) => getBuyer());
    } else {
      internetNotAvl();
      // await Get.to(()=>NoInternetScreen());
    }
  }

  //convert number to Indian system format
  String formatIndianNumber(int number) {
    final NumberFormat indianFormat = NumberFormat.decimalPattern('en_IN');
    return indianFormat.format(number);
  }

  dynamic getFormattedStockValue(dynamic stockVal) {
    if (stockVal is double) {
      int intValue = stockVal.toInt(); // Convert double to int
      return formatIndianNumber(intValue);
    } else if (stockVal is int) {
      return formatIndianNumber(stockVal);
    } else {
      return stockVal; // Return non-numeric values as they are
    }
  }
}
