import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../apis_functionality/api_service.dart';
import '../../../controllers/buyer_controller/part_receipt_controller.dart';
import '../../../controllers/check_internet/no_internet_screen.dart';
import '../../../model/buyer_model/part_receipt_model.dart';
import '../../../shared_preferences/shared_preferences_get_data.dart';
import '../../../url_launch/url_launch.dart';
import '../../../utility/controller_utils.dart';
import '../../../widget/bottomsheet_for_picture.dart';
import '../../../widget/circular_progress_indicator.dart';
import '../../../widget/dialog.dart';
import '../../../widget/reusable_elevated_button.dart';
import '../../../widget/reusable_widget.dart';
import '../../../widget/reusable_widget_po_pr.dart';
import '../../check_internet/check_internet_connectivity.dart';
import '../../colors.dart';
import '../../constant_image_path.dart';
import 'issue_screen.dart';

class PartReceiptScreen extends StatefulWidget {
  const PartReceiptScreen({super.key});

  @override
  State<PartReceiptScreen> createState() => _PartReceiptScreenState();
}

class _PartReceiptScreenState extends State<PartReceiptScreen> {
  final PartReceiptController _partReceiptController =
      Get.put(PartReceiptController());
  // The full list of orders from the controller
  late List<PartReceiptModel> _partReceipt;
  // The filtered list shown on the UI
  late List<PartReceiptModel> _filteredPartReceipt;

  bool _isSearchable = false;
  bool _isFiltered = false;
  final TextEditingController _searchbarController = TextEditingController();
  double _filteredSliderValue = 0.0;
  bool resetExpansionState = false;

  @override
  void initState() {
    super.initState();
    _initWork();
  }

