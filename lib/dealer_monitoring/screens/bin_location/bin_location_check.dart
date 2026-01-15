import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';
import 'package:gainer/dealer_monitoring/widgets/search_bar.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../controllers/bin_location_controllers.dart';
import '../../core/utils/dm_images.dart';
import '../../widgets/head_bar.dart';

class BinLocationCheckScreen extends StatelessWidget {
  final BinLocationController _binLocationController =
      Get.put(BinLocationController());

  BinLocationCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // BlinkingButtonExample(shouldBlink: false), // or false
            HeadBar(
              text: "Bin Location Check",
              imgSting: DMImages.binLocation,
            ),

            // Container(
            //   color: DMAppColors.secondary,
            //   padding: EdgeInsets.all(12),
            //   width: double.infinity,
            //   child: Row(
            //     children: [
            //       Icon(Icons.inventory, color: Colors.white),
            //       SizedBox(width: 10),
            //       Text("Bin Location Check",
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 18,
            //               fontWeight: FontWeight.bold,
            //           ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Expanded(
                  //   child: TextField(
                  //     controller: _binLocationController.searchController,
                  //     decoration: InputDecoration(
                  //       labelText: "Enter Part Number Here",
                  //       suffixIcon: IconButton(
                  //         icon: Icon(Icons.search),
                  //         onPressed: _binLocationController.handleSearch,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: SearchBarWidget(
                      hintText: "Enter Part Number Here",
                      onSearch: _binLocationController.search,
                      controller: _binLocationController.searchController,
                      formKey: _binLocationController.formKey,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _binLocationController.pickFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      // backgroundColor: DMAppColors.secondary,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(12),
                    ),
                    child: Icon(Icons.upload, color: Colors.white),
                  )
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mq.width * .02, vertical: mq.width * .02),
              child: Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: mq.width - mq.width * .04, // Full width
                      // decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black),
                      // ),
                      child: Table(
                        border: TableBorder.symmetric(
                          inside: BorderSide(color: Colors.black, width: 0.5),
                          outside: BorderSide(color: Colors.black, width: 1),
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: DMAppColors.secondary,
                            ),
                            children: [
                              _tableHeader("Part Number"),
                              _tableHeader("Bin Location"),
                              // Padding(
                              //   padding: EdgeInsets.all(12.0),
                              //   child: Center(
                              //     child: Text(
                              //       "Part Number",
                              //       style: TextStyle(
                              //         color: Colors.white,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.all(12.0),
                              //   child: Center(
                              //     child: Text(
                              //       "Bin Location",
                              //       style: TextStyle(
                              //         color: Colors.white,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          ..._binLocationController.searchResults.map(
                            (result) => TableRow(
                              decoration:
                                  BoxDecoration(color: Colors.teal.shade50),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(result['Part Number'] ?? ''),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(result['Bin Location'] ?? ''),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader(String text) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
