import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:gainer/gainer_app/core/widgets/scs_circle_icon.dart';
import 'package:gainer/gainer_app/modules/buyer_action/order_placed_view/widgets/order_card.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/gainer_color.dart';
import '../../../core/widgets/discount_widget/discount_flag.dart';
import 'order_placed_controller.dart';
import 'order_placed_model.dart';

class OrderPlacedView extends GetView<OrderPlacedController> {
  const OrderPlacedView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GainerColors.background,
      appBar: AppBar(
        backgroundColor: GainerColors.primary,
        title: Text('Order Placed'),
        actions: [ScsCircleIcon()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: GainerTextFormField(
                  hint: 'Search by part number',
                  suffixIcon:
                      IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                ),
              ),
              ElevatedButton(
                  onPressed: controller.toggleGrouping, child: Text("Toggale")),
              Obx(() {
                return ListView(
                  shrinkWrap: true,
                  children: controller.groupedData.entries.map((entry) {
                    final groupTitle = entry.key;
                    final items = entry.value;
                    print("Key: $groupTitle");
                    print("items: $items");
                    return _buildExpansionTile(items);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// GROUP HEADER
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            groupTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        /// GROUP ITEMS
                        ...items.map((order) => PartCard(
                              order: order,
                              onRemove: () {},
                            )),
                      ],
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
        // child: Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //
        //     ListView(padding: const EdgeInsets.all(8), children: [
        //       const SizedBox(height: 5),
        //       GainerTextFormField(
        //         hint: 'Search by part number',
        //         suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        //       ),
        //       const SizedBox(height: 5),
        //
        //       Obx(() {
        //         final err = controller.errorMsg.value;
        //         // if (controller.isLoading.value) {
        //         //   return const CircularProgressIndicator();
        //         // }
        //         // if (err != null && err.isNotEmpty) {
        //         //   return ErrorWidget(err);
        //         // }
        //         // if (controller.orderPlacedList.isEmpty) {
        //         //   return Center(child: const Text('There is no order'));
        //         // }
        //         return Skeletonizer(
        //             enabled: controller.isLoading.value,
        //             child: _buildExpansionTile());
        //       }),
        //       const SizedBox(height: 5),
        //       // ExpansionTile(
        //       //   // showTrailingIcon: false,
        //       //   tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //       //
        //       //   title: Row(
        //       //     spacing: 10,
        //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       //     children: [
        //       //       Text(
        //       //         '123456789098',
        //       //         style: TextStyle(
        //       //           fontSize: 13,
        //       //           fontWeight: FontWeight.bold,
        //       //           color: GainerColors.textPrimary,
        //       //         ),
        //       //       ),
        //       //       const SizedBox(width: 5),
        //       //       Expanded(
        //       //           child: Text(
        //       //         'Syncing files to device SM E236B',
        //       //         style: TextStyle(
        //       //           fontSize: 13,
        //       //           fontWeight: FontWeight.bold,
        //       //           color: GainerColors.textPrimary,
        //       //         ),
        //       //       )),
        //       //       Text(
        //       //         'PO Qty: 8',
        //       //         style: TextStyle(
        //       //           fontSize: 13,
        //       //           fontWeight: FontWeight.bold,
        //       //           color: GainerColors.textPrimary,
        //       //         ),
        //       //       ),
        //       //     ],
        //       //   ),
        //       //   backgroundColor: GainerColors.white,
        //       //   collapsedBackgroundColor: GainerColors.white,
        //       //   collapsedShape: RoundedRectangleBorder(
        //       //     borderRadius: BorderRadius.circular(8),
        //       //   ),
        //       //   shape: RoundedRectangleBorder(
        //       //     borderRadius: BorderRadius.circular(8),
        //       //   ),
        //       //   // childrenPadding: const EdgeInsets.symmetric(horizontal: 5.0),
        //       //
        //       //   children: [
        //       //     Container(
        //       //       // color: GainerColors.background2,
        //       //       decoration: BoxDecoration(
        //       //         gradient: LinearGradient(
        //       //           begin: Alignment(0.94, 0.97), // approx for 257.29°
        //       //           end: Alignment(2.94, -0.47),
        //       //           colors: [
        //       //             Color.fromRGBO(213, 221, 249, 0.5),
        //       //             Color.fromRGBO(223, 247, 246, 0.2),
        //       //           ],
        //       //           stops: [0.2071, 0.5459],
        //       //         ),
        //       //       ),
        //       //       child: Padding(
        //       //         padding: const EdgeInsets.all(8.0),
        //       //         child: Column(
        //       //           children: [
        //       //             // const SizedBox(height: 4),
        //       //             Row(
        //       //               children: [
        //       //                 Text(
        //       //                   'Seller Details:',
        //       //                   style: TextStyle(
        //       //                       fontSize: 12,
        //       //                       // fontWeight: FontWeight.bold,
        //       //                       // color: GainerColors.textPrimary,
        //       //                       color: Colors.black),
        //       //                 ),
        //       //               ],
        //       //             ),
        //       //             Row(
        //       //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       //               children: [
        //       //                 // Text(
        //       //                 //   'Seller Details',
        //       //                 //   style: TextStyle(
        //       //                 //       fontSize: 12,
        //       //                 //       fontWeight: FontWeight.bold,
        //       //                 //       color: GainerColors.textPrimary),
        //       //                 // ),
        //       //                 Text(
        //       //                   'Honda Service',
        //       //                   style: TextStyle(
        //       //                       fontSize: 12, fontWeight: FontWeight.bold),
        //       //                 ),
        //       //                 Row(
        //       //                   children: [
        //       //                     Text(
        //       //                       'Ordered Date: ',
        //       //                       style:
        //       //                           TextStyle(fontSize: 12, color: Colors.black),
        //       //                     ),
        //       //                     Text(
        //       //                       'Nov 17 2025',
        //       //                       style: TextStyle(
        //       //                           fontSize: 12, fontWeight: FontWeight.bold),
        //       //                     ),
        //       //                   ],
        //       //                 ),
        //       //                 // _titleText("Seller Details"),
        //       //               ],
        //       //             ),
        //       //             Row(
        //       //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       //               children: [
        //       //                 // Text(
        //       //                 //   'Honda Service',
        //       //                 //   style: TextStyle(
        //       //                 //     fontSize: 12,
        //       //                 //   ),
        //       //                 // ),
        //       //                 Row(
        //       //                   children: [
        //       //                     // Icon(
        //       //                     //   Icons.location_on,
        //       //                     //   size: 14,
        //       //                     //   color: GainerColors.textPrimary,
        //       //                     // ),
        //       //                     Text('Gurgaon',
        //       //                         style: TextStyle(
        //       //                             fontSize: 12, fontWeight: FontWeight.bold))
        //       //                   ],
        //       //                 ),
        //       //                 Row(
        //       //                   children: [
        //       //                     Text(
        //       //                       'Ordered Qty: ',
        //       //                       style:
        //       //                           TextStyle(fontSize: 12, color: Colors.black),
        //       //                     ),
        //       //                     Text(
        //       //                       '15',
        //       //                       style: TextStyle(
        //       //                           fontSize: 12, fontWeight: FontWeight.bold),
        //       //                     ),
        //       //                   ],
        //       //                 ),
        //       //               ],
        //       //             ),
        //       //             // Row(
        //       //             //   children: [
        //       //             //     Icon(
        //       //             //       Icons.location_on,
        //       //             //       size: 14,
        //       //             //       color: GainerColors.textPrimary,
        //       //             //     ),
        //       //             //     Text('Gurgaon',
        //       //             //         style: TextStyle(
        //       //             //           fontSize: 12,
        //       //             //           color: Colors.black,
        //       //             //         ))
        //       //             //   ],
        //       //             // ),
        //       //             ///
        //       //             // _contentRow("Honda Service",
        //       //             //     "Ordered Date: Nov 17 2025"),
        //       //             // _contentRow("Gurgaon", "Ordered Qty: 15",
        //       //             //     isLocation: true),
        //       //             Row(
        //       //               spacing: 10,
        //       //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       //               children: [
        //       //                 Row(
        //       //                   spacing: 10,
        //       //                   children: [
        //       //                     Text(
        //       //                       'MRP: ',
        //       //                       style:
        //       //                           TextStyle(fontSize: 12, color: Colors.black),
        //       //                     ),
        //       //                     Text(
        //       //                       '₹1234',
        //       //                       style: TextStyle(
        //       //                           fontSize: 12,
        //       //                           decoration: TextDecoration.lineThrough,
        //       //                           fontWeight: FontWeight.bold),
        //       //                     ),
        //       //                     Text(
        //       //                       '₹591/Qty',
        //       //                       style: TextStyle(
        //       //                         fontSize: 14,
        //       //                         color: GainerColors.textPrimary,
        //       //                         fontWeight: FontWeight.bold,
        //       //                       ),
        //       //                     ),
        //       //                     Container(
        //       //                       padding: EdgeInsets.symmetric(
        //       //                           vertical: 2, horizontal: 8),
        //       //                       decoration: BoxDecoration(
        //       //                         // color: GainerColors.maroon1,
        //       //                         color: Colors.deepOrange[900],
        //       //                         // color: GainerColors.maroon2,
        //       //                         borderRadius: BorderRadius.horizontal(
        //       //                             left: Radius.circular(8)),
        //       //                       ),
        //       //                       child: Text(
        //       //                         '30% Discount',
        //       //                         style: TextStyle(
        //       //                             color: Colors.white,
        //       //                             fontWeight: FontWeight.bold),
        //       //                       ),
        //       //                     ),
        //       //                   ],
        //       //                 ),
        //       //                 InkWell(
        //       //                   onTap: () {
        //       //                     print("remove Item tapped");
        //       //                   },
        //       //                   child: Padding(
        //       //                     padding: const EdgeInsets.all(4.0),
        //       //                     child: Row(
        //       //                       mainAxisSize: MainAxisSize.min,
        //       //                       children: [
        //       //                         Icon(
        //       //                           Icons.delete_forever,
        //       //                           // color: GainerColors.primary,
        //       //                           color: Colors.black,
        //       //                           size: 28,
        //       //                         ),
        //       //                         // Text(
        //       //                         //   'Remove Item',
        //       //                         //   style: TextStyle(
        //       //                         //       fontSize: 12,
        //       //                         //       color: GainerColors.error),
        //       //                         // )
        //       //                       ],
        //       //                     ),
        //       //                   ),
        //       //                 ),
        //       //               ],
        //       //             ),
        //       //             Row(
        //       //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       //               children: [
        //       //                 Row(
        //       //                   mainAxisSize: MainAxisSize.min,
        //       //                   children: [
        //       //                     Text(
        //       //                       'Remarks: ',
        //       //                       style:
        //       //                           TextStyle(fontSize: 12, color: Colors.black),
        //       //                     ),
        //       //                     SizedBox(
        //       //                       width: size.width * .5,
        //       //                       child: SingleChildScrollView(
        //       //                         scrollDirection: Axis.horizontal,
        //       //                         child: Text(
        //       //                           'Syncing files to device SM E236B (wireless)...',
        //       //                           style: TextStyle(
        //       //                               fontSize: 12,
        //       //                               fontWeight: FontWeight.bold),
        //       //                         ),
        //       //                       ),
        //       //                     ),
        //       //                   ],
        //       //                 ),
        //       //                 // InkWell(
        //       //                 //   onTap: () {
        //       //                 //     print("remove Item tapped");
        //       //                 //   },
        //       //                 //   child: Padding(
        //       //                 //     padding: const EdgeInsets.all(4.0),
        //       //                 //     child: Row(
        //       //                 //       mainAxisSize: MainAxisSize.min,
        //       //                 //       children: [
        //       //                 //         Icon(
        //       //                 //           Icons.delete_forever,
        //       //                 //           color: GainerColors.error,
        //       //                 //           size: 22,
        //       //                 //         ),
        //       //                 //         Text(
        //       //                 //           'Remove Item',
        //       //                 //           style: TextStyle(
        //       //                 //               fontSize: 12,
        //       //                 //               color: GainerColors.error),
        //       //                 //         )
        //       //                 //       ],
        //       //                 //     ),
        //       //                 //   ),
        //       //                 // ),
        //       //               ],
        //       //             ),
        //       //             // const SizedBox(height: 5),
        //       //             // const SizedBox(height: 4),
        //       //           ],
        //       //         ),
        //       //       ),
        //       //     ),
        //       //     Container(height: 1, color: Colors.black45),
        //       //     Container(
        //       //       // color: GainerColors.background2,
        //       //       decoration: BoxDecoration(
        //       //         gradient: LinearGradient(
        //       //           begin: Alignment(0.94, 0.97), // approx for 257.29°
        //       //           end: Alignment(2.94, -0.47),
        //       //           colors: [
        //       //             Color.fromRGBO(213, 221, 249, 0.5),
        //       //             Color.fromRGBO(223, 247, 246, 0.2),
        //       //           ],
        //       //           stops: [0.2071, 0.5459],
        //       //         ),
        //       //       ),
        //       //       child: Padding(
        //       //         padding: const EdgeInsets.all(8.0),
        //       //         child: Column(
        //       //           children: [
        //       //             // const SizedBox(height: 4),
        //       //             Row(
        //       //               children: [
        //       //                 Text(
        //       //                   'Seller Details:',
        //       //                   style: TextStyle(
        //       //                       fontSize: 12,
        //       //                       // fontWeight: FontWeight.bold,
        //       //                       // color: GainerColors.textPrimary,
        //       //                       color: Colors.black),
        //       //                 ),
        //       //               ],
        //       //             ),
        //       //             Row(
        //       //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       //               children: [
        //       //                 // Text(
        //       //                 //   'Seller Details',
        //       //                 //   style: TextStyle(
        //       //                 //       fontSize: 12,
        //       //                 //       fontWeight: FontWeight.bold,
        //       //                 //       color: GainerColors.textPrimary),
        //       //                 // ),
        //       //                 Text(
        //       //                   'Honda Service',
        //       //                   style: TextStyle(
        //       //                       fontSize: 12, fontWeight: FontWeight.bold),
        //       //                 ),
        //       //                 Row(
        //       //                   children: [
        //       //                     Text(
        //       //                       'Ordered Date: ',
        //       //                       style:
        //       //                           TextStyle(fontSize: 12, color: Colors.black),
        //       //                     ),
        //       //                     Text(
        //       //                       'Nov 17 2025',
        //       //                       style: TextStyle(
        //       //                           fontSize: 12, fontWeight: FontWeight.bold),
        //       //                     ),
        //       //                   ],
        //       //                 ),
        //       //                 // _titleText("Seller Details"),
        //       //               ],
        //       //             ),
        //       //             Row(
        //       //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       //               children: [
        //       //                 // Text(
        //       //                 //   'Honda Service',
        //       //                 //   style: TextStyle(
        //       //                 //     fontSize: 12,
        //       //                 //   ),
        //       //                 // ),
        //       //                 Row(
        //       //                   children: [
        //       //                     // Icon(
        //       //                     //   Icons.location_on,
        //       //                     //   size: 14,
        //       //                     //   color: GainerColors.textPrimary,
        //       //                     // ),
        //       //                     Text('Gurgaon',
        //       //                         style: TextStyle(
        //       //                             fontSize: 12, fontWeight: FontWeight.bold))
        //       //                   ],
        //       //                 ),
        //       //                 Row(
        //       //                   children: [
        //       //                     Text(
        //       //                       'Ordered Qty: ',
        //       //                       style:
        //       //                           TextStyle(fontSize: 12, color: Colors.black),
        //       //                     ),
        //       //                     Text(
        //       //                       '15',
        //       //                       style: TextStyle(
        //       //                           fontSize: 12, fontWeight: FontWeight.bold),
        //       //                     ),
        //       //                   ],
        //       //                 ),
        //       //               ],
        //       //             ),
        //       //             // Row(
        //       //             //   children: [
        //       //             //     Icon(
        //       //             //       Icons.location_on,
        //       //             //       size: 14,
        //       //             //       color: GainerColors.textPrimary,
        //       //             //     ),
        //       //             //     Text('Gurgaon',
        //       //             //         style: TextStyle(
        //       //             //           fontSize: 12,
        //       //             //           color: Colors.black,
        //       //             //         ))
        //       //             //   ],
        //       //             // ),
        //       //             ///
        //       //             // _contentRow("Honda Service",
        //       //             //     "Ordered Date: Nov 17 2025"),
        //       //             // _contentRow("Gurgaon", "Ordered Qty: 15",
        //       //             //     isLocation: true),
        //       //             Row(
        //       //               spacing: 10,
        //       //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       //               children: [
        //       //                 Row(
        //       //                   spacing: 10,
        //       //                   children: [
        //       //                     Text(
        //       //                       'MRP: ',
        //       //                       style:
        //       //                           TextStyle(fontSize: 12, color: Colors.black),
        //       //                     ),
        //       //                     Text(
        //       //                       '₹1234',
        //       //                       style: TextStyle(
        //       //                           fontSize: 12,
        //       //                           decoration: TextDecoration.lineThrough,
        //       //                           fontWeight: FontWeight.bold),
        //       //                     ),
        //       //                     Text(
        //       //                       '₹591/Qty',
        //       //                       style: TextStyle(
        //       //                           fontSize: 14,
        //       //                           color: GainerColors.textPrimary,
        //       //                           fontWeight: FontWeight.bold),
        //       //                     ),
        //       //                     Container(
        //       //                       padding: EdgeInsets.symmetric(
        //       //                           vertical: 2, horizontal: 8),
        //       //                       decoration: BoxDecoration(
        //       //                         // color: GainerColors.maroon1,
        //       //                         color: Colors.deepOrange[900],
        //       //                         // color: GainerColors.maroon2,
        //       //                         borderRadius: BorderRadius.horizontal(
        //       //                             left: Radius.circular(8)),
        //       //                       ),
        //       //                       child: Text(
        //       //                         '30% Discount',
        //       //                         style: TextStyle(
        //       //                             color: Colors.white,
        //       //                             fontWeight: FontWeight.bold),
        //       //                       ),
        //       //                     ),
        //       //                   ],
        //       //                 ),
        //       //                 InkWell(
        //       //                   onTap: () {
        //       //                     print("remove Item tapped");
        //       //                   },
        //       //                   child: Padding(
        //       //                     padding: const EdgeInsets.all(4.0),
        //       //                     child: Row(
        //       //                       mainAxisSize: MainAxisSize.min,
        //       //                       children: [
        //       //                         SizedBox(
        //       //                           height: 28,
        //       //                           child: Icon(
        //       //                             Icons.delete_forever,
        //       //                             // color: GainerColors.primary,
        //       //                             color: Colors.black,
        //       //                             size: 28,
        //       //                           ),
        //       //                         ),
        //       //                         // Text(
        //       //                         //   'Remove Item',
        //       //                         //   style: TextStyle(
        //       //                         //       fontSize: 12,
        //       //                         //       color: GainerColors.error),
        //       //                         // )
        //       //                       ],
        //       //                     ),
        //       //                   ),
        //       //                 ),
        //       //               ],
        //       //             ),
        //       //             Row(
        //       //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       //               children: [
        //       //                 Row(
        //       //                   mainAxisSize: MainAxisSize.min,
        //       //                   children: [
        //       //                     Text(
        //       //                       'Remarks: ',
        //       //                       style:
        //       //                           TextStyle(fontSize: 12, color: Colors.black),
        //       //                     ),
        //       //                     SizedBox(
        //       //                       width: size.width * .5,
        //       //                       child: SingleChildScrollView(
        //       //                         scrollDirection: Axis.horizontal,
        //       //                         child: Text(
        //       //                           'Syncing files to device SM E236B (wireless)...',
        //       //                           style: TextStyle(
        //       //                               fontSize: 12,
        //       //                               fontWeight: FontWeight.bold),
        //       //                         ),
        //       //                       ),
        //       //                     ),
        //       //                   ],
        //       //                 ),
        //       //                 // InkWell(
        //       //                 //   onTap: () {
        //       //                 //     print("remove Item tapped");
        //       //                 //   },
        //       //                 //   child: Padding(
        //       //                 //     padding: const EdgeInsets.all(4.0),
        //       //                 //     child: Row(
        //       //                 //       mainAxisSize: MainAxisSize.min,
        //       //                 //       children: [
        //       //                 //         Icon(
        //       //                 //           Icons.delete_forever,
        //       //                 //           color: GainerColors.error,
        //       //                 //           size: 22,
        //       //                 //         ),
        //       //                 //         Text(
        //       //                 //           'Remove Item',
        //       //                 //           style: TextStyle(
        //       //                 //               fontSize: 12,
        //       //                 //               color: GainerColors.error),
        //       //                 //         )
        //       //                 //       ],
        //       //                 //     ),
        //       //                 //   ),
        //       //                 // ),
        //       //               ],
        //       //             ),
        //       //             // const SizedBox(height: 5),
        //       //             // const SizedBox(height: 4),
        //       //           ],
        //       //         ),
        //       //       ),
        //       //     ),
        //       //   ],
        //       // ),
        //     ]),
        //   ],
        // )
      ),
    );
  }

  Widget _buildExpansionTile(List<OrderPlacedModel> parts) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: GainerColors.white,
      collapsedBackgroundColor: GainerColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      collapsedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: ExpansionHeader(order: parts,),
      children: parts
          .map(
            (order) => PartCard(
              order: order,
              onRemove: () {},
            ),
          )
          .toList(),
      // children: [
      //   Obx(
      //     () => ListView.separated(
      //       shrinkWrap: true,
      //       physics: const NeverScrollableScrollPhysics(),
      //       itemCount: controller.orderPlacedList.length,
      //       separatorBuilder: (_, __) =>
      //           const Divider(height: 1, color: Colors.black38),
      //       itemBuilder: (_, index) {
      //         print(controller.orderPlacedList[index].partNumber);
      //         print(controller.orderPlacedList[index].sellerLocation);
      //
      //         return PartCard(
      //           order: controller.orderPlacedList[index],
      //           onRemove: () => controller.removeOrder(index),
      //         );
      //       },
      //     ),
      //   )
      // ],
    );
  }
}

