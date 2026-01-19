import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/widgets/head_bar.dart';
import 'package:gainer/dealer_monitoring/widgets/blink_btn.dart';
import 'package:get/get.dart';
import '../../../gainer/screens/bottombar_screen/part_request/part_request.dart';
import '../../../gainer/widget/error_msg.dart';
import '../../../gainer/widget/suggestion_list.dart';
import '../../controllers/part_stock_check_controller.dart';
import '../../core/utils/dm_images.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/legend_bar.dart';
import '../../widgets/part_stock_card.dart';
import '../../widgets/search_bar.dart';
import '../substitution_check/substitution_check_screen.dart';

class PartStockCheckScreen extends StatefulWidget {
  const PartStockCheckScreen({super.key});

  @override
  State<PartStockCheckScreen> createState() => _PartStockCheckScreenState();
}

class _PartStockCheckScreenState extends State<PartStockCheckScreen> {
  late PartStockCheckController _partStockCheckController;

  @override
  void initState() {
    super.initState();
    _partStockCheckController = Get.put(PartStockCheckController());
  }

  @override
  void dispose() {
    // Dispose the controller when this screen is closed
    Get.delete<PartStockCheckController>();
    super.dispose();
  }

  // int _currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadBar(
              text: "Part Stock Check",
              imgSting: DMImages.partStockCheck,
            ),
            _buildSearchBar(),
            _buildPartSuggestion(),
            LegendBar(),
            _buildPartCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SearchBarWidget(
        hintText: 'Enter Part Number',
        onSearch: _partStockCheckController.search,
        controller: _partStockCheckController.searchController,
        formKey: _partStockCheckController.formKey,
        onChanged: (value) =>
            _partStockCheckController.fetchPartSuggestions(value),
        // onChanged: (value) async {
        //   // final controller =
        //   //     _partStockCheckController.searchController;
        //   // if (value.isEmpty) {
        //   //   controller.clear();
        //   // }
        //   // // Convert to uppercase and update text
        //   // String upperText = value.toUpperCase();
        //   // controller.value = controller.value.copyWith(
        //   //   text: upperText,
        //   //   // selection: TextSelection.collapsed(offset: upperText.length),
        //   // );
        //   // // default async validation logic
        //   // String filteredValue =
        //   //     await ControllerUtils.partNumberValidation(value);
        //   // if (filteredValue != value) {
        //   //   controller.text = filteredValue;
        //   //   controller.selection = TextSelection.fromPosition(
        //   //     TextPosition(offset: filteredValue.length),
        //   //   );
        //   // }
        //   _partStockCheckController.fetchPartSuggestions(value);
        // },
      ),
    );
  }

  Widget _buildPartSuggestion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Obx(() {
        return SuggestionList(
          isLoading: _partStockCheckController.partSearchLoading.value,
          suggestions: _partStockCheckController.partSuggestions.toList(),
          onTap: (selected) =>
              _partStockCheckController.selectPartNumber(selected),
        );
      }),
    );
  }

  Widget _buildPartCard() {
    return Obx(() {
      if (_partStockCheckController.isLoading.value) {
        return CircularProgressIndicator();
      }
      if (_partStockCheckController.errorMessage.value != null ||
          _partStockCheckController.partDetails.isEmpty) {
        return CustomErrorMsg(
            text: _partStockCheckController.errorMessage.value ?? "");
      }
      //data observed
      final part = _partStockCheckController.partDetails;
      final color = _partStockCheckController.partStatus.value;
      final stockQty = _partStockCheckController.stock.value;
      final grpStock = _partStockCheckController.groupStock.value;
      final plannedLevel = _partStockCheckController.max.value;
      final reserveForVehicle =
          _partStockCheckController.reservedForVehicle.value;
      checkDoubleInt(double val) {
        return val % 1 == 0 //check for remainder 0
            ? val.toInt()
            : val.toStringAsFixed(2);
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PartStockCard(
              isGroupStock: true,
              partDetails: {
                "ColorType": color,
                "Part Number": part['partnumber1'] ?? "",
                "Part Description": part['partdesc'] ?? "",
                "Part Category": part['category'] ?? "",
                // "Part Rate": part['mrp'] ?? 0,
                "Stock Qty": checkDoubleInt(stockQty),
                "Planned Level": checkDoubleInt(plannedLevel),
                "Reserved for Vehicle": checkDoubleInt(reserveForVehicle),
                "Group Stock": checkDoubleInt(grpStock),
              },
              locations: _partStockCheckController.locationsList,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                // if (_partStockCheckController.isSubstitute.value)
                //   ReusableElevatedButton(
                //     //   onPressed: () {
                //     //     // _partStockCheckController.fromPartStock.value = true;
                //     //     _dMMainController.openScreen(4);
                //     //   },
                //     onPressed: () {
                //       Get.to(
                //           () => Scaffold(
                //                 appBar: AppBar(
                //                   title: Text("Substitution Check"),
                //                 ),
                //                 // body:  SafeArea(child: GainerStockCheck())));
                //                 // body:  SafeArea(child: PartRequestBody())));
                //                 // body: SafeArea(child: SubstitutionBody(),),
                //                 body: SafeArea(
                //                   child: SubstitutionCheckScreen(),
                //                 ),
                //               ),
                //           arguments: {
                //             "partNumber": _partStockCheckController
                //                 .searchController.text,
                //           });
                //     },
                //     text: "Show Substitution Part Details",
                //   ),
                BlinkingButton(
                  onPressed: () {
                    Get.to(
                      () => Scaffold(
                        appBar: AppBar(
                          title: Text("Substitution Check"),
                        ),
                        body: SafeArea(
                          child: SubstitutionCheckScreen(),
                        ),
                      ),
                      arguments: {
                        "partNumber":
                            _partStockCheckController.searchController.text,
                      },
                    );
                  },
                  text: "Check Substitution",
                  isBlink: _partStockCheckController.isSubstitute.value,
                ),
                SizedBox(height: 5),
                ReusableElevatedButton(
                  onPressed: () {
                    // Get.to(()=>SafeArea(child: (GainerStockCheck())));
                    Get.to(
                        () => Scaffold(
                              appBar: AppBar(title: Text("Gainer Stock Check")),
                              body: SafeArea(child: PartRequestScreen()),
                            ),
                        arguments: {
                          "partNumber":
                              _partStockCheckController.searchController.text,
                        });
                    // _partRequestController.partStockPartNum.value =
                    //     _partStockCheckController
                    //         .searchController.text;
                    // _dMMainController.openScreen(3);
                  },
                  text: "Show Gainer Stock Details",
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
