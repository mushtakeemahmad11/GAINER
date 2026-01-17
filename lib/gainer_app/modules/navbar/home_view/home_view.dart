import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/main_screen/widgets/action_section.dart';
import 'package:gainer/gainer_app/modules/navbar/home_view/widgets/balance_card.dart';
import 'package:gainer/gainer_app/modules/navbar/home_view/widgets/location_dropdown.dart';
import 'package:get/get.dart';
import '../../../../gainer/screens/constant_image_path.dart';
import '../../../core/widgets/gainer_text_form_field.dart';
import 'home_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

// class HomeView extends GetView<HomeController> {
class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Obx(() => Skeletonizer(
            enabled: controller.isStageDataLoad.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Location Dropdown
                SizedBox(height: 45, child: LocationDropdown(c: controller)),

                const SizedBox(height: 6),

                /// Search Part Text Field
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

                /// SCS Logo
                Center(
                    child: Image.asset(AppImages.scsBlackLinear, height: 80)),

                const SizedBox(height: 6),

                /// Actions as buyer/Seller
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
                        Skeletonizer(
                          enabled: controller.isStageDataLoad.value,
                          child: Padding(
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
                        ),
                      ],
                    ),
                  ),
                ),
                // Center(
                //   child: Card(
                //     elevation: 4,
                //     color: Colors.white70,
                //     margin: EdgeInsets.zero,
                //     child: Column(
                //       children: [
                //         const Padding(
                //           padding: EdgeInsets.all(8),
                //           child: Text(
                //             "What would you like to do today?",
                //             style:
                //                 TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.all(8),
                //           child: Row(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               ActionColumn(
                //                 title: "Action as Buyer",
                //                 headerColor: Colors.blue,
                //                 items: controller.buyerActions1,
                //               ),
                //               const SizedBox(width: 8),
                //               ActionColumn(
                //                 title: "Action as Seller",
                //                 headerColor: Colors.green,
                //                 items: controller.sellerActions1,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          )),
    );
  }
}
