import 'package:flutter/material.dart';
import 'package:gainer/gainer/screens/home_buyers_stage/po_updation/po_images_screen.dart';
import 'package:gainer/gainer/screens/home_buyers_stage/po_updation/po_reject_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../main.dart';
import '../../../apis_functionality/api_service.dart';
import '../../../apis_functionality/send_notification_service.dart';
import '../../../controllers/buyer_controller/po_updation_controller.dart';
import '../../../controllers/check_internet/no_internet_screen.dart';
import '../../../controllers/home_screen_controller.dart';
import '../../../model/buyer_model/po_updation_model.dart';
import '../../../shared_preferences/shared_preferences_get_data.dart';
import '../../../utility/controller_utils.dart';
import '../../../widget/bottomsheet_for_picture.dart';
import '../../../widget/circular_progress_indicator.dart';
import '../../../widget/dialog.dart';
import '../../../widget/reusable_checkbox.dart';
import '../../../widget/reusable_circle_avatar.dart';
import '../../../widget/reusable_elevated_button.dart';
import '../../../widget/reusable_text_field_qty.dart';
import '../../../widget/reusable_widget.dart';
import '../../../widget/reusable_widget_po_pr.dart';
import '../../../widget/toggle_outline_button.dart';
import '../../check_internet/check_internet_connectivity.dart';
import '../../colors.dart';
import '../../constant_image_path.dart';
import 'order_summary_screen.dart';

class PoUpdationScreen extends StatefulWidget {
  const PoUpdationScreen({super.key});

  @override
  State<PoUpdationScreen> createState() => _PoUpdationScreenState();
}

class _PoUpdationScreenState extends State<PoUpdationScreen> {
  final _raisePo = GlobalKey<FormState>();
  final _furtherPo = GlobalKey<FormState>();
  final PoUpdationController _poUpdationController =
      Get.put(PoUpdationController());
  final LocationController _locationController = Get.put(LocationController());

  bool isSellerWiseView = true;
  bool isPartWiseView = false;
  bool isSearchable = false;
  bool isFiltered = false;
  double _filteredSliderValue = 0.0;
  bool isExpanded = false;
  final TextEditingController _searchbarController = TextEditingController();