class ExpansionHeader extends StatelessWidget {
  final List<OrderPlacedModel> order;

  const ExpansionHeader({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _titleText(order[0].partNumber ?? ''),

        const SizedBox(width: 8),

        Expanded(
          child: _titleText(
            order[0].partDesc ?? '',
          ),
        ),

        _titleText('Qty: ${order[0].qty ?? 0}'),
      ],
    );
  }

  Widget _titleText(String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: GainerColors.textPrimary,
      ),
    );
  }
}

// class _ExpansionHeader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       spacing: 10,
//       children: [
//         _titleText('123456789098'),
//         const SizedBox(width: 8),
//         Expanded(child: _titleText('Syncing files to device SM E236B')),
//         _titleText('Qty: 8'),
//       ],
//     );
//   }
//
//   Widget _titleText(String text) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: 13,
//         fontWeight: FontWeight.bold,
//         color: GainerColors.textPrimary,
//       ),
//     );
//   }
// }

// class OrderItemCard extends StatelessWidget {
//   final OrderPlacedModel order;
//   final VoidCallback onRemove;
//
//   const OrderItemCard({
//     super.key,
//     required this.order,
//     required this.onRemove,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Container(
//       decoration: _gradientDecoration(),
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _label('Seller Details:'),
//           _row(
//             left: _bold(order.dealerName),
//             right: _keyValue('Ordered Date', order.requestDate),
//           ),
//           _row(
//             left: _bold(order.sellerLocation),
//             right: _keyValue('Ordered Qty', order.qty.toString()),
//           ),
//           _priceRow(order, size),
//           _remarksRow(size),
//         ],
//       ),
//     );
//   }
//
//   /// UI Pieces ↓↓↓
//
//   Widget _priceRow(OrderPlacedModel order, Size size) {
//     return Row(
//       children: [
//         _label('MRP:'),
//         _strikeText('₹${order.mrp?.toInt()}'),
//         const SizedBox(width: 6),
//         _priceText('₹${order.price?.toInt()}/Qty'),
//         const SizedBox(width: 6),
//         // _discountChip('${order.discount}% Off'),
//         DiscountFlag(text: '${order.discount}% Off'),
//         const Spacer(),
//         InkWell(
//           onTap: onRemove,
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.delete_forever,
//                 color: Colors.black,
//                 size: 24,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _remarksRow(Size size) {
//     return Row(
//       children: [
//         _label('Remarks: '),
//         SizedBox(
//           width: size.width * .55,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: _bold(order.remarks),
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Helpers ↓↓↓
//
//   Widget _row({required Widget left, required Widget right}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [left, right],
//     );
//   }
//
//   Widget _label(String? text) =>
//       Text(text ?? '', style: const TextStyle(fontSize: 12));
//
//   Widget _bold(String? text) => Text(
//         text ?? '',
//         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//       );
//
//   Widget _keyValue(String key, String? value) {
//     return Row(
//       children: [
//         _label('$key: '),
//         _bold(value),
//       ],
//     );
//   }
//
//   Widget _strikeText(String text) => Text(
//         text,
//         style: const TextStyle(
//           fontSize: 12,
//           decoration: TextDecoration.lineThrough,
//           fontWeight: FontWeight.bold,
//         ),
//       );
//
//   Widget _priceText(String text) => Text(
//         text,
//         style: TextStyle(
//           fontSize: 14,
//           color: GainerColors.textPrimary,
//           fontWeight: FontWeight.bold,
//         ),
//       );
//
//   Widget _discountChip(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       decoration: BoxDecoration(
//         color: Colors.deepOrange[900],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         text,
//         style:
//             const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
//
//   BoxDecoration _gradientDecoration() {
//     return const BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment(0.94, 0.97),
//         end: Alignment(2.94, -0.47),
//         colors: [
//           Color.fromRGBO(213, 221, 249, 0.5),
//           Color.fromRGBO(223, 247, 246, 0.2),
//         ],
//       ),
//     );
//   }
// }

