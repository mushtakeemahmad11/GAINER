import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../main.dart';
import '../../../controllers/seller_controller/manifestation_controller.dart';
import '../../../model/seller_model/manifestation.dart';
import '../../../widget/bottomsheet_for_picture.dart';
import '../../../widget/circular_progress_indicator.dart';
import '../../../widget/dialog.dart';
import '../../../widget/reusable_checkbox.dart';
import '../../../widget/reusable_widget.dart';
import '../../colors.dart';
import 'manifestation_summary_screen.dart';

class ManifestationScreen extends StatefulWidget {
  const ManifestationScreen({super.key});

  @override
  State<ManifestationScreen> createState() => _ManifestationScreenState();
}

class _ManifestationScreenState extends State<ManifestationScreen> {
  final ManifestationController _manifestationController =
      Get.put(ManifestationController());
  // final LocationController _locationController = Get.put(LocationController());
  bool isFiltered = false;
  bool isSearchable = false;
  bool allSwitch = false;
  final TextEditingController _searchbarController = TextEditingController();

  late List<ManifestationModel> manifestation;
  late List<ManifestationModel> filteredManifestation;

  // // Map to track the switch state for each partNumber
  // Map<String, bool> switchStates = {};
  // for store table val use at time of hit api
  // List<Map<String, dynamic>> poTableVal = [];

  // for switch button
  Map<String, String> locationMap = {};
  // Map to track the switch state for each partNumber
  Map<String, bool> switchStates = {};
  // Map<int, bool> switchStates = {}; // Track switch states
  //for remarks
  Map<String, bool> onTapInkWell = {};
  int? activeLocationID; // Store active location ID
  String currentLocation = '';
  void _toggleSwitch(String orderID, String location) {
    setState(() {
      bool isCurrentlyOn = switchStates[orderID] ?? false;

      if (!isCurrentlyOn) {
        // If switching ON
        if (activeLocationID == null || activeLocationID == location.hashCode) {
          switchStates[orderID] = true;
          activeLocationID = location.hashCode;
          currentLocation = location;
        } else {
          CustomBottomSheet.showSnackBar(context,
              "You can't select different Dealer location\nYou already selected Location: $currentLocation");
        }
      } else {
        // If switching OFF
        switchStates[orderID] = false;

        // Check if any switch is still ON
        if (!switchStates.values.contains(true)) {
          activeLocationID = null; // Reset location tracking
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    manifestation = _manifestationController.manifestationList;
    filteredManifestation = List.from(manifestation);

    for (var order in manifestation) {
      onTapInkWell[order.bigId.toString()] = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      filteredManifestation = List.from(manifestation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manifestation'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .03, vertical: mq.height * .01),
            child: Column(
              children: [
                // _buildViewSelectionRow(),
                // SizedBox(height: mq.height * .02),
                // _buildOrderFilterRow(),
                if (true) _buildSearchBar(),
                SizedBox(height: mq.height * .01),
                // if (true) _buildFilterSlider(),
                // SizedBox(height: mq.height * .01),
                if (_manifestationController.errorMsg.value != null)
                  Obx(() =>
                      Text(_manifestationController.errorMsg.value.toString())),
                Expanded(child: _buildOrderList())
              ],
            ),
          ),
          Obx(() => _manifestationController.isLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink()),
        ],
      ),
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
  Widget _buildSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: CustomTextFormField(
            controller: _searchbarController,
            text: 'Search by seller name/location',
            suffixIcon: IconButton(
                onPressed: () {
                  _searchbarController.clear();
                  setState(() {
                    filteredManifestation = List.from(manifestation);
                  });
                },
                icon: Icon(
                  Icons.clear,
                  color: AppColor.primary,
                )),
            onChanged: (val) {
              setState(() {
                // Filter orders by part number
                String filteredValue =
                    val.replaceAll(RegExp(r'[^a-zA-Z0-9 \-|/]'), '');
                // Prevent starting with space or dash
                // while (filteredValue.startsWith(RegExp(r'[ \-]'))) {
                //   filteredValue = filteredValue.substring(1);
                // }
                if (val != filteredValue) {
                  _searchbarController.text = filteredValue;
                }
                if (val.isEmpty) {
                  // If search text is empty, display all orders.
                  filteredManifestation = List.from(manifestation);
                } else {
                  filteredManifestation = manifestation.where((order) {
                    final searchText = _searchbarController.text.toLowerCase();

                    return order.buyerDealer!
                            .toLowerCase()
                            .contains(searchText) ||
                        order.buyerLocation!.toLowerCase().contains(searchText);
                  }).toList();
                }
              });
            },
          ),
        ),
        // SizedBox(
        //   width: mq.width * .01,
        // ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Switch(
        //         value: allSwitch,
        //         onChanged: (val) {
        //             setState(() {
        //               allSwitch = val; // Update the master switch state
        //
        //               // Update all switchStates values to the current val (true or false)
        //               switchStates.updateAll((key, value) => val);
        //
        //               // Optional: If you're mapping filteredManifestation items, update their states as well
        //               for (var order in filteredManifestation) {
        //                 switchStates[order.bigId.toString()] = val;
        //               }
        //
        //             });
        //         } // Set true for all keys
        //     ),
        //     const Text('For All'),
        //   ],
        // )
      ],
    );
  }