  late List<PoUpdationModel> poUpdation;
  late List<PoUpdationModel> filteredPoUpdation;
  String sellerLocationID = "";
  String sellerDealerName = "";
  // Map to track the switch state for each partNumber
  // Map<String, bool> switchStates = {};
  // for store table val use at time of hit api
  List<Map<String, dynamic>> poTableVal = [];
  // List<Map<String, dynamic>> poTableValue = [];
  // Create a list of controllers
  List<TextEditingController> qtyControllers = [];
  // final List<TextEditingController> raisePoControllers = [];
  final TextEditingController _furtherRemarks = TextEditingController();
  final TextEditingController _raisePoRemarks = TextEditingController();
  final TextEditingController _raisePoNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initWork();
  }

  void _initWork() {
    poUpdation = _poUpdationController.poUpdationList;
    filteredPoUpdation = List.from(poUpdation);

    // Initialize controllers with values based on the index
    for (var i = 0; i < filteredPoUpdation.length; i++) {
      // qtyControllers.add(TextEditingController(text: filteredPoUpdation[i].qty.toString()));
      qtyControllers.add(TextEditingController(
          text: filteredPoUpdation[i].sellerFreeStock <
                  filteredPoUpdation[i].dispatchQty
              ? filteredPoUpdation[i].sellerFreeStock.toInt().toString()
              : filteredPoUpdation[i].dispatchQty.toInt().toString()));
    }

    _poUpdationController.switchStates.clear();
  }

  @override
  void dispose() {
    // Dispose all controllers when screen is removed
    for (var controller in qtyControllers) {
      controller.dispose();
    }
    // for (var controller in raisePoControllers) {
    //   controller.dispose();
    // }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      filteredPoUpdation = List.from(poUpdation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PO Updation')),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .03, vertical: mq.height * .02),
            child: Column(
              children: [
                _buildViewSelectionRow(),
                SizedBox(height: mq.height * .02),
                _buildOrderFilterRow(),
                if (isSearchable) _buildSearchBar(),
                // customSearchBar('Search by seller', _searchbarController, () {}),
                SizedBox(height: mq.height * .02),
                if (isFiltered) _buildFilterSlider(),
                SizedBox(height: mq.height * .01),
                if (_poUpdationController.errorMsg.value != null)
                  Obx(() =>
                      Text(_poUpdationController.errorMsg.value.toString())),
                // _poUpdationController.isLoading.value? SizedBox.shrink():
                isSellerWiseView
                    ? Expanded(child: _buildSellerWiseExpansion())
                    : Expanded(child: _buildPartWiseExpansion()),
              ],
            ),
          ),
          Obx(() => _poUpdationController.isLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink()),
        ],
      ),
      //     if(isFloatingBTnShow)
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onClickSummaryBtn(),
        backgroundColor: AppColor.primary,
        child: Icon(
          Icons.description,
          size: 30,
          color: AppColor.primaryShade,
        ),
      ),
    );
  }

  _onClickSummaryBtn() {
    List toggleValue = _poUpdationController.switchStates.entries
        .where((entry) => entry.value == true) // Filter only true values
        .map((entry) => entry.key) // Extract keys
        .toList();

    //for store stable data in map
    List<Map<String, dynamic>> orderData = [];
    for (var i = 0; i < filteredPoUpdation.length; i++) {
      for (var j = 0; j < toggleValue.length; j++) {
        if (toggleValue[j] == filteredPoUpdation[i].bigId.toString() &&
            qtyControllers[i].text.isNotEmpty &&
            qtyControllers[i].text != '0') {
          orderData.add({
            "PartNo": filteredPoUpdation[i].partNumber,
            "Desc": filteredPoUpdation[i].partDesc,
            "Seller":
                '${filteredPoUpdation[i].dealerName}\n${filteredPoUpdation[i].sellerLocation}',
            "Qty": qtyControllers[i].text,
            // "Value": filteredPoUpdation[i].price,
            "Value":
                filteredPoUpdation[i].price * int.parse(qtyControllers[i].text)
          });

          sellerLocationID = filteredPoUpdation[i].sellerLocationId.toString();
          sellerDealerName = filteredPoUpdation[i].dealerName;
        }
      }
    }

    if (orderData.isNotEmpty) {
      _getTableValue(); // for update poTableVal
      Get.to(() => const OrderSummaryScreen(), arguments: {
        "poTableVal": poTableVal,
        "orderData": orderData,
        "sellerLocationID": sellerLocationID,
        "sellerDealerName": sellerDealerName,
      })?.then((_) {
        FocusScope.of(context).unfocus();
        _refreshPage();
      });
    } else {
      CustomBottomSheet.showSnackBar(
          context, 'Please select at least one part which Qty greater than 0');
    }
  }

  Widget _buildSellerWiseExpansion() {
    // Group orders by buyerLocation
    Map<String, List<PoUpdationModel>> groupedOrders = {};

    for (var order in filteredPoUpdation) {
      if (!groupedOrders.containsKey(order.sellerLocation)) {
        groupedOrders[order.sellerLocation] = [];
      }
      groupedOrders[order.sellerLocation]!.add(order);

      qtyControllers[filteredPoUpdation.indexOf(order)].text =
          order.sellerFreeStock < order.dispatchQty
              ? order.sellerFreeStock.toInt().toString()
              : order.dispatchQty.toInt().toString();
    }

    if (groupedOrders.isNotEmpty) {
      return ListView(
        children: groupedOrders.entries.map((entry) {
          // final location = entry.key;
          final orders = entry.value;
          return _buildSellerGroupedExpansionTile(orders);
        }).toList(),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSellerGroupedExpansionTile(List<PoUpdationModel> orders) {
    double totalPay = 0;
    List<DateTime> validDates = [];

    for (var order in orders) {
      if (order.requestDate.isNotEmpty) {
        try {
          String cleanedDate =
              order.requestDate.replaceAll(RegExp(r'\s+'), ' ').trim();
          totalPay += order.partValue.floor();

          DateTime parsedDate =
              DateFormat("MMM d yyyy h:mma").parse(cleanedDate);
          validDates.add(parsedDate);
        } catch (e) {}
      }
    }

    String formattedMaxDate = "";

    if (validDates.isNotEmpty) {
      DateTime maxDate = validDates.length == 1
          ? validDates.first
          : validDates.reduce((a, b) => a.isAfter(b) ? a : b);

      formattedMaxDate = DateFormat("MMM d yyyy").format(maxDate);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        // tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildExpansionTitle(formattedMaxDate),
            SizedBox(
              width: mq.width * .3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildExpansionTitle(orders.first.dealerName),
                  _buildExpansionTitle(orders.first.sellerLocation),
                ],
              ),
            ),
            _buildExpansionTitle('₹ ${totalPay.toInt()}'),
          ],
        ),
        backgroundColor: AppColor.primaryShade,
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

  Widget _buildPartGroupedExpansionTile(List<PoUpdationModel> orders) {
    //calculate total value
    int totalReqQty = 0;
    for (var items in orders) {
      totalReqQty += items.qty;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        // tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 20,
          children: [
            _buildExpansionTitle(orders.first.partNumber),
            Expanded(
              // width: mq.width * .25,
              child: _buildExpansionTitle(orders.first.partDesc),
            ),
            _buildExpansionTitle('Qty: $totalReqQty'),
          ],
        ),
        backgroundColor: AppColor.primaryShade,
        collapsedBackgroundColor: AppColor.primaryShade,
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 5.0),
        // children: orders.map((order) => _buildPartOrderDetails(order)).toList(),
        children: orders.asMap().entries.map((entry) {
          final index = entry.key;
          final order = entry.value;

          return Column(
            children: [
              _buildPartOrderDetails(order),
              if (orders.length > 1 && index != orders.length - 1)
                const Divider(color: Colors.black),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPartOrderDetails(PoUpdationModel item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: _buildRemarksText(item.dealerName),
              ),
              const SizedBox(width: 15), // spacing between two boxes
              Expanded(
                flex: 5,
                child: _buildRemarksText(item.sellerLocation),
              ),
              // _buildRemarksText(item.sellerLocation),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(item.dealerName),
                  // Text(item.sellerLocation),
                  _showPartDetails(item),
                ],
              ),
              _buildToggleBtn(item)
            ],
          ),
          SizedBox(height: mq.height * .005),
          _buildIconBtn(item),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(PoUpdationModel order) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      // padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          _buildSellerOrderDetailsRow(order),
          // SizedBox(height: mq.height * .01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _boldText("MRP: ₹ ${order.mrp.toInt()}"),
              _boldText("Offer : ₹ ${order.price.toInt()}"),
              _boldText("Disc: ${order.discount.toInt()}%"),
              // Text(
              //   "MRP: ₹ ${order.mrp.toInt()}",
              //   style: const TextStyle(fontWeight: FontWeight.bold),
              // ),
              // Text(
              //   'Offer : ₹ ${order.price.toInt()}',
              //   style: const TextStyle(fontWeight: FontWeight.bold),
              // ),
              // Text(
              //   'Disc: ${order.discount.toInt()}%',
              //   style: const TextStyle(fontWeight: FontWeight.bold),
              // ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _showPartDetails(order),
              _buildToggleBtn(order),
            ],
          ),
          SizedBox(height: mq.height * .005),
          _buildIconBtn(order),
          // SizedBox(height: mq.height * .005),
        ],
      ),
    );
  }

  Widget _showPartDetails(PoUpdationModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Offer : ₹ ${order.price.toInt()}',
                //   style: const TextStyle(fontWeight: FontWeight.bold),
                // ),
                // buildDtlRow('Avl Qty : ', '${order.sellerFreeStock.toInt()}'),
                Text('Avl Qty : ${order.sellerFreeStock.toInt()}'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Disc: ${order.discount.toInt()}%',
                //     style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Req Qty: ${order.qty.toInt()}'),
              ],
            ),
          ],
        ),
        _buildRemarksRow('Buyer : ', order.remarks.toString()),
        _buildRemarksRow('Seller : ', order.requestAcceptRemarks.toString()),
      ],
    );
  }

  Widget _buildRemarksRow(String text1, String text2) {
    return Row(
      children: [
        Text(text1),
        SizedBox(
          width: mq.width - 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(text2),
          ),
        )
      ],
    );
  }

  Widget _buildIconBtn(PoUpdationModel order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomCircleAvatar(
            icon: order.partImage != null && order.partImage!.isNotEmpty
                ? Icons.image
                : Icons.image_not_supported,
            onTap: () async {
              // Split the string by '##' and store in a list
              List<String>? partImages = [];
              if (order.partImage != null) {
                partImages = order.partImage?.split("##");
              }
              if (partImages != null &&
                  partImages.isNotEmpty &&
                  partImages[0].isNotEmpty) {
                bool checkInt = await checkInternet();
                if (checkInt) {
                  Get.to(() => PoImagesScreen(
                        partImages: partImages ??
                            [
                              'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg'
                            ],
                      ));
                } else {
                  Get.to(() => NoInternetScreen());
                }
              } else {
                AppDialog.midPopUp(
                    AppImages.noImage, 'There is no image of this part');
              }
            }),
        CustomCircleAvatar(
            icon: Icons.thumb_up,
            onTap: () {
              String qtyController =
                  qtyControllers[filteredPoUpdation.indexOf(order)].text;
              if (qtyController.isEmpty || qtyController == '0') {
                CustomBottomSheet.showSnackBar(
                    context, "Please fill Qty greater than 0");
              } else {
                _onClickThumbUp(order);
              }
            }),
        CustomCircleAvatar(
          icon: Icons.thumb_down,
          onTap: () {
            Get.to(() => PoRejectScreen(
                  bigId: order.bigId,
                  freeStock: order.sellerFreeStock.toInt(),
                  sellerLocationID: order.sellerLocationId.toString(),
                  sellerDealerName: order.dealerName,
                  partNumber: order.partNumber,
                ))?.then((_) {
              _refreshPage();
            });
          },
        ),
        CustomCircleAvatar(
          icon: Icons.edit_note,
          onTap: () {
            _furtherRemarks.clear();
            Get.defaultDialog(
              title: 'Further Details',
              titlePadding: const EdgeInsets.only(top: 20),
              content: Column(
                children: [
                  Text('Part Number: ${order.partNumber}'),
                  Form(
                      key: _furtherPo,
                      child: CustomTextFormField(
                        controller: _furtherRemarks,
                        text: 'Enter Remarks',
                        // suffixIcon:
                        //     Icon(Icons.edit, color: AppColor.primary),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter remarks'
                            : null,
                        onChanged: (value) async {
                          // Allow only letters, numbers, spaces, dashes (-), and commas (,)
                          String filteredValue =
                              await ControllerUtils.remarksValidation(value);
                          if (value != filteredValue) {
                            _furtherRemarks.text = filteredValue;
                          }
                        },
                      )),
                  SizedBox(
                    height: mq.height * .02,
                  ),
                  CustomElevatedButton(
                    onTap: () {
                      if (_furtherPo.currentState!.validate()) {
                        Get.back();
                        _onSubmitFurtherDetails(
                          order.bigId,
                          _furtherRemarks.text,
                          order.sellerLocationId.toString(),
                          order.partNumber,
                        );
                      }
                    },
                    text: 'Submit',
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildToggleBtn(PoUpdationModel order) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(),
          // color: Colors.black12,
          color:
              order.orderFor == "Vehicle" ? Colors.red[100] : Colors.green[100],
          borderRadius: BorderRadius.circular(6)),
      padding: EdgeInsets.symmetric(horizontal: mq.width * .01),
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
              // width: 30,
              width: 20,
              child: CustomTextFieldQty(
                controller: qtyControllers[filteredPoUpdation.indexOf(order)],
                onChanged: (val) {
                  // Return early if the input is empty
                  if (val.isEmpty) return;

                  // Cache the available stock and the controller for easier access
                  final int availableStock = order.sellerFreeStock.toInt();
                  final int dispatchQty = order.dispatchQty.toInt();
                  final controller =
                      qtyControllers[filteredPoUpdation.indexOf(order)];

                  // Prevent the first character from being '0'
                  if (val.isNotEmpty && val.startsWith("0")) {
                    controller.text = controller.text.replaceFirst('0', '');
                  }
                  // If the entered value is numeric
                  if (val.isNumericOnly) {
                    final int enteredQty = int.parse(val);
                    if (enteredQty > dispatchQty) {
                      // Set the text to the maximum available stock
                      controller.text = dispatchQty.toString();
                      // Notify the user
                      CustomBottomSheet.showSnackBar(context,
                          "PO Qty can't be greater than dispatchQty Qty $dispatchQty");
                    } else if (enteredQty > availableStock) {
                      // Set the text to the maximum available stock
                      controller.text = availableStock.toString();
                      // Notify the user
                      CustomBottomSheet.showSnackBar(context,
                          "PO Qty can't be greater than Free Stock $availableStock");
                    }
                  } else {
                    // If non-numeric characters are detected, remove the last character
                    if (controller.text.isNotEmpty) {
                      controller.text = controller.text
                          .substring(0, controller.text.length - 1);
                    }
                  }
                },
              )),
          Obx(
            () => SizedBox(
              width: 40,
              height: 45,
              child: CustomCheckBox(
                value: _poUpdationController
                        .switchStates[order.bigId.toString()] ??
                    false,
                onChanged: (val) {
                  _poUpdationController.switchStates[order.bigId.toString()] =
                      val ?? false;
                  if (val == false) {
                    _poUpdationController.switchStates
                        .remove(order.bigId.toString());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerOrderDetailsRow(PoUpdationModel order) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 20,
      children: [
        _buildExpansionDtlRow(order.partNumber),
        Expanded(child: _buildExpansionDtlRow(order.partDesc)),
        // _buildExpansionDtlRow('MRP: ₹ ${order.mrp.toInt()}'),
      ],
    );
  }

  // Widget _buildPartOrderHeadRow(String partNumber, String partDesc, String reqQty) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       SizedBox(width: mq.width*.22,
  //           child: _buildExpansionTitle(partNumber)),
  //           // child: _buildExpansionDtlRow(partNumber)),
  //       SizedBox(width: mq.width*.28,
  //           child: _buildExpansionDtlRow(partDesc)
  //       ),
  //       _buildExpansionDtlRow('Req Qty: $reqQty'),
  //     ],
  //   );
  // }

  // //Date,DealerName/Location,partCount
  // Widget _buildExpansionTitle(String titleText) {
  //   return SingleChildScrollView(
  //       scrollDirection: Axis.horizontal, child: Text(titleText));
  // }
  // Date,DealerName/Location,partCount
  Widget _buildExpansionTitle(String titleText) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          titleText,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColor.primary),
        ));
  }

  // partNumber,Description,MRP
  Widget _buildExpansionDtlRow(String detailText) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          detailText,
          style: TextStyle(
              fontSize: 14,
              color: AppColor.primary,
              fontWeight: FontWeight.bold),
        ));
  }

  //for Remarks Buyer/Seller
  Widget _buildRemarksText(String text) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: Text(text));
  }

  /// Builds the toggle button row for Seller Wise View and Part Wise View
  Widget _buildViewSelectionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ToggleOutlineButton(
            text: 'Seller Wise View',
            isActive: isSellerWiseView,
            onToggle: () {
              setState(() {
                isExpanded = false;
                isSellerWiseView = true;
                isPartWiseView = false;
              });
            },
          ),
        ),
        SizedBox(width: mq.width * .04),
        Expanded(
          child: ToggleOutlineButton(
            text: 'Part Wise View',
            isActive: isPartWiseView,
            onToggle: () {
              setState(() {
                isExpanded = false;
                isPartWiseView = true;
                isSellerWiseView = false;
              });
            },
          ),
        ),
      ],
    );
  }

  /// Builds the order filter row with search and filter buttons
  Widget _buildOrderFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customOderContainer('Vehicle Orders', Colors.red[100]!),
        customOderContainer('Stock Order', Colors.green[100]!),
        _buildSearchAndFilterButtons(),
      ],
    );
  }

  /// Builds search and filter buttons inside a container
  Widget _buildSearchAndFilterButtons() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primaryShade,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width * .001),
        child: Row(
          children: [
            IconButton(
              onPressed: () => setState(() => isSearchable = !isSearchable),
              icon: Icon(Icons.search, color: AppColor.primary),
            ),
            SizedBox(width: mq.width * .005),
            IconButton(
              onPressed: () => setState(() => isFiltered = !isFiltered),
              icon: Icon(Icons.filter_alt, color: AppColor.primary),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the filter slider for discount percentage
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
                    filteredPoUpdation = poUpdation.where((part) {
                      return part.discount >=
                          (_filteredSliderValue * 100).toInt();
                    }).toList();
                  }),
            ),
            Text('Disc Grater then: ${(_filteredSliderValue * 100).toInt()}%')
          ],
        ),
      ],
    );
  }

  /// Builds an expansion tile for each item
  // Widget buildExpansionTile(item, int index) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 8.0),
  //     child: ExpansionTile(
  //       title: _buildTileHeader(item),
  //       backgroundColor: AppColor.primaryShade,
  //       collapsedBackgroundColor: AppColor.primaryShade,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //       children: [_buildTileDetails(item)],
  //     ),
  //   );
  // }

  /// Builds the header row for the expansion tile
  // Widget _buildTileHeader(Map<String, dynamic> item) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(item["date"],
  //           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
  //       SizedBox(
  //           width: mq.width * .3,
  //           child: Text(item["location"],
  //               style: const TextStyle(
  //                   fontSize: 12, fontWeight: FontWeight.bold))),
  //       Text(item["discountedPrice"],
  //           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
  //     ],
  //   );
  // }

  // //Date,DealerName/Location,partCount
  // Widget _buildExpansionTitle(String titleText) {
  //   return SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Text(titleText,
  //           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)));
  // }
  /// Builds the details section of the expansion tile
  // Widget _buildTileDetails(Map<String, dynamic> item) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(item["productId"]),
  //             Text(item["name"]),
  //             Text('MRP: ${item["mrp"]}')
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPartWiseExpansion() {
    // Group orders by buyerLocation
    Map<String, List<PoUpdationModel>> groupedOrders = {};

    for (var order in filteredPoUpdation) {
      if (!groupedOrders.containsKey(order.partNumber)) {
        groupedOrders[order.partNumber] = [];
      }
      groupedOrders[order.partNumber]!.add(order);

      qtyControllers[filteredPoUpdation.indexOf(order)].text =
          order.sellerFreeStock < order.dispatchQty
              ? order.sellerFreeStock.toInt().toString()
              : order.dispatchQty.toInt().toString();
    }

    if (filteredPoUpdation.isNotEmpty) {
      return ListView(
        children: groupedOrders.entries.map((entry) {
          // final location = entry.key;
          final orders = entry.value;
          return _buildPartGroupedExpansionTile(orders);
        }).toList(),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSearchBar() {
    return CustomTextFormField(
      controller: _searchbarController,
      text: 'Search by seller name/location',
      suffixIcon: IconButton(
        onPressed: () {
          _searchbarController.clear();
          setState(() {
            filteredPoUpdation = List.from(poUpdation);
          });
        },
        icon: Icon(
          Icons.clear,
          color: AppColor.primary,
        ),
      ),
      onChanged: (val) {
        setState(() {
          // Filter orders by part number (case-insensitive)
          // Allow only letters, spaces, and dashes
          String filteredValue = val.replaceAll(RegExp(r'[^a-zA-Z \-]'), '');
          // Prevent starting with space or dash
          while (filteredValue.startsWith(RegExp(r'[ \-]'))) {
            filteredValue = filteredValue.substring(1);
          }
          if (val != filteredValue) _searchbarController.text = filteredValue;
          if (val.isEmpty) {
            // If search text is empty, display all orders.
            filteredPoUpdation = List.from(poUpdation);
          } else {
            filteredPoUpdation = poUpdation.where((order) {
              final searchText = _searchbarController.text.toLowerCase();

              return order.dealerName.toLowerCase().contains(searchText) ||
                  order.sellerLocation.toLowerCase().contains(searchText);
            }).toList();
          }
        });
      },
    );
  }

  _onSubmitFurtherDetails(int bigId, String furtherRemarks,
      String sellerLocationID, String partNumber) async {
    String bigID = bigId.toString();
    String remarks = furtherRemarks;

    bool checkInt = await checkInternet();
    if (checkInt) {
      if (await checkInternet()) {
        _poUpdationController.isLoading.value = true;
        final response = await ApiService().poFurtherDetails(
          remarks: remarks,
          bigID: bigID,
        );
        _poUpdationController.isLoading.value = false;
        if (response['success']) {
          AppDialog.midPopUp(AppImages.check, response['data']);
          String selectedLocationName =
              await getStringData("selectedLocationName") ?? "";
          String dealerName =
              _locationController.locationList[0]['Dealer'].toString();
          // await SendNotification.notifyDealerUsers(
          //     sellerLocationID,
          //     "Further Remarks",
          //     "PO Return By $selectedLocationName for Further remarks, please Check",
          //     {});
          await SendNotification.notifyDealerUsers(
              sellerLocationID,
              "Purchase Order (Further Remarks)",
              "Part: $partNumber\n"
                  "Buyer: $dealerName, $selectedLocationName\n"
                  "PO Return for Further remarks, please Check",
              {});
          await _refreshPage();
        } else {
          CustomBottomSheet.showSnackBar(context, response['message']);
        }
      } else {
        Get.to(() => NoInternetScreen());
      }
    }
  }

  Future _onClickThumbUp(PoUpdationModel order) {
    _raisePoNumber.clear();
    _raisePoRemarks.clear();
    _poUpdationController.switchStates.value = _poUpdationController
        .switchStates
        .map((key, value) => MapEntry(key, false));
    _poUpdationController.switchStates[order.bigId.toString()] = true;
    return Get.defaultDialog(
        title: 'Raise PO',
        titlePadding: const EdgeInsets.only(top: 20),
        content: Column(
          children: [
            Text('Part Number: ${order.partNumber}'),
            Form(
                key: _raisePo,
                child: Column(
                  children: [
                    CustomTextFormField(
                        controller: _raisePoNumber,
                        text: 'Enter PO Number',
                        // suffixIcon: Icon(Icons.numbers, color: AppColor.primary),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter PO Number'
                            : null,
                        onChanged: (value) {
                          String filteredValue =
                              value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
                          if (filteredValue.length > 10) {
                            filteredValue = filteredValue.substring(0, 10);
                          }
                          if (value != filteredValue) {
                            _raisePoNumber.text = filteredValue;
                          }
                        }),
                    SizedBox(height: mq.height * .01),
                    CustomTextFormField(
                        controller: _raisePoRemarks,
                        // controller: raisePoControllers[filteredPoUpdation.indexOf(order)],
                        text: 'Enter Remarks',
                        // suffixIcon: Icon(Icons.edit, color: AppColor.primary),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter remarks'
                            : null,
                        onChanged: (value) async {
                          String filteredValue =
                              await ControllerUtils.remarksValidation(value);

                          // Update the text field if changes were made
                          if (value != filteredValue) {
                            _raisePoRemarks.text = filteredValue;
                          }
                        }),
                  ],
                )),
            SizedBox(height: mq.height * .02),
            CustomElevatedButton(
              onTap: () {
                if (_raisePo.currentState!.validate()) {
                  Get.back();
                  _onSubmitPoRaised(_raisePoNumber.text,
                      order.sellerLocationId.toString(), order.partNumber);
                }
              },
              text: 'Submit',
            )
          ],
        ));
  }

  _onSubmitPoRaised(
      String raisePoNumber, String sellerLocationId, String partNumber) async {
    String poNumber = raisePoNumber;
    int userId = await getIntData('tCode');
    String brandId = _locationController.stockDetails['BrandID'].toString();
    String dealerId = _locationController.stockDetails['DealerID'].toString();
    String locationId =
        _locationController.stockDetails['LocationID'].toString();
    String tableValue = _getTableValue();

    bool checkInt = await checkInternet();

    if (checkInt) {
      _poUpdationController.isLoading.value = true;
      final response = await ApiService().poRaise(
          poNumber: poNumber,
          userID: userId.toString(),
          brandID: brandId,
          dealerID: dealerId,
          locationID: locationId,
          tableValue: tableValue);
      _poUpdationController.isLoading.value = false;

      if (response['success']) {
        AppDialog.midPopUp(AppImages.check, response['data']);
        // double totalPrice = 0;
        // for (var item in poTableVal) {
        //   double price = double.tryParse(item['price']) ?? 0;
        //   int qty = int.parse(item['poQty']);
        //   totalPrice = price * qty;
        // }
        String selectedLocationName =
            await getStringData("selectedLocationName") ?? "";
        String dealerName =
            _locationController.locationList[0]['Dealer'].toString();
        // await SendNotification.notifyDealerUsers(
        //     sellerLocationId,
        //     "Manifestation Awaited",
        //     "PO Confirmed By $selectedLocationName for ₹ $totalPrice/-, please Invoice & Manifest",
        //     {});
        await SendNotification.notifyDealerUsers(
            sellerLocationId,
            "Purchase Order (CONFIRMED)",
            "Part: $partNumber\n"
                "Buyer: $dealerName, $selectedLocationName\n"
                "Pl do Invoice & manifest details",
            {});
        await _refreshPage();
      } else {
        CustomBottomSheet.showSnackBar(context, response['message']);
      }
    } else {
      Get.to(() => NoInternetScreen());
    }
  }

  _getTableValue() {
    poTableVal = [];
    List toggleValue = _poUpdationController.switchStates.entries
        .where((entry) => entry.value == true) // Filter only true values
        .map((entry) => entry.key) // Extract keys
        .toList();

    for (var i = 0; i < filteredPoUpdation.length; i++) {
      for (var j = 0; j < toggleValue.length; j++) {
        if (toggleValue[j] == filteredPoUpdation[i].bigId.toString() &&
            qtyControllers[i].text != '0') {
          poTableVal.add({
            "bigID": filteredPoUpdation[i].bigId.toString(),
            "remarks": _raisePoRemarks.text,
            "poQty": qtyControllers[i].text,
            "price": filteredPoUpdation[i].price.toString(),
            "freeStock": filteredPoUpdation[i].sellerFreeStock.toString(),
          });
        }
      }
    }
    String tableVal = poTableVal
        .map((item) => item.values.map((value) => value.toString()).join("|"))
        .join(",");
    return tableVal;
  }

  _refreshPage() async {
    //refresh the page and show updated data
    String locationId = await getStringData('selectedLocationID');
    //get updated data from api for reflect screen
    if (locationId.isNotEmpty) {
      // _poUpdationController.isLoading.value = true;
      await _poUpdationController.poUpdationAsBuyer(
          locationId, 'REQUESTACCEPTED');
      // _poUpdationController.isLoading.value = false;
    }
    // Initialize controllers with values based on the index
    qtyControllers.clear();
    for (var i = 0; i < filteredPoUpdation.length; i++) {
      // qtyControllers.add(TextEditingController(text: filteredPoUpdation[i].qty.toString()));
      qtyControllers.add(TextEditingController(
          text: filteredPoUpdation[i].sellerFreeStock <
                  filteredPoUpdation[i].dispatchQty
              ? filteredPoUpdation[i].sellerFreeStock.toInt().toString()
              : filteredPoUpdation[i].dispatchQty.toInt().toString()));
    }
    setState(() {
      // store updated list for screen reflect
      filteredPoUpdation = List.from(poUpdation);
    });
  }

  //bold text
  Widget _boldText(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
