import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../apis_functionality/api_service.dart';
import '../../../apis_functionality/send_notification_service.dart';
import '../../../controllers/check_internet/no_internet_screen.dart';
import '../../../controllers/home_screen_controller.dart';
import '../../../controllers/part_request_controller.dart';
import '../../../model/show_part_availability_model.dart';
import '../../../shared_preferences/shared_preferences_get_data.dart';
import '../../../utility/controller_utils.dart';
import '../../../widget/bottomsheet_for_picture.dart';
import '../../../widget/circular_progress_indicator.dart';
import '../../../widget/dialog.dart';
import '../../../widget/reusable_elevated_button.dart';
import '../../../widget/reusable_widget.dart';
import '../../check_internet/check_internet_connectivity.dart';
import '../../colors.dart';
import '../../constant_image_path.dart';

class ShowAvailabilityScreen extends StatefulWidget {
  const ShowAvailabilityScreen({super.key});

  @override
  State<ShowAvailabilityScreen> createState() => _ShowAvailabilityScreenState();
}

class _ShowAvailabilityScreenState extends State<ShowAvailabilityScreen> {
  // final _formKey = GlobalKey<FormState>();
  final PartRequestController _partRequestController =
      Get.put(PartRequestController());
  final LocationController _locationController = Get.put(LocationController());
  late final List<ShowPartAvailabilityModel> partAvailability;

  // The filtered list shown on the UI
  late List<ShowPartAvailabilityModel> filteredPartAvailability;

  // Lists to track controllers (each entry corresponds to an item)
  final List<TextEditingController> remarksControllers = [];
  final List<TextEditingController> reqQtyControllers = [];

  // Observable discount variable (not currently used)
  final RxDouble discount = 0.0.obs;
  double filteredSliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    partAvailability = _partRequestController.showAvailabilityList;
    filteredPartAvailability = List.from(partAvailability);

