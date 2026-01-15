import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/constants/gainer_image.dart';
import 'package:gainer/gainer_app/modules/main_screen/widgets/action_section.dart';
import 'package:gainer/gainer_app/modules/main_screen/widgets/balance_card.dart';
import 'package:gainer/testing/test_dropdown.dart';
import 'package:get/get.dart';
import '../../core/constants/gainer_color.dart';
import 'gainer_main_controller.dart';

class GainerMainView extends GetView<GainerMainController> {
  const GainerMainView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GainerColors.background,
      appBar: AppBar(
        backgroundColor: GainerColors.primary,
        title: const Text('Home'),
        actions: [
          const Icon(Icons.notifications),
          const SizedBox(width: 12),
          // Icon(Icons.settings),
          Image.asset(GainerImages.scsCircle),
          const SizedBox(width: 12),
        ],
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.app_switcher_view,color: GainerColors.primary,), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.location_on,color: GainerColors.primary,), label: "Track Order"),
      //     BottomNavigationBarItem(icon: Icon(Icons.shopping_cart,color: GainerColors.primary,), label: "Part Request"),
      //     BottomNavigationBarItem(icon: Icon(Icons.help,color: GainerColors.primary,), label: "Help"),
      //   ],
      // ),

      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: controller.pages,
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTab,
        items: controller.items,
        type: BottomNavigationBarType.fixed,
      )),

/*
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Location
            SizedBox(height: 45, child: SimpleDropdown()),
            const SizedBox(height: 6),

            /// Search Part
            const Text("Search your Part",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: TextDecoration.underline)),
            const SizedBox(height: 4),
            SizedBox(
              height: 45,
              child: GainerTextFormField(
                label: "Enter part number",
                controller: controller.searchController,
                suffixIcon: IconButton(
                  onPressed: controller.onSearchPressed,
                  icon: Icon(Icons.search),
                ),
                onChanged: controller.onSearchChanged,
              ),
            ),
            const BalanceCard(),

            /// SCS
            Center(child: Image.asset(AppImages.scsBlackLinear, height: 80)),

            const SizedBox(height: 6),

            /// Actions
            */ /*Center(
              child: Card(
                elevation: 4,
                color: Colors.white70,
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("What would you like to do today?",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Card(
                              margin: EdgeInsets.zero,
                              color: Colors.blue,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      'Action as Buyer',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    color: Colors.white70,
                                    child: Column(
                                      children: [
                                        Card(
                                          margin: EdgeInsets.all(4),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.token_rounded,
                                                      color: Colors.blue,
                                                      size: 30,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Order Placed",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                        ),
                                                        Text(
                                                          "6 orders | ₹10.13L",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black87),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            size.width * .03),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.black,
                                                      size: 16,
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  'pending since Jan 10, 2025',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          margin: EdgeInsets.all(4),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.token_rounded,
                                                      color: Colors.blue,
                                                      size: 30,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Order Placed",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                        ),
                                                        Text(
                                                          "6 orders | ₹10.13L",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black87),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            size.width * .03),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.black,
                                                      size: 16,
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  'pending since Jan 10, 2025',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          margin: EdgeInsets.all(4),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.token_rounded,
                                                      color: Colors.blue,
                                                      size: 30,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Order Placed",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                        ),
                                                        Text(
                                                          "6 orders | ₹10.13L",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black87),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            size.width * .03),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.black,
                                                      size: 16,
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  'pending since Jan 10, 2025',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * .02),
                          Expanded(
                            child: Card(
                              margin: EdgeInsets.zero,
                              color: Colors.green,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      'Action as Seller',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    color: Colors.white70,
                                    child: Column(
                                      children: [
                                        Card(
                                          margin: EdgeInsets.all(4),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.token_rounded,
                                                      color: Colors.blue,
                                                      size: 30,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Order Placed",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                        ),
                                                        Text(
                                                          "6 orders | ₹10.13L",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black87),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            size.width * .03),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.black,
                                                      size: 16,
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  'pending since Jan 10, 2025',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          margin: EdgeInsets.all(4),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.token_rounded,
                                                      color: Colors.blue,
                                                      size: 30,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Order Placed",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                        ),
                                                        Text(
                                                          "6 orders | ₹10.13L",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black87),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            size.width * .03),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.black,
                                                      size: 16,
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  'pending since Jan 10, 2025',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          margin: EdgeInsets.all(4),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.token_rounded,
                                                      color: Colors.blue,
                                                      size: 30,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Dispatched",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                        ),
                                                        Text(
                                                          "6 orders | ₹10.13L",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black87),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            size.width * .03),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.black,
                                                      size: 16,
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  'pending since Jan 10, 2025',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),*/ /*
            const SizedBox(height: 10),
            Center(
              child: Card(
                elevation: 4,
                color: Colors.white70,
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "What would you like to do today?",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ActionColumn(
                            title: "Action as Buyer",
                            headerColor: Colors.blue,
                            items: controller.buyerActions,
                          ),
                          const SizedBox(width: 8),
                          ActionColumn(
                            title: "Action as Seller",
                            headerColor: Colors.green,
                            items: controller.sellerActions,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // const Text("What would you like to do today?",
            //     style: TextStyle(fontWeight: FontWeight.bold)),
            //
            // const SizedBox(height: 12),
            //
            // /// Buyer
            // const Text("Action as a Buyer"),
            // const SizedBox(height: 8),
            // GridView.count(
            //   crossAxisCount: 2,
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   crossAxisSpacing: 10,
            //   mainAxisSpacing: 10,
            //   children: const [
            //     ActionCard(
            //       title: "Order Placed",
            //       subtitle: "6 orders | 10.13 Lac",
            //       status: "Action Pending Since Jan 01, 26",
            //       color: GainerColors.buyer,
            //     ),
            //     ActionCard(
            //       title: "Update PO Details",
            //       subtitle: "3 orders | 3.22 Lac",
            //       status: "Action Pending Since Jan 01, 26",
            //       color: GainerColors.buyer,
            //     ),
            //     ActionCard(
            //       title: "Part Receipt",
            //       subtitle: "8 orders | 13.45 Lac",
            //       status: "Action Pending Since Jan 01, 26",
            //       color: GainerColors.buyer,
            //     ),
            //   ],
            // ),
            //
            // const SizedBox(height: 16),
            //
            // /// Seller
            // const Text("Action as a Seller"),
            // const SizedBox(height: 8),
            // GridView.count(
            //   crossAxisCount: 2,
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   crossAxisSpacing: 10,
            //   mainAxisSpacing: 10,
            //   children: [
            //     ActionCard(
            //       title: "Order Receive",
            //       subtitle: "4 orders | 0.22 Lac",
            //       status: "Action Pending Since Jan 01, 26",
            //       color: GainerColors.seller,
            //     ),
            //     ActionCard(
            //       title: "Manifestation",
            //       subtitle: "4 orders | 0.06 Lac",
            //       status: "Action Pending Since Jan 01, 26",
            //       color: GainerColors.seller,
            //     ),
            //     ActionCard(
            //       title: "Dispatch Details",
            //       subtitle: "4 orders | 0.13 Lac",
            //       status: "Action Pending Since Jan 01, 26",
            //       color: GainerColors.seller,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      */
    );
  }
}