  Widget _buildOrderList() {
    // Group orders by buyerLocation
    Map<String, List<ManifestationModel>> groupedOrders = {};
    for (var order in filteredManifestation) {
      if (!groupedOrders.containsKey(order.buyerLocation)) {
        groupedOrders[order.buyerLocation!] = [];
      }
      groupedOrders[order.buyerLocation]!.add(order);

      // qtyControllers[filteredPoUpdation.indexOf(order)].text =
      //     order.dispatchQty.toString();

      // qtyControllers[filteredPoUpdation.indexOf(order)].text =
      // order.sellerFreeStock < order.dispatchQty
      //     ? order.sellerFreeStock.toInt().toString()
      //     : order.dispatchQty.toInt().toString();
    }

    if (filteredManifestation.isNotEmpty) {
      for (int i = 0; i < filteredManifestation.length; i++) {
        locationMap[filteredManifestation[i].bigId.toString()] =
            filteredManifestation[i].buyerLocation.toString();
      }
      return ListView(
        children: groupedOrders.entries.map((entry) {
          // final location = entry.key;
          final orders = entry.value;
          return _buildGroupedExpansionTile(orders);
        }).toList(),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildGroupedExpansionTile(List<ManifestationModel> orders) {
    int totalPay = 0;

    DateTime minDate = orders.map((order) {
      // Remove extra spaces to normalize the date
      String? cleanedDate =
          order.sellerResponseDate?.replaceAll(RegExp(r'\s+'), ' ').trim();
      totalPay = totalPay + order.partValue!.floor();
      // Parse date correctly
      return DateFormat("MMM d yyyy h:mma").parse(cleanedDate!);
    }).reduce((a, b) => a.isAfter(b) ? b : a); // Find min date

    // Format the min date for display
    String formattedDate = DateFormat("MMM dd yyyy").format(minDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // _buildRowText(formattedDate, .25),
                SizedBox(
                  width: mq.width * .25,
                  child: _buildExpansionTitle(formattedDate),
                ),
                SizedBox(
                  width: mq.width * .3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildExpansionTitle(orders.first.buyerDealer ?? ""),
                      _buildExpansionTitle(orders.first.buyerLocation ?? ''),
                    ],
                  ),
                ),
                SizedBox(
                  width: mq.width * .15,
                  child: _buildExpansionTitle('₹ $totalPay'),
                ),
              ],
            ),
          ],
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

