import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../main.dart';
import '../../apis_functionality/api_service.dart';
import '../../controllers/home_screen_controller.dart';
import '../../controllers/pick_image_controller.dart';
import '../../controllers/seller_controller/dispatch_details_controller.dart';
import '../../model/seller_model/dispatch_details_controller.dart';
import '../../widget/bottomsheet_for_picture.dart';
import '../../widget/circular_progress_indicator.dart';
import '../../widget/dialog.dart';
import '../../widget/reusable_elevated_button.dart';
import '../../widget/reusable_widget.dart';
import '../colors.dart';
import '../constant_image_path.dart';

class DispatchDetailsScreen extends StatefulWidget {
  const DispatchDetailsScreen({super.key});

  @override
  State<DispatchDetailsScreen> createState() => _DispatchDetailsScreenState();
}

class _DispatchDetailsScreenState extends State<DispatchDetailsScreen> {
  final DispatchDetailsController _dispatchDetailsController =
      Get.put(DispatchDetailsController());
  LocationController locationController = Get.put(LocationController());
  List<DispatchDetailsModel> _dispatchDetailsList = [];
  List<DispatchDetailsModel> _filteredDispatchDetailsList = [];
  final TextEditingController _searchController = TextEditingController();

  final PickImageController _pickImageController =
      Get.put(PickImageController());
  Map<String, List<List<Object?>>> selectedImagesPerOrder1 = {};
  Map<String, List<List<Object?>>> selectedImagesPerOrder2 = {};

  //for checking box all img submit or not
  bool? isNullSelectedImagesPerOrder1 = false;
  bool? isNullSelectedImagesPerOrder2 = false;

  @override
  void initState() {
    super.initState();
    _initWork();
  }

  void _initWork() {
    setState(() {
      _dispatchDetailsList = _dispatchDetailsController.dispatchDetailsList;
      _filteredDispatchDetailsList = List.from(_dispatchDetailsList);
    });
  }