  _initWork() {
    setState(() {
      _partReceipt = _partReceiptController.partReceiptList;
      // Initially, display all orders.
      _filteredPartReceipt = List.from(_partReceipt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Part Receipt'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .03, vertical: mq.height * .02),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customOderContainer('Vehicle Orders', Colors.red[100]!),
                    customOderContainer('Stock Order', Colors.green[100]!),
                    _buildSearchAndFilterButtons(),
                  ],
                ),
                if (_isSearchable)
                  CustomTextFormField(
                    controller: _searchbarController,
                    text: 'Search by part number',
                    suffixIcon: IconButton(
                        onPressed: () {
                          _searchbarController.clear();
                          setState(() {
                            _filteredPartReceipt = List.from(_partReceipt);
                          });
                        },
                        icon: Icon(
                          Icons.clear,
                          color: AppColor.primary,
                        )),
                    onChanged: (val) async {
                      String filteredValue =
                          await ControllerUtils.partNumberValidation(val);
                      if (val != filteredValue) {
                        _searchbarController.text = filteredValue.toUpperCase();
                      } else {
                        _searchbarController.text =
                            _searchbarController.text.toUpperCase();
                      }

                      setState(() {
                        if (filteredValue.isEmpty) {
                          // If search text is empty, display all orders.
                          _filteredPartReceipt = List.from(_partReceipt);
                        } else {
                          // Filter orders by part number (case-insensitive)
                          _filteredPartReceipt = _partReceipt.where((order) {
                            return order.partnumber
                                .toLowerCase()
                                .contains(filteredValue.toLowerCase());
                          }).toList();
                        }
                      });
                    },
                  ),
                SizedBox(height: mq.height * .02),
                if (_isFiltered)
                  Column(
                    children: [
                      Text(
                          'Filter the order according to discount : ${(_filteredSliderValue * 100).toInt()}%'),
                      Slider(
                        activeColor: Colors.grey[300],
                        inactiveColor: AppColor.primary,
                        thumbColor: AppColor.primary,
                        value: _filteredSliderValue,
                        min: 0.0,
                        max: 0.99,
                        divisions: 100,
                        // label: '${(_filteredSliderValue * 100).toInt()}%',
                        onChanged: (val) {
                          setState(() {
                            _filteredSliderValue = val;
                          });
                        },
                        onChangeEnd: (val) {
                          setState(() => _filteredSliderValue = val);
                          _filteredPartReceipt = _partReceipt.where((part) {
                            return part.discount >=
                                (_filteredSliderValue * 100).toInt();
                          }).toList();
                        },
                      ),
                    ],
                  ),
                if (_partReceiptController.errorMsg.value != null)
                  Obx(() =>
                      Text(_partReceiptController.errorMsg.value.toString())),
                SizedBox(height: mq.height * .01),
                _partReceiptController.isLoading.value
                    ? SizedBox.shrink()
                    : Flexible(
                        child: ListView.builder(
                          // padding: const EdgeInsets.all(8.0),
                          itemCount: _filteredPartReceipt.length,
                          itemBuilder: (context, index) {
                            final item = _filteredPartReceipt[index];
                            return buildExpansionTile(item, index);
                          },
                        ),
                      ),
              ],
            ),
          ),
          Obx(() => _partReceiptController.isLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink())
        ],
      ),
    );
  }

  Widget buildExpansionTile(PartReceiptModel item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        key: ValueKey(item.bigid),
        tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        title: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: mq.width * .3,
              child: _buildExpansionTitle(item.partnumber),
            ),
            Expanded(child: _buildExpansionTitle(item.partdesc)),
            _buildExpansionTitle('PO Qty ${item.poQty}')
          ],
        ),
        backgroundColor: AppColor.primaryShade,
        collapsedBackgroundColor: AppColor.primaryShade,
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildExpansionDetails(item),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          // color: Colors.black12,
                          color: item.orderfor == "Vehicle"
                              ? Colors.red[100]
                              : Colors.green[100],
                          borderRadius: BorderRadius.circular(6)),
                      // padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                AppDialog.invoiceDownloadPopUp(context, item.invoiceCopy),
                            icon: const Icon(
                              Icons.receipt_long,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            color: Colors.black,
                            width: 1,
                            height: 45,
                          ),
                          IconButton(
                            onPressed: () {
                              AppDialog.dialogForYesNo('Do you want to track order',
                                  AppImages.decisionMaking, () {
                                Get.back();
                                trackOrder(item.lrNumber, item.companyCode,
                                    item.bufferAction);
                              }, () => Get.back());
                            },
                            icon: const Icon(
                              Icons.auto_graph,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: mq.height * .01,
                // ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: CustomElevatedButton(
                      text: 'Good',
                      onTap: () {
                        _onTapGood(item.bigid);
                        // AppDialog.midPopUp(Constants.check, 'Order Accepted');
                      },
                    )),
                    SizedBox(
                      width: mq.width * .02,
                    ),
                    Expanded(
                        child: CustomElevatedButton(
                            text: 'Issue',
                            onTap: () {
                              Get.to(() => const IssueScreen(),
                                      arguments: {"bigId": item.bigid})
                                  ?.then((_) async {
                                bool checkInt = await checkInternet();
                                if (checkInt) {
                                  FocusScope.of(context).unfocus();
                                  String locationID =
                                      await getStringData('selectedLocationID');
                                  _partReceiptController.isLoading.value = true;
                                  await _partReceiptController
                                      .partReceiptAsBuyer(
                                          locationID, 'DISPATCHED');
                                  _initWork();
                                  _partReceiptController.isLoading.value =
                                      false;
                                  // setState(() {});
                                } else {
                                  Get.to(() => NoInternetScreen());
                                }
                              });
                            })),
                  ],
                ),
                SizedBox(
                  height: mq.height * .005,
                )
              ],
            ),
          ),
        ],
      ),
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
              onPressed: () => setState(() => _isSearchable = !_isSearchable),
              icon: Icon(Icons.search, color: AppColor.primary),
            ),
            SizedBox(width: mq.width * .005),
            IconButton(
              onPressed: () => setState(() => _isFiltered = !_isFiltered),
              icon: Icon(Icons.filter_alt, color: AppColor.primary),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildExpansionDetails(PartReceiptModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDtlRow('Dealer Name : ', item.dealerName),
        buildDtlRow('Location : ', item.sellerlocation),
        buildDtlRow('Discount : ', '${item.discount.toInt()}%'),
        buildDtlRow('LR No. : ', item.lrNumber),
        buildDtlRow('LSP : ', item.companyName),
        buildDtlRow('Delivery Date : ', item.deliverDate.toString()),
        buildDtlRow('Delivery Status : ', item.deliverStatus),
      ],
    );
  }

  void _onTapGood(int bigId) {
    List<File> selectedImages = [];
    AppDialog.dialogForYesNo('Are you sure to to receive order', AppImages.decisionMaking,
        () async {
      Get.back();
      String remarks = '';
      String actionType = "RECEIVED";
      _partReceiptController.isLoading.value = true;

      bool checkInt = await checkInternet();
      if (checkInt) {
        final response = await ApiService().pendingToBeReceived(
            remarks: remarks,
            actionType: actionType,
            bigID: bigId.toString(),
            imageFiles: selectedImages);
        _partReceiptController.isLoading.value = false;
        if (response['success'] == true) {
          AppDialog.midPopUp(AppImages.check, '${response['data']}');
          bool checkInt = await checkInternet();
          if (checkInt) {
            FocusScope.of(context).unfocus();
            String locationID = await getStringData('selectedLocationID');
            await _partReceiptController.partReceiptAsBuyer(
                locationID, 'DISPATCHED');
            _initWork();
          } else {
            Get.to(() => NoInternetScreen());
          }
        } else {
          CustomBottomSheet.showSnackBar(context, '${response['message']}');
        }
      } else {
        Get.to(() => NoInternetScreen());
      }
    }, () {
      Get.back();
    });
  }

  Future<void> trackOrder(
      String lrNo, int companyCode, String bufferAction) async {
    if (companyCode == 1) {
      bufferAction == "Invalid"
          ? await launchURL('https://www.shiprocket.in/shipment-tracking/')
          : await launchURL('https://www.delhivery.com/track/lr/$lrNo');
    } else if (companyCode == 2) {
      bufferAction == "Invalid"
          ? await launchURL('https://www.shiprocket.in/shipment-tracking/')
          : await launchURL('https://www.delhivery.com/track/package/$lrNo');
    } else if (companyCode == 4) {
      await launchURL(lrNo);
    } else if (companyCode == 5) {
      copyToClipboard(lrNo);
      await launchURL('https://www.bluedart.com/web/guest/home');
    } else {
      CustomBottomSheet.showSnackBar(
          context, 'This LR number can not be track');
    }
  }

  void copyToClipboard(String lrNo) async {
    // Copy the text to the clipboard
    await Clipboard.setData(ClipboardData(text: lrNo));
  }
}
