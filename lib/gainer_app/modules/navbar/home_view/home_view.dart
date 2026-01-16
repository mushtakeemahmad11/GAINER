import 'package:flutter/material.dart';
import 'package:gainer/gainer/controllers/notification_controller.dart';
import 'package:gainer/gainer/widget/reusable_dropdown.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dropdown.dart';
import 'package:gainer/gainer_app/modules/main_screen/widgets/action_section.dart';
import 'package:gainer/gainer_app/modules/main_screen/widgets/balance_card.dart';
import 'package:gainer/gainer_app/modules/navbar/home_view/widgets/location_dropdown.dart';
import 'package:get/get.dart';
import '../../../../gainer/screens/constant_image_path.dart';
import '../../../core/widgets/gainer_text_form_field.dart';
import 'home_controller.dart';

// class HomeView extends GetView<HomeController> {
class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Location
          SizedBox(height: 45, child: LocationDropdown(c: controller)),

          const SizedBox(height: 6),

          /// Search Part
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: const Text("Search your Part",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: TextDecoration.underline)),
          ),
          const SizedBox(height: 2),
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
          // Center(
          //   child: Card(
          //     elevation: 4,
          //     color: Colors.white70,
          //     margin: EdgeInsets.zero,
          //     child: Column(
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: const Text("What would you like to do today?",
          //               style: TextStyle(
          //                   fontWeight: FontWeight.w500, fontSize: 18)),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             // crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               Expanded(
          //                 child: Card(
          //                   margin: EdgeInsets.zero,
          //                   color: Colors.blue,
          //                   child: Column(
          //                     children: [
          //                       Padding(
          //                         padding: const EdgeInsets.all(6.0),
          //                         child: Text(
          //                           'Action as Buyer',
          //                           style: TextStyle(
          //                               fontSize: 18,
          //                               color: Colors.white,
          //                               fontWeight: FontWeight.bold),
          //                         ),
          //                       ),
          //                       Card(
          //                         margin: EdgeInsets.zero,
          //                         color: Colors.white70,
          //                         child: Column(
          //                           children: [
          //                             Card(
          //                               margin: EdgeInsets.all(4),
          //                               child: Padding(
          //                                 padding: const EdgeInsets.all(8.0),
          //                                 child: Column(
          //                                   children: [
          //                                     Row(
          //                                       children: [
          //                                         Icon(
          //                                           Icons.token_rounded,
          //                                           color: Colors.blue,
          //                                           size: 30,
          //                                         ),
          //                                         Column(
          //                                           crossAxisAlignment:
          //                                               CrossAxisAlignment
          //                                                   .start,
          //                                           children: [
          //                                             Text(
          //                                               "Order Placed",
          //                                               style: TextStyle(
          //                                                   fontWeight:
          //                                                       FontWeight.bold,
          //                                                   fontSize: 14),
          //                                             ),
          //                                             Text(
          //                                               "6 orders | ₹10.13L",
          //                                               style: TextStyle(
          //                                                   fontSize: 12,
          //                                                   color:
          //                                                       Colors.black87),
          //                                             ),
          //                                           ],
          //                                         ),
          //                                         SizedBox(
          //                                             width: size.width * .03),
          //                                         Icon(
          //                                           Icons.arrow_forward_ios,
          //                                           color: Colors.black,
          //                                           size: 16,
          //                                         )
          //                                       ],
          //                                     ),
          //                                     Text(
          //                                       'pending since Jan 10, 2025',
          //                                       style: TextStyle(
          //                                           color: Colors.red,
          //                                           fontWeight: FontWeight.bold,
          //                                           fontSize: 10),
          //                                     )
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                             Card(
          //                               margin: EdgeInsets.all(4),
          //                               child: Padding(
          //                                 padding: const EdgeInsets.all(8.0),
          //                                 child: Column(
          //                                   children: [
          //                                     Row(
          //                                       children: [
          //                                         Icon(
          //                                           Icons.token_rounded,
          //                                           color: Colors.blue,
          //                                           size: 30,
          //                                         ),
          //                                         Column(
          //                                           crossAxisAlignment:
          //                                               CrossAxisAlignment
          //                                                   .start,
          //                                           children: [
          //                                             Text(
          //                                               "Order Placed",
          //                                               style: TextStyle(
          //                                                   fontWeight:
          //                                                       FontWeight.bold,
          //                                                   fontSize: 14),
          //                                             ),
          //                                             Text(
          //                                               "6 orders | ₹10.13L",
          //                                               style: TextStyle(
          //                                                   fontSize: 12,
          //                                                   color:
          //                                                       Colors.black87),
          //                                             ),
          //                                           ],
          //                                         ),
          //                                         SizedBox(
          //                                             width: size.width * .03),
          //                                         Icon(
          //                                           Icons.arrow_forward_ios,
          //                                           color: Colors.black,
          //                                           size: 16,
          //                                         )
          //                                       ],
          //                                     ),
          //                                     Text(
          //                                       'pending since Jan 10, 2025',
          //                                       style: TextStyle(
          //                                           color: Colors.red,
          //                                           fontWeight: FontWeight.bold,
          //                                           fontSize: 10),
          //                                     )
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                             Card(
          //                               margin: EdgeInsets.all(4),
          //                               child: Padding(
          //                                 padding: const EdgeInsets.all(8.0),
          //                                 child: Column(
          //                                   children: [
          //                                     Row(
          //                                       children: [
          //                                         Icon(
          //                                           Icons.token_rounded,
          //                                           color: Colors.blue,
          //                                           size: 30,
          //                                         ),
          //                                         Column(
          //                                           crossAxisAlignment:
          //                                               CrossAxisAlignment
          //                                                   .start,
          //                                           children: [
          //                                             Text(
          //                                               "Order Placed",
          //                                               style: TextStyle(
          //                                                   fontWeight:
          //                                                       FontWeight.bold,
          //                                                   fontSize: 14),
          //                                             ),
          //                                             Text(
          //                                               "6 orders | ₹10.13L",
          //                                               style: TextStyle(
          //                                                   fontSize: 12,
          //                                                   color:
          //                                                       Colors.black87),
          //                                             ),
          //                                           ],
          //                                         ),
          //                                         SizedBox(
          //                                             width: size.width * .03),
          //                                         Icon(
          //                                           Icons.arrow_forward_ios,
          //                                           color: Colors.black,
          //                                           size: 16,
          //                                         )
          //                                       ],
          //                                     ),
          //                                     Text(
          //                                       'pending since Jan 10, 2025',
          //                                       style: TextStyle(
          //                                           color: Colors.red,
          //                                           fontWeight: FontWeight.bold,
          //                                           fontSize: 10),
          //                                     )
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(width: size.width * .02),
          //               Expanded(
          //                 child: Card(
          //                   margin: EdgeInsets.zero,
          //                   color: Colors.green,
          //                   child: Column(
          //                     children: [
          //                       Padding(
          //                         padding: const EdgeInsets.all(6.0),
          //                         child: Text(
          //                           'Action as Seller',
          //                           style: TextStyle(
          //                               fontSize: 18,
          //                               color: Colors.white,
          //                               fontWeight: FontWeight.bold),
          //                         ),
          //                       ),
          //                       Card(
          //                         margin: EdgeInsets.zero,
          //                         color: Colors.white70,
          //                         child: Column(
          //                           children: [
          //                             Card(
          //                               margin: EdgeInsets.all(4),
          //                               child: Padding(
          //                                 padding: const EdgeInsets.all(8.0),
          //                                 child: Column(
          //                                   children: [
          //                                     Row(
          //                                       children: [
          //                                         Icon(
          //                                           Icons.token_rounded,
          //                                           color: Colors.blue,
          //                                           size: 30,
          //                                         ),
          //                                         Column(
          //                                           crossAxisAlignment:
          //                                               CrossAxisAlignment
          //                                                   .start,
          //                                           children: [
          //                                             Text(
          //                                               "Order Placed",
          //                                               style: TextStyle(
          //                                                   fontWeight:
          //                                                       FontWeight.bold,
          //                                                   fontSize: 14),
          //                                             ),
          //                                             Text(
          //                                               "6 orders | ₹10.13L",
          //                                               style: TextStyle(
          //                                                   fontSize: 12,
          //                                                   color:
          //                                                       Colors.black87),
          //                                             ),
          //                                           ],
          //                                         ),
          //                                         SizedBox(
          //                                             width: size.width * .03),
          //                                         Icon(
          //                                           Icons.arrow_forward_ios,
          //                                           color: Colors.black,
          //                                           size: 16,
          //                                         )
          //                                       ],
          //                                     ),
          //                                     Text(
          //                                       'pending since Jan 10, 2025',
          //                                       style: TextStyle(
          //                                           color: Colors.red,
          //                                           fontWeight: FontWeight.bold,
          //                                           fontSize: 10),
          //                                     )
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                             Card(
          //                               margin: EdgeInsets.all(4),
          //                               child: Padding(
          //                                 padding: const EdgeInsets.all(8.0),
          //                                 child: Column(
          //                                   children: [
          //                                     Row(
          //                                       children: [
          //                                         Icon(
          //                                           Icons.token_rounded,
          //                                           color: Colors.blue,
          //                                           size: 30,
          //                                         ),
          //                                         Column(
          //                                           crossAxisAlignment:
          //                                               CrossAxisAlignment
          //                                                   .start,
          //                                           children: [
          //                                             Text(
          //                                               "Order Placed",
          //                                               style: TextStyle(
          //                                                   fontWeight:
          //                                                       FontWeight.bold,
          //                                                   fontSize: 14),
          //                                             ),
          //                                             Text(
          //                                               "6 orders | ₹10.13L",
          //                                               style: TextStyle(
          //                                                   fontSize: 12,
          //                                                   color:
          //                                                       Colors.black87),
          //                                             ),
          //                                           ],
          //                                         ),
          //                                         SizedBox(
          //                                             width: size.width * .03),
          //                                         Icon(
          //                                           Icons.arrow_forward_ios,
          //                                           color: Colors.black,
          //                                           size: 16,
          //                                         )
          //                                       ],
          //                                     ),
          //                                     Text(
          //                                       'pending since Jan 10, 2025',
          //                                       style: TextStyle(
          //                                           color: Colors.red,
          //                                           fontWeight: FontWeight.bold,
          //                                           fontSize: 10),
          //                                     )
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                             Card(
          //                               margin: EdgeInsets.all(4),
          //                               child: Padding(
          //                                 padding: const EdgeInsets.all(8.0),
          //                                 child: Column(
          //                                   children: [
          //                                     Row(
          //                                       children: [
          //                                         Icon(
          //                                           Icons.token_rounded,
          //                                           color: Colors.blue,
          //                                           size: 30,
          //                                         ),
          //                                         Column(
          //                                           crossAxisAlignment:
          //                                               CrossAxisAlignment
          //                                                   .start,
          //                                           children: [
          //                                             Text(
          //                                               "Dispatched",
          //                                               style: TextStyle(
          //                                                   fontWeight:
          //                                                       FontWeight.bold,
          //                                                   fontSize: 14),
          //                                             ),
          //                                             Text(
          //                                               "6 orders | ₹10.13L",
          //                                               style: TextStyle(
          //                                                   fontSize: 12,
          //                                                   color:
          //                                                       Colors.black87),
          //                                             ),
          //                                           ],
          //                                         ),
          //                                         SizedBox(
          //                                             width: size.width * .03),
          //                                         Icon(
          //                                           Icons.arrow_forward_ios,
          //                                           color: Colors.black,
          //                                           size: 16,
          //                                         )
          //                                       ],
          //                                     ),
          //                                     Text(
          //                                       'pending since Jan 10, 2025',
          //                                       style: TextStyle(
          //                                           color: Colors.red,
          //                                           fontWeight: FontWeight.bold,
          //                                           fontSize: 10),
          //                                     )
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 10),
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
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
        ],
      ),
    );
  }
}
