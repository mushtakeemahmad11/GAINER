import 'dart:io';
import '../../../../main.dart';
import 'package:flutter/material.dart';
import 'package:gainer/gainer/screens/home_sellers_stage/order_received/reject_order_screen.dart';
import 'package:get/get.dart';
import '../../../apis_functionality/api_service.dart';
import '../../../apis_functionality/firebase_notification_service.dart';
import '../../../apis_functionality/send_notification_service.dart';
import '../../../controllers/check_internet/no_internet_screen.dart';
import '../../../controllers/seller_controller/order_received_controller.dart';
import '../../../controllers/take_image_controller/images_picker_controller.dart';
import '../../../model/seller_model/order_received_model.dart';
import '../../../shared_preferences/shared_preferences_get_data.dart';
import '../../../utility/controller_utils.dart';
import '../../../widget/bottomsheet_for_picture.dart';
import '../../../widget/circular_progress_indicator.dart';
import '../../../widget/dialog.dart';
import '../../../widget/reusable_circle_avatar.dart';
import '../../../widget/reusable_text_field_qty.dart';
import '../../../widget/reusable_widget.dart';
import '../../../widget/reusable_widget_po_pr.dart';
import '../../check_internet/check_internet_connectivity.dart';
import '../../colors.dart';
import '../../constant_image_path.dart';
import 'package:intl/intl.dart';

class OrderReceivedScreen extends StatefulWidget {
  const OrderReceivedScreen({super.key});

  @override
  State<OrderReceivedScreen> createState() => _OrderReceivedScreenState();
}

class _OrderReceivedScreenState extends State<OrderReceivedScreen> {
  final OrderReceivedController _orderReceivedController =
      Get.put(OrderReceivedController());
  final ImagePickerController imageController =
      Get.put(ImagePickerController());
  // The full list of orders from the controller
  late List<OrderReceivedModel> orderReceived;
  // The filtered list shown on the UI
  late List<OrderReceivedModel> filteredOrderReceived;
  // Map<String, String?> selectedDropdownValues = {};
  Map<String, bool> onTapInkWell = {};

  bool _isSearchable = false;
  bool _isFiltered = false;
  double _filteredSliderValue = 0.0;
  // Uint8List? imageBytes = null;

  final TextEditingController _searchbarController = TextEditingController();