    // Initialize controllers for each request separately
    for (var i = 0; i < partAvailability.length; i++) {
      remarksControllers.add(TextEditingController());
      reqQtyControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free memory
    for (var controller in remarksControllers) {
      controller.dispose();
    }
    for (var controller in reqQtyControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  //clear all controller
  void clearControllers() {
    for (var controller in remarksControllers) {
      controller.clear();
    }
    for (var controller in reqQtyControllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Part Availability"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Discount Slider
                _buildDiscountFilterSlider(),

                // part list
                if (filteredPartAvailability.isNotEmpty)
                  Expanded(child: _buildOrderList()),

                // Submit Order Button
                if (filteredPartAvailability.isNotEmpty)
                  CustomElevatedButton(
                      text: 'Submit Order', onTap: () => submitOrder()),
                SizedBox(height: mq.height * 0.02),
              ],
            ),
          ),
          Obx(() => _partRequestController.isLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    // Group orders by buyerLocation
    Map<String, List<ShowPartAvailabilityModel>> groupedOrders = {};
    for (var order in filteredPartAvailability) {
      if (!groupedOrders.containsKey(order.partNumber)) {
        groupedOrders[order.partNumber] = [];
      }
      groupedOrders[order.partNumber]!.add(order);

      // reqQtyControllers[filteredPartAvailability.indexOf(order)].text =
      //     order.q.toString();
    }

    return ListView(
      children: groupedOrders.entries.map((entry) {
        // final location = entry.key;
        final orders = entry.value;
        return _buildGroupedExpansionTile(orders);
      }).toList(),
    );
  }

  Widget _buildGroupedExpansionTile(List<ShowPartAvailabilityModel> item) {
    return Card(
      elevation: 5,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Part Number, Description, and MRP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                _buildCardTitle(item.first.partNumber),
                // const SizedBox(width: 10),
                // SizedBox(
                //   width: mq.width * 0.28,
                //   child: _buildCardTitle(item.first.description),
                // ),
                Expanded(child: _buildCardTitle(item.first.description)),
                // const SizedBox(width: 10),
                // SizedBox(
                //   width: mq.width * 0.26,
                //   // child: _buildCardTitle('MRP: ₹ ${item.first.mrp.toInt()}'),
                //   child: _buildCardTitle('₹ ${item.first.mrp.toInt()}'),
                // ),
                _buildCardTitle('₹ ${item.first.mrp.toInt()}'),
              ],
            ),
            SizedBox(height: mq.height * 0.01),

            Column(
              children: item
                  .map((itemDetails) => _buildCardDetails(itemDetails))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetails(ShowPartAvailabilityModel item) {
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(item.sellerDealer),
        //     Expanded(
        //       child: SingleChildScrollView(
        //         scrollDirection: Axis.horizontal,
        //           child: Text(item.sellerLocation)),
        //     ),
        //   ],
        // ),

        // Row(
        //   children: [
        //     // First Text: takes width as per content
        //     Text(item.sellerDealer),
        //
        //     // Add some spacing between texts (optional)
        //     SizedBox(width: 8),
        //
        //     // Second Text: takes remaining space and scrolls horizontally if needed
        //     Expanded(
        //       child: SingleChildScrollView(
        //         scrollDirection: Axis.horizontal,
        //         child: Text(item.sellerLocation),
        //       ),
        //     ),
        //   ],
        // ),

        Row(
          children: [
            // First Text: only as wide as its content
            Text(item.sellerDealer),

            // Mid spacing (will take flexible space between the two texts)
            // Spacer(),
            SizedBox(width: 20),
            // Second Text: right-aligned, scrollable, takes remaining width
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true, // starts from end
                child: Align(
                  alignment: Alignment
                      .centerRight, // aligns text to right within scroll
                  child: Text(item.sellerLocation),
                ),
              ),
            ),
          ],
        ),

        SizedBox(
          height: mq.height * .002,
        ),
        // Stock, Offer Price, Discount, and TAT
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Offer Price: ₹ ${item.price.toInt()}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Disc: ${double.parse(item.discount).toInt()}%",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Available Qty: ${item.freeStock.toInt()}"),
            Text("TAT: ${item.tat} days"),
          ],
        ),

        // Remarks and Requested Quantity Input Fields
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: CustomTextFormField(
                // controller: remarksController,
                controller:
                    remarksControllers[filteredPartAvailability.indexOf(item)],
                text: "Remarks",
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter Remarks'
                    : null,
                onChanged: (value) async {
                  // Allow only letters, numbers, spaces, dashes (-), and commas (,)
                  // String filteredValue =
                  //     value.replaceAll(RegExp(r'[^a-zA-Z0-9 ,\-]'), '');
                  //
                  // // Prevent starting with space, dash, or comma
                  // while (filteredValue.startsWith(RegExp(r'[ ,\-]'))) {
                  //   filteredValue = filteredValue.substring(1);
                  // }
                  String filteredValue =
                      await ControllerUtils.remarksValidation(value);
                  if (value != filteredValue) {
                    remarksControllers[filteredPartAvailability.indexOf(item)]
                        .text = filteredValue;
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: mq.width * 0.2,
              child: CustomTextFormField(
                controller:
                    reqQtyControllers[filteredPartAvailability.indexOf(item)],
                text: "Req. Qty",
                textInputType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter Req.Qty'
                    : null,
                onChanged: (val) {
                  // Return early if the input is empty
                  if (val.isEmpty) return;

                  // Cache the available stock and the controller for easier access
                  final int availableFreeStock = item.freeStock.toInt();
                  final controller =
                      reqQtyControllers[filteredPartAvailability.indexOf(item)];

                  // Prevent the first character from being '0'
                  if (val.length == 1 && val.startsWith("0")) {
                    controller.clear();
                    return;
                  }
                  // If the entered value is numeric
                  if (val.isNumericOnly) {
                    final int enteredQty = int.parse(val);
                    if (enteredQty > availableFreeStock) {
                      // Set the text to the maximum available stock
                      controller.text = availableFreeStock.toString();
                      // Notify the user
                      CustomBottomSheet.showSnackBar(context,
                          "Request Qty can't be greater than available Qty $availableFreeStock");
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
          ],
        ),
        const Divider(
          color: Colors.white,
          thickness: 1,
        ),
      ],
    );
  }

  void submitOrder() async {
    List<Map<String, dynamic>> orderData = [];
    int allReqQty = 0;
    // List<String> reqQty = [];

    for (var i = 0; i < partAvailability.length; i++) {
      if (reqQtyControllers[i].text.isNotEmpty) {
        orderData.add({
          "partNumber": partAvailability[i].partNumber.toString(),
          "ClusterCode": partAvailability[i].clusterCode.toString(),
          "sellerDealerId": partAvailability[i].sellerDealerID.toString(),
          "sellerLocation": partAvailability[i].sellerLocationID.toString(),
          "sellerStockQty": partAvailability[i].sellerStock.toString(),
          "sellerFreeStocky": partAvailability[i].freeStock.toString(),
          "discount": partAvailability[i].discount.toString(),
          "tat": partAvailability[i].tat.toString(),
          "sellerVerified": partAvailability[i].dealerVerified.toString(),
          "scsVerified": partAvailability[i].scsVerified.toString(),
          "orderQty": reqQtyControllers[i].text.toString(),
          "remarks": remarksControllers[i].text.toString(),
          "price": partAvailability[i].price.toString(),
          "mrp": partAvailability[i].mrp.toString(),
          "rate": partAvailability[i].rate.toString(),
          "stockCat": partAvailability[i].stockCat.toString(),
        });
      }
    }
    for (var i = 0; i < partAvailability.length; i++) {
      if (reqQtyControllers[i].text.isNotEmpty) {
        allReqQty = allReqQty + int.parse(reqQtyControllers[i].text);
        // reqQty.add(reqQtyControllers[i].text);
      }
    }
    if (allReqQty <= 0) {
      CustomBottomSheet.showSnackBar(context, "Please enter Req Qty first");
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter Req Qty first"),));
    } else {
      // for (var i in orderData) {
      //   // String sealerDealerId = i['sellerDealerId'];
      //   String locationID = i['sellerLocation'];
      //   print("locationID from show: $locationID");
      //   int orderQty = int.tryParse(i['orderQty']) ?? 0;
      //   double price = double.parse(i['price']);
      //
      //   String locationName = _locationController.selectedLocation.value??"";
      //   await SendNotification.notifyDealerUsers(
      //       locationID,
      //       "Order Received",
      //       "$orderQty Parts worth ₹ ${(price * orderQty).toStringAsFixed(2)}/-, From $locationName\npl confirm availability",
      //       {"Screen": "orderReceived"});
      // }

      // details for call orderRequestSubmit API
      String brandID =
          _locationController.locationList[0]['BrandID'].toString();
      String dealerID =
          _locationController.locationList[0]['DealerID'].toString();
      String? locationID = _locationController
          .locationIdMap[_locationController.selectedLocation.value]
          .toString();
      var userID = await getIntData('tCode');
      userID = userID.toString();
      String? orderFor = _partRequestController.selectedValue1.value ?? '';
      String lspCode = '';
      String tableVal = orderData
          .map((item) => item.values.map((value) => value.toString()).join("|"))
          .join(",");

      //Order Request submit on click(part Req>show availability>submit order
      // print("tableValue: $tableVal");
      if (tableVal.isNotEmpty) {
        bool checkInt = await checkInternet();
        if (checkInt) {
          _partRequestController.isLoading.value = true;
          var response = await ApiService().orderReqSubmit(brandID, dealerID,
              locationID, userID, orderFor, lspCode, tableVal);
          _partRequestController.isLoading.value = false;
          if (response['success']) {
            Get.back();
            AppDialog.midPopUp(AppImages.check, response['data']);
            for (var i in orderData) {
              String sellerLocationID = i['sellerLocation'];
              String partNum = i['partNumber'];
              // int orderQty = int.tryParse(i['orderQty']) ?? 0;
              // double price = double.parse(i['price']);

              String dealerName =
                  _locationController.locationList[0]['Dealer'].toString();
              String locationName =
                  _locationController.selectedLocation.value ?? "";
              // await SendNotification.notifyDealerUsers(
              //     sellerLocationID,
              //     "Order Received",
              //     "$orderQty Parts worth ₹ ${(price * orderQty).toStringAsFixed(2)}/-, From $locationName\nplease confirm availability",
              //     {"Screen": "orderReceived"});

              await SendNotification.notifyDealerUsers(
                  sellerLocationID,
                  "Order Request (RECEIVED)",
                  "Part: $partNum\n"
                  "Buyer: $dealerName, $locationName\n"
                  "Pl check & CONFIRM order",
                  {"Screen": "orderReceived"});
              // Order Confirmation
              // Order Request (RECEIVED)
              // Part :
              // Buyer :
              // Pl check & CONFIRM order
            }
          } else {
            CustomBottomSheet.showSnackBar(context, response['message']);
          }
        } else {
          Get.to(() => NoInternetScreen());
        }
      } else {
        _partRequestController.errorMsg.value =
            'Please add some part in the table';
      }
    }
  }

  Widget _buildDiscountFilterSlider() {
    return Column(
      children: [
        const Text('Part filtered according to discount'),
        Row(
          children: [
            Expanded(
              child: Slider(
                activeColor: Colors.grey[300],
                inactiveColor: AppColor.primary,
                thumbColor: AppColor.primary,
                value: filteredSliderValue,
                min: 0.0,
                max: 0.99,
                divisions: 100,
                // label: '${(filteredSliderValue * 100).toInt()}%',
                onChanged: (val) {
                  setState(() {
                    filteredSliderValue = val;
                    // Filter the data where discount is greater than or equal to slider value
                    filteredPartAvailability = partAvailability.where((part) {
                      clearControllers();
                      return double.parse(part.discount) >=
                          (filteredSliderValue * 100).toInt();
                    }).toList();
                  });
                },
              ),
            ),
            // Text('Disc: ${(filteredSliderValue * 100).toInt()}%')
            Text('Disc Grater then: ${(filteredSliderValue * 100).toInt()}%')
          ],
        ),
      ],
    );
  }

  //PartNumber, PartDescription ,MRP
  Widget _buildCardTitle(String titleText) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          titleText,
          style:
              TextStyle(color: AppColor.primary, fontWeight: FontWeight.bold),
        ));
  }

  //Order Request submit on click(part Req>show availability>submit order
  // Future<bool> orderRequestSubmit(
  //     String brandID,
  //     String dealerID,
  //     String locationID,
  //     String userID,
  //     String orderFor,
  //     String lspCode,
  //     String tableVal
  //     ) async {
  //
  // }
}
