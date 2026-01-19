import 'package:flutter/material.dart';
// import 'package:gainer/apis_functionality/firebase_db_creation.dart';
// import 'package:gainer/apis_functionality/send_notification_service.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../controllers/buyer_controller/order_placed_controller.dart';
import '../../controllers/check_internet/no_internet_screen.dart';
import '../../model/buyer_model/order_placed_model.dart';
import '../../utility/controller_utils.dart';
import '../../widget/bottomsheet_for_picture.dart';
import '../../widget/circular_progress_indicator.dart';
import '../../widget/dialog.dart';
import '../../widget/reusable_circle_avatar.dart';
import '../../widget/reusable_widget.dart';
import '../check_internet/check_internet_connectivity.dart';
import '../colors.dart';
import '../constant_image_path.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({super.key});

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  final OrderPlacedController _orderPlacedController =
      Get.put(OrderPlacedController());
  TextEditingController searchByPartsController = TextEditingController();
  // The full list of orders from the controller
  late List<OrderPlacedModel> _orderPlaced;
  // The filtered list shown on the UI
  late List<OrderPlacedModel> _filteredOrderPlaced;

  @override
  void initState() {
    super.initState();
    _orderPlaced = _orderPlacedController.orderPlacedList;
    // Initially, display all orders.
    _filteredOrderPlaced = List.from(_orderPlaced);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Placed'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .02),
            child: Column(
              children: [
                const Text(
                  'You can search your order by using part number',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                Center(
                  child: SizedBox(
                    width: mq.width * .92,
                    child: Center(
                      child: CustomTextFormField(
                        controller: searchByPartsController,
                        text: 'Search by part number',
                        suffixIcon: IconButton(
                            onPressed: () async {
                              searchByPartsController.clear();
                              // await SendNotification.sendPushNotification(
                              //     token:
                              //     "cdUGWbtmTlSprBnaKolH0l:APA91bHfc3ow_9Fq9T20PowxgK_sbwGOOuRkyRySVfSc-WUSJ-muZMpo3QM4zODB5uSVqvi_UNaCd2P2Cew6Tv4QANML0X7y2hWas2b30R_aeb8KqO2QiEw",
                              //     title: "From Order Placed",
                              //     body: "Send notification using function in order placed screen",
                              //     data: {
                              //       "Screen": "OrderReceivedScreen",
                              //       "key2": "value2",
                              //     });

                              // await FirebaseDB.createNotificationDB(); ///comment
                              setState(() {
                                _filteredOrderPlaced = List.from(_orderPlaced);
                              });
                            },
                            icon: Icon(
                              Icons.clear,
                              color: AppColor.primary,
                            )),
                        onChanged: (val) async {
                          String filteredValue =
                              await ControllerUtils.partNumberValidation(val);
                          // String filteredValue = val.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
                          searchByPartsController.text =
                              filteredValue.toUpperCase().trim();

                          setState(() {
                            if (filteredValue.isEmpty) {
                              // If search text is empty, display all orders.
                              _filteredOrderPlaced = List.from(_orderPlaced);
                            } else {
                              // Filter orders by part number (case-insensitive)
                              _filteredOrderPlaced =
                                  _orderPlaced.where((order) {
                                return order.partNumber!
                                    .toLowerCase()
                                    .contains(filteredValue.toLowerCase());
                              }).toList();
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                if (_orderPlacedController.errorMsg.value != null)
                  Obx(() =>
                      Text(_orderPlacedController.errorMsg.value.toString())),
                Flexible(
                  child: (_filteredOrderPlaced.isEmpty)
                      // ? const Center(child: Text("No orders found"))
                      ? const SizedBox.shrink()
                      : ListView.builder(
                          // padding: const EdgeInsets.all(8.0),
                          itemCount: _filteredOrderPlaced.length,
                          itemBuilder: (context, index) {
                            final item = _filteredOrderPlaced[index];
                            return _buildExpansionTile(item, index);
                          },
                        ),
                ),
              ],
            ),
          ),
          Obx(() => _orderPlacedController.isLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildDetails(String title, String detail) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(
          width: mq.width - mq.width * .5,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                detail,
                style: TextStyle(fontSize: 14),
              )),
        ),
      ],
    );
  }

  // Widget _buildDetails(String title, String detail) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 4.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '$title: ',
  //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //         ),
  //         Expanded(
  //           child: SizedBox(
  //             height: 20, // constrain height to avoid unbounded issues
  //             child: SingleChildScrollView(
  //               scrollDirection: Axis.horizontal,
  //               child: Text(
  //                 detail,
  //                 style: const TextStyle(fontSize: 14),
  //                 overflow: TextOverflow.visible,
  //                 softWrap: false,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildExpansionTile(item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        // controller: _expansionTileController,
        tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text(
            //   item.partNumber,
            //   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            // ),
            _buildExpansionTileTitle(item.partNumber),
            const SizedBox(
              width: 1,
            ),
            _buildExpansionTileTitle(item.partDesc),
            const SizedBox(
              width: 1,
            ),
            // _buildExpansionTileTitle('₹ ${item.mrp.toInt()}'),
            // SizedBox(
            //   width: mq.width * .3,
            //   child: Text(
            //     item.partDesc,
            //     style:
            //         const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            //   ),
            // ),

            Text(
              '₹ ${item.mrp.toInt().toString()}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: AppColor.primaryShade,
        collapsedBackgroundColor:
            AppColor.primaryShade, // Replace with AppColor.primaryShade
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 5.0),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetails('Req. Qty', item.qty.toString()),
                    _buildDetails('Dealer Name', item.dealerName),
                    _buildDetails('Seller Location', item.sellerLocation),
                    _buildDetails('Placed on', item.requestDate),
                    _buildDetails('Offer Price',
                        '${item.price.toInt().toString()}/Qty @ ${item.discount}% Disc'),
                    _buildDetails('Remarks', item.remarks),
                  ],
                ),
                CustomCircleAvatar(
                    icon: Icons.delete,
                    onTap: () {
                      _orderPlacedController.odrDltResMsg.value = null;
                      _orderPlacedController.odrDltErrorMsg.value = null;
                      AppDialog.dialogForYesNo(
                          'Are you sure you want to delete it\nPart Number: ${item.partNumber}',
                          AppImages.decisionMaking, () async {
                        Get.back();
                        bool checkInt = await checkInternet();
                        if (checkInt) {
                          await _orderPlacedController
                              .orderPlacedDeleteAsBuyer(item.bigId.toString());
                          if (_orderPlacedController.odrDltResMsg.value !=
                              null) {
                            AppDialog.midPopUp(
                                AppImages.delete,
                                _orderPlacedController.odrDltResMsg.value ??
                                    "Part Request Deleted");
                            _orderPlacedController.orderPlacedList
                                .removeAt(index);
                            _filteredOrderPlaced = List.from(
                                _orderPlacedController.orderPlacedList);
                          } else {
                            CustomBottomSheet.showSnackBar(
                                context,
                                _orderPlacedController.odrDltErrorMsg.value ??
                                    "There is some Problem");
                          }
                        } else {
                          Get.to(() => NoInternetScreen());
                        }
                        setState(() {});
                      }, () => Get.back());
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildExpansionTileTitle(String text) {
    return SizedBox(
      width: mq.width * .29,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