  //Date,DealerName/Location,partCount
  Widget _buildExpansionTitle(String titleText) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        titleText,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColor.primary,
        ),
      ),
    );
  }

  Widget _buildOrderDetails(ManifestationModel order) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              _buildDetailColumn(
                order.oemCode ?? '',
                '${order.partNumber}',
                .3,
              ),
              _buildDetailColumn(
                'PO: ${order.poNumber}',
                order.partDesc ?? '',
                .35,
              ),
              _buildDetailColumn(
                'Qty: ${order.poQty}',
                '₹ ${order.mrp?.toInt()}',
                .2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _showPartDetails(order),
              CustomCheckBox(
                value: switchStates[order.bigId.toString()] ?? false,
                onChanged: (_) => _toggleSwitch(
                  order.bigId.toString(),
                  order.buyerLocation.toString(),
                ),
              ),
              // _buildToggleBtn(order),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String text1, String text2, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildRowText(text1, width), _buildRowText(text2, width)],
    );
  }

  // // Widget _buildOrderDetailsRow(ManifestationModel order) {
  // Widget _buildOrderDetailsRow(String text1, String text2, String text3) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     spacing: 10,
  //     children: [
  //       _buildRowText(text1, .3),
  //       _buildRowText(text2, .32),
  //       _buildRowText(text3, .2),
  //     ],
  //   );
  // }

  Widget _buildRowText(String text, double width) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: mq.width * width, // 👈 set your desired maximum width here
        minWidth: 0, // 👈 will shrink to fit the content
      ),
      child: IntrinsicWidth(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(text),
        ),
      ),
    );
  }

  Widget _showPartDetails(ManifestationModel order) {
    // for buyer latest remarks
    String? latestBuyerRemarks =
        (order.responseConfirmRemarks?.isNotEmpty ?? false)
            ? order.responseConfirmRemarks
            : (order.furtherDetailsRemarks?.isNotEmpty ?? false)
                ? order.furtherDetailsRemarks
                : order.remarks;

    // bool isLatestRemarks = order.furtherDetailsRemarks?.isNotEmpty ?? false;
    bool isLatestRemarks = (order.responseConfirmRemarks?.isNotEmpty ?? false)
        ? true
        : (order.furtherDetailsRemarks?.isNotEmpty ?? false)
            ? true
            : false;

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
                Text(
                  'Offer : ₹ ${order.price?.toInt()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // Text('Avl Qty : ${order.sellerFreeStock?.toInt()}'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Disc: ${order.discount?.toInt()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                // Text('Req Qty: ${order.qty?.toInt()}'),
              ],
            ),
          ],
        ),
        isLatestRemarks
            ? InkWell(
                onTap: () {
                  AppDialog.getRemarksPopUp("Buyer Remarks", [
                    _buildExpansionTitle("• Request Remarks"),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(order.remarks??""),
                    ),
                    SizedBox(height: 8),
                    _buildExpansionTitle("• Further Request Remark"),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(order.furtherDetailsRemarks??""),
                    ),
                    SizedBox(height: 8),
                    _buildExpansionTitle("• PO Confirmation"),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(order.responseConfirmRemarks??""),
                    ),
                  ]);
                  setState(() {
                    // Toggle the value for the corresponding order ID
                    onTapInkWell[order.bigId.toString()] =
                        !(onTapInkWell[order.bigId.toString()] ?? false);
                  });
                },
                child: _buildRemarksRow(
                    "Buyer Remarks : ", latestBuyerRemarks??"",
                    isInkWell: true),
              )
            : _buildRemarksRow("Buyer Remarks : ", latestBuyerRemarks??""),

        // _buildRemarksRow('Buyer : ', '${order.responseConfirmRemarks}'),
        _buildRemarksRow('Seller : ', order.requestAcceptRemarks??""),

        // Row(
        //   children: [
        //     const Text('Buyer : '),
        //     SizedBox(
        //         width: 150,
        //         child: _buildRemarksText('${order.responseConfirmRemarks}'))
        //   ],
        // ),
        // Row(
        //   children: [
        //     const Text('Seller : '),
        //     SizedBox(
        //         width: 150,
        //         child: _buildRemarksText('${order.requestAcceptRemarks}'))
        //   ],
        // ),
        // Text('Seller : ${order.requestAcceptRemarks}'),
      ],
    );
  }

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
  _onClickSummaryBtn() {
    List toggleValue = switchStates.entries
        .where((entry) => entry.value == true) // Filter only true values
        .map((entry) => entry.key) // Extract keys
        .toList();

    //for store stable data in map
    List<Map<String, dynamic>> orderData = [];
    _manifestationController.manifestationBigIdClear();
    for (var i = 0; i < filteredManifestation.length; i++) {
      for (var j = 0; j < toggleValue.length; j++) {
        if (toggleValue[j] == filteredManifestation[i].bigId.toString() &&
            filteredManifestation[i].poQty != 0) {
          _manifestationController.manifestationBuyerLocationID.value =
              filteredManifestation[i].buyerLocationId.toString();
          String? sellerClusters =
              filteredManifestation[i].sellerClusters.toString();
          String? buyerClusters =
              filteredManifestation[i].buyerClusters.toString();
          _manifestationController.manifestationIsWeFast.value =
              checkIsWeFast(sellerClusters, buyerClusters);

          //BigID for hit API Manifestation
          _manifestationController.manifestationBigId
              .add(filteredManifestation[i].bigId.toString());

          //add data for summary table
          orderData.add({
            "PartNo": filteredManifestation[i].partNumber,
            "Desc": filteredManifestation[i].partDesc,
            "PoNum": filteredManifestation[i].poNumber,
            "Buyer":
                '${filteredManifestation[i].buyerDealer}\n${filteredManifestation[i].buyerLocation}',
            "Qty": filteredManifestation[i].poQty.toString(),
            "Value": filteredManifestation[i].price! *
                filteredManifestation[i].poQty!,
          });
        }
      }
    }

    if (toggleValue.isNotEmpty) {
      // _getTableValue(); // for update poTableVal
      Get.to(() => const ManifestationSummaryScreen(), arguments: {
        // "poTableVal": poTableVal,
        "orderData": orderData,
      })?.then((_) {
        FocusScope.of(context).unfocus();
        // _refreshPage();
      });
    } else {
      CustomBottomSheet.showSnackBar(
          context, 'Please select at least one part');
    }
  }

  // check is we fast or not
  bool checkIsWeFast(String sellerClusters, String buyerClusters) {
    // Convert strings to sets of values
    Set<String> set1 = sellerClusters.split(',').toSet();
    Set<String> set2 = buyerClusters.split(',').toSet();

    // Find intersection (common values)
    Set<String> commonValues = set1.intersection(set2);
    return commonValues.isNotEmpty ? true : false;
  }
}
