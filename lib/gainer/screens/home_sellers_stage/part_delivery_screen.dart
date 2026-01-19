import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../apis_functionality/api_service.dart';
import '../../controllers/check_internet/no_internet_screen.dart';
import '../../controllers/seller_controller/part_delivery_controller.dart';
import '../../model/seller_model/part_delivery_model.dart';
import '../../url_launch/url_launch.dart';
import '../../utility/controller_utils.dart';
import '../../widget/bottomsheet_for_picture.dart';
import '../../widget/circular_progress_indicator.dart';
import '../../widget/dialog.dart';
import '../../widget/reusable_elevated_button.dart';
import '../../widget/reusable_widget.dart';
import '../check_internet/check_internet_connectivity.dart';
import '../colors.dart';
import '../constant_image_path.dart';

class PartDeliveryScreen extends StatefulWidget {
  const PartDeliveryScreen({super.key});

  @override
  State<PartDeliveryScreen> createState() => _PartDeliveryScreenState();
}

class _PartDeliveryScreenState extends State<PartDeliveryScreen> {
  final PartDeliveryController _partDeliveryController =
      Get.put(PartDeliveryController());
  List<PartDeliveryModel> _partDeliveryList = [];
  List<PartDeliveryModel> _filteredPartDeliveryList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _partDeliveryList = _partDeliveryController.partDeliveryList;
    _filteredPartDeliveryList = List.from(_partDeliveryList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Part Delivery'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .02),
            child: Column(
              children: [
                // Text(_filteredDispatchDetailsList[0].dispatchOrderNo),
                _buildSearchField(),
                _partDeliveryController.errorMsg.value != null
                    ? Obx(() => Text(
                          _partDeliveryController.errorMsg.value ?? '',
                          style: TextStyle(color: Colors.black),
                        ))
                    : const SizedBox.shrink(),
                SizedBox(height: mq.height * .02),
                Flexible(child: _buildExpansionTile())
              ],
            ),
          ),
          Obx(() => _partDeliveryController.isLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return CustomTextFormField(
      controller: _searchController,
      text: 'Search by Part Number',
      suffixIcon: IconButton(
          onPressed: () {
            _searchController.clear();
            setState(() {
              _filteredPartDeliveryList = List.from(_partDeliveryList);
            });
          },
          icon: Icon(
            Icons.clear,
            color: AppColor.primary,
          )),
      onChanged: (val) async {
        // Remove any non-numeric characters
        // String filteredValue = val.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
        // searchByPartsController.text = filteredValue.toUpperCase().trim();

        String filteredValue = await ControllerUtils.partNumberValidation(val);
        if (val != filteredValue) {
          _searchController.text = filteredValue.toUpperCase();
        } else {
          _searchController.text = _searchController.text.toUpperCase();
        }
        setState(() {
          if (filteredValue.isEmpty) {
            // If search text is empty, display all orders.
            _filteredPartDeliveryList = List.from(_partDeliveryList);
          } else {
            // Filter orders by part number (case-insensitive)
            _filteredPartDeliveryList = _partDeliveryList.where((order) {
              return order.partNumber
                  .toLowerCase()
                  .contains(filteredValue.toLowerCase());
            }).toList();
          }
        });
      },
    );
  }

  Widget _buildExpansionTile() {
    return _filteredPartDeliveryList.isNotEmpty
        ? ListView.builder(
            itemCount: _filteredPartDeliveryList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = _filteredPartDeliveryList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  title: _buildTitle(item),
                  backgroundColor: AppColor.primaryShade,
                  collapsedBackgroundColor: AppColor.primaryShade,
                  collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                  // children: orders.map((order) => _buildOrderDetails(order)).toList(),
                  children: [
                    _buildOrderDetails(item),
                  ],
                ),
              );
            })
        : SizedBox.shrink();
  }

  Widget _buildTitle(PartDeliveryModel item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildExpansionTitle(item.partNumber),
        SizedBox(
          width: mq.width * .3,
          child: _buildExpansionTitle(item.partdesc),
        ),
        _buildExpansionTitle('₹ ${item.mrp.toInt()}'),
      ],
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

  // build ExpansionTile details
  Widget _buildOrderDetails(PartDeliveryModel order) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailsRow('Buyer : ', order.buyerDealer),
          _buildDetailsRow('Buyer Location: ', order.buyerLocation),
          _buildDetailsRow('offer/Discount : ',
              '₹ ${order.price}/${order.discount.toInt()}%'),
          // _buildDetailsRow('Discount : ', ' ${order.discount.toInt()}%'),
          _buildDetailsRow(
              'PO No./QTY : ', ' ${order.poNumber}/${order.dispatchQty}'),
          _buildDetailsRow('LSP : ', ' ${order.lspStatus}'),
          _buildDetailsRow('LR No. : ', ' ${order.lrNumber}'),
          _buildDetailsRow('LR Date : ', ' ${order.lrDate}'),
          _buildDetailsRow('Invoice No. : ', ' ${order.invoiceNumber}'),
          SizedBox(height: mq.height * .01),
          _buildBtnRow(order),
        ],
      ),
    );
  }

  // building row for LSP/LR No.
  Widget _buildDetailsRow(String text1, String text2) {
    return Row(
      children: [
        Text(
          text1,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: Text(text2))),
      ],
    );
  }

  Widget _buildBtnRow(PartDeliveryModel order) {
    return Row(
      spacing: 50,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomElevatedButton(
            onTap: () =>
                AppDialog.invoiceDownloadPopUp(context, order.invoiceCopy),
            icon: Icons.receipt,
          ),
        ),
        Expanded(
          child: CustomElevatedButton(
            onTap: () {
              AppDialog.dialogForYesNo(
                  'Do you want to track order', AppImages.decisionMaking, () {
                Get.back();
                trackOrder(
                    order.lrNumber, order.companyCode, order.bufferAction);
              }, () => Get.back());
            },
            icon: Icons.auto_graph,
          ),
        ),
        Expanded(
          child: CustomElevatedButton(
            onTap: () {
              AppDialog.dialogForYesNo(
                  'Do you want to send reminder', AppImages.decisionMaking,
                  () async {
                Get.back();
                bool checkInt = await checkInternet();
                if (checkInt) {
                  _partDeliveryController.isLoading.value = true;
                  final response = await ApiService()
                      .pendingForDispatchReminder(
                          order.buyerLocationId.toString(),
                          order.bigId.toString());
                  _partDeliveryController.isLoading.value = false;
                  if (response['success']) {
                    // AppDialog.midPopUp(Constants.delete, _orderPlacedController.odrDltResMsg.value??"Part Request Deleted");
                    AppDialog.midPopUp(AppImages.check, response['data']);
                  } else {
                    // CustomBottomSheet.showSnackBar(context, _orderPlacedController.odrDltErrorMsg.value??"There is some Problem");
                    CustomBottomSheet.showSnackBar(
                        context, response['message']);
                  }
                  setState(() {});
                } else {
                  Get.to(() => NoInternetScreen());
                }
              }, () {
                Get.back();
              });
            },
            icon: Icons.watch_later_outlined,
          ),
        ),
      ],
    );
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