  // List<Map<String, dynamic>> getGroupedData() {
  List<Map<String, Object>> getGroupedData() {
    var groupedData = <String, List<DispatchDetailsModel>>{};

    for (var item in _filteredDispatchDetailsList) {
      String key = item.dispatchOrderNo;
      groupedData.putIfAbsent(key, () => []).add(item);
    }

    return groupedData.entries.map((e) {
      var combinedItem = e.value.first;
      return {'data': combinedItem, 'count': e.value.length};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispatch Details'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .02),
            child: Column(
              children: [
                _buildSearchField(),
                if (_dispatchDetailsController.errorMsg.value != null)
                  Obx(
                    () => Text(_dispatchDetailsController.errorMsg.value ?? ''),
                  ),
                SizedBox(height: mq.height * .02),
                Flexible(child: _buildExpansionTile())
              ],
            ),
          ),
          Obx(() => _dispatchDetailsController.isLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return CustomTextFormField(
      controller: _searchController,
      text: 'Search by Buyer Name/Location',
      suffixIcon: IconButton(
          onPressed: () {
            _searchController.clear();
            setState(() {
              _filteredDispatchDetailsList = List.from(_dispatchDetailsList);
            });
          },
          icon: Icon(
            Icons.clear,
            color: AppColor.primary,
          )),
      onChanged: (val) {
        // Remove any non-numeric characters
        String filteredValue = val.replaceAll(RegExp(r'[^a-zA-Z0-9 \-|/]'), '');
        if (val != filteredValue) {
          _searchController.text = filteredValue;
        }
        setState(() {
          if (filteredValue.isEmpty) {
            // If search text is empty, display all orders.
            _filteredDispatchDetailsList = List.from(_dispatchDetailsList);
          } else {
            // Filter orders by part number (case-insensitive)
            _filteredDispatchDetailsList = _dispatchDetailsList.where((order) {
              return order.buyerLocation
                  .toLowerCase()
                  .contains(filteredValue.toLowerCase());
            }).toList();
          }
        });
      },
    );
  }

  Widget _buildExpansionTile() {
    return _filteredDispatchDetailsList.isNotEmpty
        ? ListView.builder(
            itemCount: getGroupedData().length,
            itemBuilder: (BuildContext context, int index) {
              var itemData = getGroupedData()[index];
              var data = itemData['data'] as DispatchDetailsModel;
              var count = itemData['count'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  title: _buildTitle(data),
                  backgroundColor: AppColor.primaryShade,
                  collapsedBackgroundColor: AppColor.primaryShade,
                  collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                  children: [
                    _buildOrderDetails(data, count),
                  ],
                ),
              );
            })
        : SizedBox.shrink();
  }

  Widget _buildTitle(DispatchDetailsModel item) {
    String brandLocation = item.buyerLocation;
    //for break line between brand and location
    brandLocation = brandLocation.replaceAll('<br/>', '\n');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildExpansionTitle(item.lrDate),
        SizedBox(
          width: mq.width * .3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildExpansionTitle(brandLocation),
            ],
          ),
        ),
        _buildExpansionTitle('₹ ${item.val.toInt()}'),
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
  Widget _buildOrderDetails(DispatchDetailsModel order, imgRowCount) {



    initializeImageStorage(order, imgRowCount);

    //update variable for Box all image if any null(true) or all uploaded(false)
    isNullSelectedImagesPerOrder1 =
        selectedImagesPerOrder1[order.dispatchOrderNo]
            ?.any((row) => row.any((element) => element == null));

    isNullSelectedImagesPerOrder2 =
        selectedImagesPerOrder2[order.dispatchOrderNo] == null ||
            selectedImagesPerOrder2[order.dispatchOrderNo]!.isEmpty ||
            selectedImagesPerOrder2[order.dispatchOrderNo]![0].isEmpty ||
            selectedImagesPerOrder2[order.dispatchOrderNo]![0][0] == null;


    // initializeImageStorage(order.dispatchOrderNo, 1);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailsRow('LSP : ', order.lsp),
          _buildDetailsRow('LR No : ', order.lrNumber),
          SizedBox(height: mq.height * .01),
          _buildPrimaryBoldText("Box Image"),
          SizedBox(height: mq.height * .005),
          ...List.generate(
              imgRowCount, (index) => _generateImgRow(order, index)),
          SizedBox(height: mq.height * .005),
          if (isNullSelectedImagesPerOrder1!=null && isNullSelectedImagesPerOrder1==false)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPrimaryBoldText("Pickup Proof Image"),
                _buildImg2Row(order),
              ],
            ),
          CustomElevatedButton(
            onTap: () => _onSubmit(order),
            text: "Submit",
          )
        ],
      ),
    );
  }

  _buildPrimaryBoldText(String text){
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColor.primary,
      ),
    );
  }

  // building row for LSP/LR No.
  Widget _buildDetailsRow(String text1, String text2) {
    return Row(
      children: [
        _boldText(text1),
        Text(text2),
      ],
    );
  }

  Widget _generateImgRow(DispatchDetailsModel order, int rowIndex) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (rowIndex == 0) _boldText("SN"),
              Text('${rowIndex + 1}'),
            ],
          ),
          _buildImgIcon("With pkg slip", order, rowIndex, 0, false),
          _buildImgIcon("3D image 1", order, rowIndex, 1, false),
          _buildImgIcon("3D image 2", order, rowIndex, 2, false),
        ]);
  }

  Widget _buildImg2Row(DispatchDetailsModel order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImgIcon('Signed packing slip', order, 0, 0, true),
        _buildImgIcon('Other details', order, 0, 1, true),
      ],
    );
  }

  void initializeImageStorage(DispatchDetailsModel order, int rowCount) {
    if (!selectedImagesPerOrder1.containsKey(order.dispatchOrderNo)) {
      selectedImagesPerOrder1[order.dispatchOrderNo] =
          List.generate(rowCount, (index) {
        return [order.withPkgSlipImg, order.img1, order.img2];
      });
    }

    if (!selectedImagesPerOrder2.containsKey(order.dispatchOrderNo)) {
      selectedImagesPerOrder2[order.dispatchOrderNo] = [
        [order.signedCopyPkgSlipImg, order.otherDetailImg]
      ];
    }
  }

  void setImage(String dispatchOrderNo, int rowIndex, int imageIndex,
      Object? image, bool isSigned) {
    final selectedImages =
        isSigned ? selectedImagesPerOrder2 : selectedImagesPerOrder1;
    selectedImages[dispatchOrderNo]?[rowIndex][imageIndex] = image;

  }

  Widget _buildImgIcon(String text, DispatchDetailsModel order, int rowIndex,
      int imageIndex, bool isSigned) {
    Object? image = isSigned
        ? (selectedImagesPerOrder2[order.dispatchOrderNo]?[rowIndex]
            [imageIndex])
        : (selectedImagesPerOrder1[order.dispatchOrderNo]?[rowIndex]
            [imageIndex]);

    String fileName = '';
    String? imgString;
    switch (text) {
      case 'With pkg slip':
        fileName = 'WithPkgSlipImg';
        imgString = order.withPkgSlipImg;
        break;

      case '3D image 1':
        fileName = 'Img1';
        imgString = order.img1;
        break;

      case '3D image 2':
        fileName = 'Img2';
        imgString = order.img2;
        break;

      case 'Signed packing slip':
        fileName = 'SignedCopyPkgSlipImg';
        imgString = order.signedCopyPkgSlipImg;
        break;

      case 'Other details':
        fileName = 'OtherDetailImg';
        imgString = order.otherDetailImg;
        break;
    }

    //if user select an image then not set API Image String in selectedImagesPerOrder
    if (image == null) {
      setImage(
          order.dispatchOrderNo, rowIndex, imageIndex, imgString, isSigned);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (rowIndex == 0) _boldText(text),
        Obx(() => IconButton(
              key: ValueKey(
                  '${order.dispatchOrderNo}_${rowIndex}_$imageIndex$isSigned'),
              onPressed: () {
                //for condition if image already selected then not open img selectDialog
                if (image != null || imgString != null) {
                  Get.defaultDialog(
                    title: text,
                    cancel: SizedBox(
                        width: mq.width * .25,
                        child: CustomElevatedButton(
                            onTap: () => Get.back(), text: 'Close')),
                    content: image is File
                        ? Image.file(
                            image,
                            // width: mq.width * .2,
                            // height: mq.width * .2,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            constraints: BoxConstraints(
                              minHeight: mq.height * .2, // Minimum height
                              maxHeight: mq.height * .7, // Maximum height
                              minWidth: mq.width * .9,
                              maxWidth: mq.width,
                            ),
                            child: Image.network(
                              'https://scope.sparecare.in/Upload/DispatchDetails/$image',
                              // width: mq.width,
                              // height: mq.height * .6,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child; // Display the image once loaded
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null, // Show indeterminate if null
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                  );

                  return;
                }

                CustomBottomSheet.show(
                  context: context,
                  onPressedCamera: () async {
                    Get.back();
                    //pick image from camera
                    File? pickedImage = await _pickImageController
                        .pickImage(ImageSource.camera);
                    if (pickedImage != null) {
                      // File selectedImages = File(pickedImage.path);
                      setState(() {}); // triggers spinner

                      //set unique key for progress indicator at the time of image upload
                      String uniqueKey =
                          '${order.dispatchOrderNo}_${rowIndex}_$imageIndex$isSigned';
                      _dispatchDetailsController.uploadingMap[uniqueKey] = true;
                      bool uploaded =
                          await _uploadImage(order, pickedImage, fileName);
                      _dispatchDetailsController.uploadingMap[uniqueKey] =
                          false;
                      if (uploaded) {
                        setState(() {
                          setImage(order.dispatchOrderNo, rowIndex, imageIndex,
                              pickedImage, isSigned);
                        });
                      }
                    }
                  },
                  onPressedGallery: () async {
                    Get.back();
                    //pick image from gallery
                    File? pickedImage = await _pickImageController
                        .pickImage(ImageSource.gallery);
                    if (pickedImage != null) {
                      //set unique key for progress indicator at the time of image upload
                      String uniqueKey =
                          '${order.dispatchOrderNo}_${rowIndex}_$imageIndex$isSigned';
                      _dispatchDetailsController.uploadingMap[uniqueKey] = true;
                      bool uploaded =
                          await _uploadImage(order, pickedImage, fileName);
                      _dispatchDetailsController.uploadingMap[uniqueKey] =
                          false;
                      if (uploaded) {
                        setState(() {
                          setImage(order.dispatchOrderNo, rowIndex, imageIndex,
                              pickedImage, isSigned);
                        });
                      }
                    }
                  },
                );
              },
              icon: _dispatchDetailsController.uploadingMap[
                          '${order.dispatchOrderNo}_${rowIndex}_$imageIndex$isSigned'] ==
                      true
                  ? const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    )
                  : image is File
                      ? Image.file(
                          image,
                          width: mq.width * .2,
                          height: mq.width * .2,
                          fit: BoxFit.cover,
                        )
                      : image is String
                          ? Image.network(
                              'https://scope.sparecare.in/Upload/DispatchDetails/$image',
                              width: mq.width * .2,
                              height: mq.width * .2,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child; // Display the image once loaded
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null, // Show indeterminate if null
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            )
                          : Icon(Icons.add_a_photo, color: AppColor.primary),
              // : true? CircularProgressIndicator():Icon(Icons.add_a_photo, color: AppColor.primary),
            )),
      ],
    );
  }

  Widget _boldText(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Future<bool> _uploadImage(
      DispatchDetailsModel order, File pickedImage, String fileName) async {
    File selectedImages = File(pickedImage.path);

    final response = await ApiService().dispatchDetailsImgUploadV2(
        dispatchOrderNo: order.dispatchOrderNo,
        lRNumber: order.lrNumber,
        tCode: order.tCode.toString(),
        fileName: fileName,
        imageFiles: selectedImages);

    if (response['success']) {
      CustomBottomSheet.showSnackBar(context, response['data']);
      return true;
    } else {
      CustomBottomSheet.showSnackBar(
          context, '${response['message']}\nPlease Upload Again');
      return false;
    }
  }

  void _onSubmit(DispatchDetailsModel order) async {
    String dispatchOrderNumber = order.dispatchOrderNo;
    String lrNumber = order.lrNumber;
    // check for Box Image image
    isNullSelectedImagesPerOrder1 =
        selectedImagesPerOrder1[dispatchOrderNumber]!
            .any((row) => row.any((element) => element == null));

    isNullSelectedImagesPerOrder2 =
        selectedImagesPerOrder2[dispatchOrderNumber] == null ||
            selectedImagesPerOrder2[dispatchOrderNumber]!.isEmpty ||
            selectedImagesPerOrder2[dispatchOrderNumber]![0].isEmpty ||
            selectedImagesPerOrder2[dispatchOrderNumber]![0][0] == null;


    // bool isSignedCopyUploaded = selectedImagesPerOrder2[order.dispatchOrderNo] != null &&
    //     selectedImagesPerOrder2[order.dispatchOrderNo]![0][0] != null;

    // _checkNullValue(dispatchOrderNumber);

    if (isNullSelectedImagesPerOrder1!) {
      CustomBottomSheet.showSnackBar(
          context, 'All image is required\nPlease upload all image');
    }
    else if(isNullSelectedImagesPerOrder2!){
      CustomBottomSheet.showSnackBar(context, "Signed Packing Slip Image is Required");
    }else {
      String brandId = locationController.stockDetails['BrandID'].toString();
      String dealerId = locationController.stockDetails['DealerID'].toString();
      String sellerLocationId =
          locationController.stockDetails['LocationID'].toString();

      AppDialog.dialogForYesNo(
          'Do you want to save Dispatch Details', AppImages.decisionMaking,
          () async {
        Get.back();
        _dispatchDetailsController.isLoading.value = true;
        final response = await ApiService()
            .dispatchDetailsSubmit(dispatchOrderNumber, lrNumber);
        _dispatchDetailsController.isLoading.value = false;

        if (response['success']) {
          await _dispatchDetailsController.dispatchDetailsAsSeller(
              brandId, dealerId, sellerLocationId);
          _initWork();
          AppDialog.midPopUp(AppImages.check, response['data']);
        } else {
          CustomBottomSheet.showSnackBar(context, response['message']);
        }
      }, () {
        Get.back();
      });
    }
  }
}