/*class OrderPlacedView extends GetView<OrderPlacedController> {
  const OrderPlacedView({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GainerColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                        // showTrailingIcon: false,
                        tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                        title: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '123456789098',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: GainerColors.textPrimary,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                                child: Text(
                              'Syncing files to device SM E236B',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: GainerColors.textPrimary,
                              ),
                            )),
                            Text(
                              'PO Qty: 8',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: GainerColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: GainerColors.white,
                        collapsedBackgroundColor: GainerColors.white,
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // childrenPadding: const EdgeInsets.symmetric(horizontal: 5.0),

                        children: [
                          Container(
                            // color: GainerColors.background2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin:
                                    Alignment(0.94, 0.97), // approx for 257.29°
                                end: Alignment(2.94, -0.47),
                                colors: [
                                  Color.fromRGBO(213, 221, 249, 0.5),
                                  Color.fromRGBO(223, 247, 246, 0.2),
                                ],
                                stops: [0.2071, 0.5459],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  // const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'Seller Details:',
                                        style: TextStyle(
                                            fontSize: 12,
                                            // fontWeight: FontWeight.bold,
                                            // color: GainerColors.textPrimary,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text(
                                      //   'Seller Details',
                                      //   style: TextStyle(
                                      //       fontSize: 12,
                                      //       fontWeight: FontWeight.bold,
                                      //       color: GainerColors.textPrimary),
                                      // ),
                                      Text(
                                        'Honda Service',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Ordered Date: ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            'Nov 17 2025',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      // _titleText("Seller Details"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text(
                                      //   'Honda Service',
                                      //   style: TextStyle(
                                      //     fontSize: 12,
                                      //   ),
                                      // ),
                                      Row(
                                        children: [
                                          // Icon(
                                          //   Icons.location_on,
                                          //   size: 14,
                                          //   color: GainerColors.textPrimary,
                                          // ),
                                          Text('Gurgaon',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Ordered Qty: ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            '15',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Icon(
                                  //       Icons.location_on,
                                  //       size: 14,
                                  //       color: GainerColors.textPrimary,
                                  //     ),
                                  //     Text('Gurgaon',
                                  //         style: TextStyle(
                                  //           fontSize: 12,
                                  //           color: Colors.black,
                                  //         ))
                                  //   ],
                                  // ),
                                  ///
                                  // _contentRow("Honda Service",
                                  //     "Ordered Date: Nov 17 2025"),
                                  // _contentRow("Gurgaon", "Ordered Qty: 15",
                                  //     isLocation: true),
                                  Row(
                                    spacing: 10,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Text(
                                            'MRP: ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            '₹1234',
                                            style: TextStyle(
                                                fontSize: 12,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '₹591/Qty',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: GainerColors.textPrimary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 8),
                                            decoration: BoxDecoration(
                                              // color: GainerColors.maroon1,
                                              color: Colors.deepOrange[900],
                                              // color: GainerColors.maroon2,
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      left: Radius.circular(8)),
                                            ),
                                            child: Text(
                                              '30% Discount',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print("remove Item tapped");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 28,
                                                child: Icon(
                                                  Icons.delete_forever,
                                                  // color: GainerColors.primary,
                                                  color: Colors.black,
                                                  size: 28,
                                                ),
                                              ),
                                              // Text(
                                              //   'Remove Item',
                                              //   style: TextStyle(
                                              //       fontSize: 12,
                                              //       color: GainerColors.error),
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Remarks: ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: size.width * .5,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                'Syncing files to device SM E236B (wireless)...',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // InkWell(
                                      //   onTap: () {
                                      //     print("remove Item tapped");
                                      //   },
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.all(4.0),
                                      //     child: Row(
                                      //       mainAxisSize: MainAxisSize.min,
                                      //       children: [
                                      //         Icon(
                                      //           Icons.delete_forever,
                                      //           color: GainerColors.error,
                                      //           size: 22,
                                      //         ),
                                      //         Text(
                                      //           'Remove Item',
                                      //           style: TextStyle(
                                      //               fontSize: 12,
                                      //               color: GainerColors.error),
                                      //         )
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  // const SizedBox(height: 5),
                                  // const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ),
                          Container(height: 1, color: Colors.black45),
                          Container(
                            // color: GainerColors.background2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin:
                                    Alignment(0.94, 0.97), // approx for 257.29°
                                end: Alignment(2.94, -0.47),
                                colors: [
                                  Color.fromRGBO(213, 221, 249, 0.5),
                                  Color.fromRGBO(223, 247, 246, 0.2),
                                ],
                                stops: [0.2071, 0.5459],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  // const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'Seller Details:',
                                        style: TextStyle(
                                            fontSize: 12,
                                            // fontWeight: FontWeight.bold,
                                            // color: GainerColors.textPrimary,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text(
                                      //   'Seller Details',
                                      //   style: TextStyle(
                                      //       fontSize: 12,
                                      //       fontWeight: FontWeight.bold,
                                      //       color: GainerColors.textPrimary),
                                      // ),
                                      Text(
                                        'Honda Service',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Ordered Date: ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            'Nov 17 2025',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      // _titleText("Seller Details"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text(
                                      //   'Honda Service',
                                      //   style: TextStyle(
                                      //     fontSize: 12,
                                      //   ),
                                      // ),
                                      Row(
                                        children: [
                                          // Icon(
                                          //   Icons.location_on,
                                          //   size: 14,
                                          //   color: GainerColors.textPrimary,
                                          // ),
                                          Text('Gurgaon',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Ordered Qty: ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            '15',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Icon(
                                  //       Icons.location_on,
                                  //       size: 14,
                                  //       color: GainerColors.textPrimary,
                                  //     ),
                                  //     Text('Gurgaon',
                                  //         style: TextStyle(
                                  //           fontSize: 12,
                                  //           color: Colors.black,
                                  //         ))
                                  //   ],
                                  // ),
                                  ///
                                  // _contentRow("Honda Service",
                                  //     "Ordered Date: Nov 17 2025"),
                                  // _contentRow("Gurgaon", "Ordered Qty: 15",
                                  //     isLocation: true),
                                  Row(
                                    spacing: 10,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Text(
                                            'MRP: ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            '₹1234',
                                            style: TextStyle(
                                                fontSize: 12,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '₹591/Qty',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: GainerColors.textPrimary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 8),
                                            decoration: BoxDecoration(
                                              // color: GainerColors.maroon1,
                                              color: Colors.deepOrange[900],
                                              // color: GainerColors.maroon2,
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      left: Radius.circular(8)),
                                            ),
                                            child: Text(
                                              '30% Discount',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print("remove Item tapped");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 28,
                                                child: Icon(
                                                  Icons.delete_forever,
                                                  // color: GainerColors.primary,
                                                  color: Colors.black,
                                                  size: 28,
                                                ),
                                              ),
                                              // Text(
                                              //   'Remove Item',
                                              //   style: TextStyle(
                                              //       fontSize: 12,
                                              //       color: GainerColors.error),
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Remarks: ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: size.width * .5,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                'Syncing files to device SM E236B (wireless)...',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // InkWell(
                                      //   onTap: () {
                                      //     print("remove Item tapped");
                                      //   },
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.all(4.0),
                                      //     child: Row(
                                      //       mainAxisSize: MainAxisSize.min,
                                      //       children: [
                                      //         Icon(
                                      //           Icons.delete_forever,
                                      //           color: GainerColors.error,
                                      //           size: 22,
                                      //         ),
                                      //         Text(
                                      //           'Remove Item',
                                      //           style: TextStyle(
                                      //               fontSize: 12,
                                      //               color: GainerColors.error),
                                      //         )
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  // const SizedBox(height: 5),
                                  // const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ),
                          // Obx(
                          //   () => ListView.builder(
                          //     shrinkWrap: true,
                          //     padding: const EdgeInsets.all(12),
                          //     itemCount: controller.orders.length,
                          //     itemBuilder: (context, index) {
                          //       return OrderCard(
                          //         order: controller.orders[index],
                          //         onRemove: () => controller.removeOrder(index),
                          //       );
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}*/