  final List<TextEditingController> remarksControllers = [];
  final List<TextEditingController> acceptQtyControllers = [];
  // Store selected images for each order separately
  Map<String, List<File>> selectedImagesPerOrder = {};
  final List<String> options = ["SpareCare Appointed", "Own Arrangements"];
  String? dropdownSelectedValue;

  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    _initWork();
  }

  _initWork() {
    orderReceived = _orderReceivedController.orderReceivedList;
    // Initially, display all orders.
    filteredOrderReceived = List.from(orderReceived);

    for (var order in orderReceived) {
      remarksControllers.add(TextEditingController());
      // Initialize dropdown value for each order
      // selectedDropdownValues[order.bigId.toString()] = options[0];
      // initialized false for all Buyer remarks onTapInkWell
      onTapInkWell[order.bigId.toString()] = false;
    }
    // Map<String, bool> onTapInkWell = Map.fromIterable(orderReceived, value: (key) => false);
    acceptQtyControllers.clear();
    for (var i = 0; i < filteredOrderReceived.length; i++) {
      acceptQtyControllers.add(TextEditingController(
          text: filteredOrderReceived[i].sellerFreeStock <
                  filteredOrderReceived[i].qty
              ? filteredOrderReceived[i].sellerFreeStock.toInt().toString()
              : filteredOrderReceived[i].qty.toInt().toString()));
    }
    dropdownSelectedValue = options[0];
    setState(() {});
  }

  @override
  void dispose() {
    // Dispose all controllers when screen is removed
    for (var controller in remarksControllers) {
      controller.dispose();
    }
    for (var controller in acceptQtyControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Confirmation'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .03, vertical: mq.height * .02),
            child: Center(
              child: Column(
                children: [
                  _buildTopBar(),
                  // if(imageBytes!=null)Center(child: Image.memory(imageBytes!)),
                  if (_isSearchable) _buildSearchBar(),
                  SizedBox(height: mq.height * .02),
                  if (_isFiltered) _buildFilterSlider(),
                  if (_orderReceivedController.errorMsg.value != null)
                    Obx(() => Text(
                        _orderReceivedController.errorMsg.value.toString())),
                  SizedBox(height: mq.height * .01),
                  _orderReceivedController.isLoading.value
                      ? SizedBox.shrink()
                      : Expanded(child: _buildOrderList()),
                ],
              ),
            ),
          ),
          Obx(() => _orderReceivedController.isLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink())
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customOderContainer('Vehicle Orders', Colors.red[100]!),
        customOderContainer('Stock Order', Colors.green[100]!),
        Container(
          decoration: BoxDecoration(
            color: AppColor.primaryShade,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .001),
            child: Row(
              children: [
                IconButton(
                  onPressed: () =>
                      setState(() => _isSearchable = !_isSearchable),
                  icon: Icon(Icons.search, color: AppColor.primary),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    _isFiltered = !_isFiltered;
                    filteredOrderReceived = List.from(orderReceived);
                    _filteredSliderValue = 0.0;
                  }),
                  icon: Icon(Icons.filter_alt, color: AppColor.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return CustomTextFormField(
      controller: _searchbarController,
      text: 'Search by Buyer Name',
      suffixIcon: IconButton(
          onPressed: () {
            _searchbarController.clear();
            setState(() {
              filteredOrderReceived = List.from(orderReceived);
            });
          },
          icon: Icon(
            Icons.clear,
            color: AppColor.primary,
          )),
      onChanged: (value) async {
        String filteredValue = await ControllerUtils.remarksValidation(value);
        if (value != filteredValue) _searchbarController.text = filteredValue;
        setState(() {
          if (value.isEmpty) {
            // If search text is empty, display all orders.
            filteredOrderReceived = List.from(orderReceived);
          } else {
            filteredOrderReceived = orderReceived.where((order) {
              return order.buyerDealer
                  .toLowerCase()
                  .contains(_searchbarController.text.toLowerCase());
            }).toList();
          }
        });
      },
    );
  }

  Widget _buildFilterSlider() {
    return Column(
      children: [
        const Text('Filter the order according to discount'),
        Row(
          children: [
            Expanded(
              child: Slider(
                  activeColor: Colors.grey[300],
                  inactiveColor: AppColor.primary,
                  thumbColor: AppColor.primary,
                  value: _filteredSliderValue,
                  min: 0.0,
                  max: 0.99,
                  divisions: 100,
                  // label: '${(_filteredSliderValue * 100).toInt()}%',
                  onChanged: (val) {
                    // Filter the data where discount is greater than or equal to slider value
                    setState(() => _filteredSliderValue = val);
                    filteredOrderReceived = orderReceived.where((part) {
                      return part.discount >=
                          (_filteredSliderValue * 100).toInt();
                    }).toList();
                  }),
            ),
            Text('Disc: ${(_filteredSliderValue * 100).toInt()}%')
          ],
        ),
      ],
    );
  }

  Widget _buildOrderList() {
    // Group orders by buyerLocation
    Map<String, List<OrderReceivedModel>> groupedOrders = {};

    for (var order in filteredOrderReceived) {
      if (!groupedOrders.containsKey(order.buyerLocation)) {
        groupedOrders[order.buyerLocation] = [];
      }
      groupedOrders[order.buyerLocation]!.add(order);
    }

    return ListView(
      children: groupedOrders.entries.map((entry) {
        final location = entry.key;
        final orders = entry.value;
        return _buildGroupedExpansionTile(location, orders);
      }).toList(),
    );
  }

  Widget _buildGroupedExpansionTile(
      String buyerLocation, List<OrderReceivedModel> orders) {
    DateTime minDate = orders
        .where(
            (order) => order.requestDate.isNotEmpty) // Filter out empty dates
        .map((order) {
      String cleanedDate =
          order.requestDate.replaceAll(RegExp(r'\s+'), ' ').trim();

      return DateFormat("MMM d yyyy h:mma").parse(cleanedDate);
    }).reduce((a, b) => a.isAfter(b) ? b : a); // show min date
    String formattedMinDate = DateFormat("MMM d yyyy").format(minDate);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        title: GestureDetector(
          onLongPress: () {
            CustomBottomSheet.showSnackBar(
                context, "ExtensionTile Long Pressed");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: mq.width * .22,
                  // child: _buildExpansionTitle(orders.first.requestDate.toString())),
                  child: _buildExpansionTitle(formattedMinDate.toString())),
              SizedBox(
                width: mq.width * .3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildExpansionTitle(orders.first.buyerDealer.toString()),
                    _buildExpansionTitle(buyerLocation),
                  ],
                ),
              ),
              _buildExpansionTitle('${orders.length} Part'),
            ],
          ),
        ),

        backgroundColor: AppColor.primaryShade,
        // collapsedBackgroundColor: AppColor.primaryShade,
        collapsedBackgroundColor: AppColor.primaryShade,
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 5.0),
        // children: orders.map((order) => _buildOrderDetails(order)).toList(),
        children: orders.asMap().entries.map((entry) {
          final index = entry.key;
          final order = entry.value;
          return Column(
            children: [
              _buildOrderDetails(order),
              if (orders.length > 1 && index != orders.length - 1)
                Divider(color: AppColor.primary),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderDetails(OrderReceivedModel order) {
    int reqQty = order.sellerFreeStock < order.qty
        ? order.sellerFreeStock.toInt()
        : order.qty.toInt();
    final index = filteredOrderReceived.indexOf(order);
    final controller = acceptQtyControllers[index];
    String? latestBuyerRemarks =
        (order.furtherDetailsRemarks?.isNotEmpty ?? false)
            ? order.furtherDetailsRemarks
            : order.remarks;

    bool isFurtherRemarks = order.furtherDetailsRemarks?.isNotEmpty ?? false;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // spacing: 10,
            children: [
              // SizedBox(
              //     width: mq.width * .28,
              //     child:
              //         _buildExpansionDtlRow(order.partNumber.toString())),
              // SizedBox(
              //     width: mq.width * .3,
              //     child: _buildExpansionDtlRow(
              //       order.partDesc,
              //     )),
              // _buildExpansionDtlRow('MRP: ₹ ${order.mrp.toInt()}'),
              Flexible(
                flex: 3,
                // child: _buildExpansionDtlRow(order.partNumber.toString()),
                child: _buildExpansionTitle(order.partNumber.toString()),
              ),
              Expanded(
                flex: 4,
                // child: _buildExpansionDtlRow(order.partDesc),
                child: _buildExpansionTitle(order.partDesc),
              ),
              // _buildExpansionDtlRow('₹ ${order.mrp.toInt()}'),
              _buildExpansionTitle('₹ ${order.mrp.toInt()}'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Offer: ₹ ${order.price.toInt()}/Qty'),
              Text('Disc: ${order.discount}%'),
              Text('Avl Qty: ${order.sellerFreeStock}'),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///
              // Expanded(
              //   child: CustomDropdown(
              //     hintText: 'Select LSP',
              //     options: options,
              //     onChanged: (val) {
              //       setState(() =>
              //           selectedDropdownValues[order.bigId.toString()] =
              //               val);
              //     },
              //     selectedValue:
              //         selectedDropdownValues[order.bigId.toString()],
              //   ),
              // ),
              ///
              /// Remarks.....
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isFurtherRemarks
                      ? InkWell(
                          onTap: () {
                            AppDialog.getRemarksPopUp("Buyer Remarks", [
                              _buildExpansionTitle("• Request Remark"),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(order.remarks),
                              ),
                              SizedBox(height: 8),
                              _buildExpansionTitle("• Further Request Remark"),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text("${order.furtherDetailsRemarks}"),
                              ),
                            ]);
                            setState(() {
                              // Toggle the value for the corresponding order ID
                              onTapInkWell[order.bigId.toString()] =
                                  !(onTapInkWell[order.bigId.toString()] ??
                                      false);
                            });
                          },
                          child: _buildRemarksRow(
                              "Buyer Remarks : ", latestBuyerRemarks ?? "",
                              isInkWell: true),
                        )
                      : _buildRemarksRow(
                          "Buyer Remarks : ", latestBuyerRemarks ?? ""),
                  // if (onTapInkWell[order.bigId.toString()] == true)
                  //   _buildRemarksRow("Buyer Remarks : ", order.remarks),
                  _buildRemarksRow(
                      "Seller Remarks : ", order.requestAcceptRemarks ?? ""),
                ],
              ),
              const SizedBox(width: 10),

              Container(
                width: 40,
                height: 40, // square shape
                decoration: BoxDecoration(
                  color: order.orderFor == "Vehicle"
                      ? Colors.red[100]
                      : Colors.green[100],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(4),
                child: Center(
                  // child: TextField(
                  //   controller: controller,
                  //   textAlign: TextAlign.center,
                  //   textAlignVertical: TextAlignVertical.center,
                  //   style: const TextStyle(fontSize: 16),
                  //   keyboardType: TextInputType.number,
                  //   inputFormatters: [
                  //     FilteringTextInputFormatter.digitsOnly,
                  //   ],
                  //   decoration: const InputDecoration(
                  //     border: InputBorder.none,
                  //     isCollapsed: true,
                  //     contentPadding: EdgeInsets.zero,
                  //   ),
                  //   onChanged: (val) {
                  //     // Return early if the input is empty
                  //     if (val.isEmpty) return;
                  //     // Cache the available Qty and the controller for easier access
                  //     final int approved = order.sellerFreeStock.toInt();
                  //     final controller = acceptQtyControllers[
                  //         filteredOrderReceived.indexOf(order)];
                  //
                  //     // Prevent the first character from being '0'
                  //     if (val.isNotEmpty && val.startsWith("0")) {
                  //       controller.text =
                  //           controller.text.replaceFirst('0', '');
                  //       // controller.clear();
                  //       // return;
                  //     }
                  //     // If the entered value is numeric
                  //     if (val.isNumericOnly) {
                  //       final int enteredQty = int.parse(val);
                  //       if (enteredQty > order.qty) {
                  //         // Set the text to the maximum available stock
                  //         controller.text = reqQty.toString();
                  //         // Notify the user
                  //         CustomBottomSheet.showSnackBar(context,
                  //             "Accepted Qty can't be greater than Request Qty ${order.qty}");
                  //       } else if (enteredQty > approved) {
                  //         // Set the text to the maximum available stock
                  //         controller.text = approved.toString();
                  //         // Notify the user
                  //         CustomBottomSheet.showSnackBar(context,
                  //             "Accepted Qty can't be greater than Available Qty $approved");
                  //       }
                  //     } else {
                  //       // If non-numeric characters are detected, remove the last character
                  //       if (controller.text.isNotEmpty) {
                  //         controller.text = controller.text
                  //             .substring(0, controller.text.length - 1);
                  //       }
                  //     }
                  //   },
                  // ),
                  child: CustomTextFieldQty(
                    controller: controller,
                    onChanged: (val) {
                      // Return early if the input is empty
                      if (val.isEmpty) return;
                      // Cache the available Qty and the controller for easier access
                      final int approved = order.sellerFreeStock.toInt();
                      final controller = acceptQtyControllers[
                          filteredOrderReceived.indexOf(order)];

                      // Prevent the first character from being '0'
                      if (val.isNotEmpty && val.startsWith("0")) {
                        controller.text = controller.text.replaceFirst('0', '');
                        // controller.clear();
                        // return;
                      }
                      // If the entered value is numeric
                      if (val.isNumericOnly) {
                        final int enteredQty = int.parse(val);
                        if (enteredQty > order.qty) {
                          // Set the text to the maximum available stock
                          controller.text = reqQty.toString();
                          // Notify the user
                          CustomBottomSheet.showSnackBar(context,
                              "Accepted Qty can't be greater than Request Qty ${order.qty}");
                        } else if (enteredQty > approved) {
                          // Set the text to the maximum available stock
                          controller.text = approved.toString();
                          // Notify the user
                          CustomBottomSheet.showSnackBar(context,
                              "Accepted Qty can't be greater than Available Qty $approved");
                        }
                      } else {
                        // If non-numeric characters are detected, remove the last character
                        if (controller.text.isNotEmpty) {
                          controller.text = controller.text
                              .substring(0, controller.text.length - 1);
                        }
                      }
                    },
                  ),
                ),
              ),

              // Container(
              //   decoration: BoxDecoration(
              //       border: Border.all(),
              //       color: order.orderFor == "Vehicle"
              //           ? Colors.red[100]
              //           : Colors.green[100],
              //       borderRadius: BorderRadius.circular(6)),
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   child: SizedBox(
              //     width: 40,
              //     child: TextField(
              //       textAlignVertical: TextAlignVertical.center,
              //       controller: acceptQtyControllers[
              //           filteredOrderReceived.indexOf(order)],
              //       keyboardType: TextInputType.number,
              //       textAlign: TextAlign.center,
              //       inputFormatters: [
              //         FilteringTextInputFormatter
              //             .digitsOnly, // Allows only 0-9
              //         // FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d{0,6}$')), // No leading 0, max 7 digits
              //       ],
              //       onChanged: (val) {
              //         // Return early if the input is empty
              //         if (val.isEmpty) return;
              //         // Cache the available Qty and the controller for easier access
              //         final int approved = order.sellerFreeStock.toInt();
              //         final controller = acceptQtyControllers[
              //             filteredOrderReceived.indexOf(order)];
              //
              //         // Prevent the first character from being '0'
              //         if (val.isNotEmpty && val.startsWith("0")) {
              //           controller.text =
              //               controller.text.replaceFirst('0', '');
              //           // controller.clear();
              //           // return;
              //         }
              //         // If the entered value is numeric
              //         if (val.isNumericOnly) {
              //           final int enteredQty = int.parse(val);
              //           if (enteredQty > order.qty) {
              //             // Set the text to the maximum available stock
              //             controller.text = reqQty.toString();
              //             // Notify the user
              //             CustomBottomSheet.showSnackBar(context,
              //                 "Accepted Qty can't be greater than Request Qty ${order.qty}");
              //           } else if (enteredQty > approved) {
              //             // Set the text to the maximum available stock
              //             controller.text = approved.toString();
              //             // Notify the user
              //             CustomBottomSheet.showSnackBar(context,
              //                 "Accepted Qty can't be greater than Available Qty $approved");
              //           }
              //         } else {
              //           // If non-numeric characters are detected, remove the last character
              //           if (controller.text.isNotEmpty) {
              //             controller.text = controller.text
              //                 .substring(0, controller.text.length - 1);
              //           }
              //         }
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
          // const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller:
                      remarksControllers[filteredOrderReceived.indexOf(order)],
                  text: 'Enter Remarks',
                  // suffixIcon: Icon(Icons.edit, color: AppColor.primary),
                  onChanged: (value) async {
                    String filteredValue =
                        await ControllerUtils.remarksValidation(value);
                    if (value != filteredValue) {
                      remarksControllers[filteredOrderReceived.indexOf(order)]
                          .text = filteredValue;
                    }
                  },
                ),
              ),
              CustomCircleAvatar(
                  icon: Icons.camera_alt, onTap: () => _selectImages(order)),
              SizedBox(width: mq.width * .005),
              CustomCircleAvatar(
                  icon: Icons.thumb_up, onTap: () => _acceptOrder(order)),
              SizedBox(width: mq.width * .005),
              CustomCircleAvatar(
                  icon: Icons.thumb_down, onTap: () => _rejectOrder(order)),
            ],
          ),
          SizedBox(
            height: mq.height * .01,
          ),
          _buildRowForImage(order),
        ],
      ),
    );
  }

  //Date,DealerName/Location,partCount
  Widget _buildExpansionTitle(String titleText) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(titleText,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.primary)));
  }

  // // partNumber,Description,MRP
  // Widget _buildExpansionDtlRow(String detailText) {
  //   return SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Text(
  //         detailText,
  //         style: TextStyle(
  //             fontSize: 14,
  //             color: AppColor.primary,
  //             fontWeight: FontWeight.bold),
  //       ));
  // }

  /// **Show images specific to the selected order**
  Widget _buildRowForImage(OrderReceivedModel order) {
    List<File> images = selectedImagesPerOrder[order.bigId.toString()] ?? [];

    return images.isEmpty
        ? const SizedBox.shrink()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // spacing: 2,
            children: images.map((file) {
              return Stack(
                children: [
                  Card(
                    child: Image.file(file,
                        width: mq.width * .22,
                        height: mq.width * .22,
                        fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: -22,
                    right: -22,
                    child: IconButton(
                      padding: const EdgeInsets.all(20.0),
                      onPressed: () {
                        setState(() {
                          selectedImagesPerOrder[order.bigId.toString()]
                              ?.remove(file);
                        });
                      },
                      icon:
                          Icon(Icons.cancel_outlined, color: AppColor.primary),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
  }

  /// **Selecting Images for a Specific Order**
  Future<void> _selectImages(OrderReceivedModel order) async {
    int currentCount =
        selectedImagesPerOrder[order.bigId.toString()]?.length ?? 0;
    if (currentCount >= 3) {
      CustomBottomSheet.showSnackBar(
          context, 'Maximum limit of image upload is 3');
      return;
    }
    CustomBottomSheet.show(
      context: context,
      onPressedCamera: () async {
        Get.back();
        File? image = await imageController.pickImageFromCamera(3);
        if (image != null) {
          setState(() {
            File selectedImages = File(image.path);
            selectedImagesPerOrder
                .putIfAbsent(order.bigId.toString(), () => [])
                .add(selectedImages);
          });
        }
      },
      onPressedGallery: () async {
        Get.back();
        List<File> images = await imageController.pickImagesFromGallery(3);
        if (images.isNotEmpty) {
          // Take only the first 3-currentCount images
          List<File> selectedImages = images
              .take(3 - currentCount)
              .map((file) => File(file.path))
              .toList();
          setState(() {
            selectedImagesPerOrder
                .putIfAbsent(order.bigId.toString(), () => [])
                .addAll(selectedImages);
            // .addAll(images);
          });
        }
      },
    );
  }

  //remarks widget
  Widget _buildRemarksRow(String text1, String text2,
      {bool isInkWell = false}) {
    return Row(
      children: [
        Text(text1,
            style: TextStyle(
              color: isInkWell ? Colors.blue : Colors.black,
              fontWeight: isInkWell ? FontWeight.bold : FontWeight.normal,
            )),
        SizedBox(
          width: mq.width - 220,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(text2),
          ),
        )
      ],
    );
  }

  // accept order (Thumb up)
  Future<void> _acceptOrder(order) async {
    // await SendNotification.notifyDealerUsers(
    //     order.buyerLocationId.toString(),
    //     "Order Request (CONFIRMED)",
    //     "Part ${order.partNumber}\n"
    //         "Seller: ${order.buyerDealer.toString()} selectedLocationName\n"
    //         "Please make PO & update",
    //     {});
    // String selectedLocationName = await getStringData("selectedLocationName")??"";
    // await SendNotification.notifyDealerUsers(
    //     order.buyerLocationId.toString(),
    //     "PO Awaited",
    //     "Part number ${order.partNumber} accepted by Seller $selectedLocationName", {});
    // await SendNotification.notifyDealerUsers(
    //     order.buyerLocationId.toString(),
    //     "PO Awaited",
    //     "Part number ${order.partNumber} accepted by Seller", {});
    List<File> selectedImages =
        selectedImagesPerOrder[order.bigId.toString()] ?? [];

    String reqQty = acceptQtyControllers[filteredOrderReceived.indexOf(order)]
        .text
        .toString();
    if (reqQty.isNotEmpty && int.parse(reqQty) > 0) {
      AppDialog.dialogForYesNo('Are you sure to Accept order', AppImages.decisionMaking,
          () async {
        Get.back();
        String locationID = await getStringData('selectedLocationID');
        int userID = await getIntData('tCode');
        String remarks =
            remarksControllers[filteredOrderReceived.indexOf(order)]
                .text
                .toString();
        Map<String, String> imageMap = {};
        _orderReceivedController.isLoading.value = true;
        for (int i = 0; i < selectedImages.length; i++) {
          imageMap["img${i + 1}"] = selectedImages[i].path;
        }
        bool checkInt = await checkInternet();
        if (checkInt) {
          final response = await ApiService().orderDueAcceptV2(
              bigID: order.bigId.toString(),
              remarks: remarks,
              confirmQty: reqQty,
              freeStock: order.sellerFreeStock.toString(),
              transporterType: "SCOPE",
              loginUserID: userID.toString(),
              imageFiles: selectedImages);
          _orderReceivedController.isLoading.value = false;
          if (response['success'] == true) {
            remarksControllers.clear();
            AppDialog.midPopUp(AppImages.agreement, '${response['data']}');

            ///send notification to buyer
            String selectedLocationName =
                await getStringData("selectedLocationName") ?? "";

            // await SendNotification.notifyDealerUsers(
            //     order.buyerLocationId.toString(),
            //     "PO Awaited",
            //     "Part number ${order.partNumber} accepted by Seller $selectedLocationName",
            //     {});
            await SendNotification.notifyDealerUsers(
                order.buyerLocationId.toString(),
                "Order Request (CONFIRMED)",
                "Part ${order.partNumber}\n"
                    "Seller: ${order.buyerDealer.toString()}, $selectedLocationName\n"
                    "Please make PO & update",
                {});

            FocusScope.of(context).unfocus();
            _orderReceivedController.isLoading.value = true;
            await _orderReceivedController.orderReceivedAsSeller(
                locationID, 'REQUESTSENT');
            _initWork();
            _orderReceivedController.isLoading.value = false;
            // bool checkInt = await checkInternet();
            // if (checkInt) {
            //   FocusScope.of(context).unfocus();
            //   _orderReceivedController.isLoading.value = true;
            //   await _orderReceivedController.orderReceivedAsSeller(
            //       locationID, 'REQUESTSENT');
            //
            //   // notifyDealerUsers(order.buyerDealerId.toString());
            //
            //   _initWork();
            //   _orderReceivedController.isLoading.value = false;
            // } else {
            //   Get.to(() => NoInternetScreen());
            // }
          } else {
            CustomBottomSheet.showSnackBar(context, '${response['message']}');
          }
        } else {
          Get.to(() => NoInternetScreen());
        }
      }, () => Get.back());
    } else {
      CustomBottomSheet.showSnackBar(
          context, "Please enter Qty greater than 0");
      return;
    }
  }

  //OrderReject click on ThumbDown icon
  Future<void> _rejectOrder(order) async {
    String locationID = await getStringData('selectedLocationID');
    int userID = await getIntData('tCode');
    Get.to(() => RejectOrderScreen(
          bigId: order.bigId,
          freeStock: order.sellerFreeStock,
          partNumber: order.partNumber,
          stockCatType: order.stockCatType,
          sellerLocationID: locationID,
          loginUserID: userID,
          buyerLocationID: order.buyerLocationId.toString(),
          dealerName: order.buyerDealer,
        ))?.then((result) {
      // checkInternet().then((val) async {
      //   if (val) {
      //     await _orderReceivedController.orderReceivedAsSeller(
      //         locationID, 'REQUESTSENT');
      //     remarksControllers.clear();
      //     _initWork();
      //   }
      // });
      if (result == true) {
        checkInternet().then((val) async {
          if (val) {
            await _orderReceivedController.orderReceivedAsSeller(
                locationID, 'REQUESTSENT');
            remarksControllers.clear();
            _initWork();
          }
        });
      }
    });
  }

  // void notifyDealerUsers(String dealerID) async {
  //   print("dealerID::: $dealerID");
  //   // List<String> tokens = await notificationServices
  //   //     .getDeviceTokensByDealerOrLocation(dealerId: dealerID);
  //   String? token = await notificationServices.getDeviceTokenFromFirebase(
  //       dealerId: dealerID);
  //
  //   print("token form FCM $token");
  //   // print("token form FCM $tokens");
  //   //
  //   // for (String token in tokens) {
  //   //   await SendNotification.sendPushNotification(
  //   //     token: token,
  //   //     title: 'Order Confirm',
  //   //     body: 'Your order is confirm',
  //   //     data: {},
  //   //   );
  //   // }
  //
  //   if (token != null) {
  //     await SendNotification.sendPushNotification(
  //       token: token,
  //       title: 'Order Confirm',
  //       body: 'Your order is confirm',
  //       data: {},
  //     );
  //   }
  //   // await sendNotification.sendPushNotification(tokens, 'New Offer!', 'Check out the latest deals!');
  // }
}
