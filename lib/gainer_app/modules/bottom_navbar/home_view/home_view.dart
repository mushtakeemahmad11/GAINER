import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/widgets/error_text.dart';
import 'package:get/get.dart';
import '../../main_view/widgets/action_section.dart';
import 'home_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'widgets/advertisment_slider.dart';
import 'widgets/part_search_bar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(HomeController());
    // Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        final location = await AuthService.getLocation();
        controller.onChangeLocation(location);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Obx(() {
          bool isLoading = controller.isStageDataLoad.value;
          final error = controller.err;
          final dummyData = controller.buyerActionsDummyData;
          final buyerData = controller.buyerActions;
          final sellerData = controller.sellerActions;
          return Skeletonizer(
            enabled: isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///---------------------
                // SizedBox(height: .5),
                LocationAndPartSearchCard(),
                const SizedBox(height: 10),
                AdvertisementSlider(),

                ///Need to remove dependency of Marque
                // MarqueWidget(
                //     fundBalance:
                //         int.tryParse(controller.funBalance.value) ?? 0),

                Center(
                  child: Card(
                    elevation: 4,
                    color: Colors.white70,
                    // margin: EdgeInsets.zero,
                    margin: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            // "What would you like to do today?",
                            "Awaited Action",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 1.5,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Skeletonizer(
                          enabled: isLoading,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ActionColumn(
                                  title: "As Buyer",
                                  headerColor: Colors.blue,
                                  items: isLoading ? dummyData : buyerData,
                                ),
                                const SizedBox(width: 8),
                                ActionColumn(
                                  title: "As Seller",
                                  headerColor: Colors.green,
                                  items: isLoading ? dummyData : sellerData,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (error.value != null)
                  Center(child: AppErrorText(error: error)),

                ///--------------------

                /*/// Location Dropdown
                SizedBox(height: 45, child: LocationDropdown(c: controller)),
                const SizedBox(height: 6),

                // /// Search Part Text Field
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: const Text(
                    "Search Your Part",
                    style: TextStyle(
                        fontSize: 14, decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 2),
                GainerTextFormField(
                  hint: "Enter Part Number", //0304ABH00181N
                  controller: controller.searchController,
                  inputFormatters: [PartNumberFormatter()],
                  suffixIcon: Obx(
                    () => controller.partSearchText.value.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              controller.onSearchPressed();
                            },
                            icon: Icon(Icons.search),
                          )
                        : SizedBox.shrink(),
                  ),
                  onChanged: (val) => controller.onSearchChanged(val),
                ),
                _buildPartSuggestion(),
                const SizedBox(height: 4),
                const BalanceCard(),

                /// SCS Logo
                Center(
                    child: Image.asset(AppImages.scsBlackLinear, height: 80)),
                const SizedBox(height: 2),

                /// Actions as buyer/Seller
                Center(
                  child: Card(
                    elevation: 4,
                    color: Colors.white70,
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        // const Padding(
                        //   padding: EdgeInsets.all(8),
                        //   child: Text(
                        //     "What would you like to do today?",
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.w500, fontSize: 16),
                        //   ),
                        // ),
                        Skeletonizer(
                          enabled: isLoading,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ActionColumn(
                                  // title: "Action as Buyer",
                                  title: "As Buyer",
                                  headerColor: Colors.blue,
                                  items: isLoading ? dummyData : buyerData,
                                  // items: controller.buyerActions,
                                ),
                                const SizedBox(width: 8),
                                ActionColumn(
                                  // title: "Action as Seller",
                                  title: "As Seller",
                                  headerColor: Colors.green,
                                  items: isLoading ? dummyData : sellerData,
                                  // items: controller.sellerActions,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (error.value != null)
                  Center(
                    child: Column(
                      children: [
                        AppErrorText(error: error),
                        // IconButton(
                        //   onPressed: controller.initWork,
                        //   icon: Icon(
                        //     Icons.rotate_left,
                        //     color: Colors.red,
                        //   ),
                        // ),
                      ],
                    ),
                  )*/
              ],
            ),
          );
        }),
      ),
    );
  }

  // Widget _buildPartSuggestion() {
  //   return Obx(() {
  //     return PartSuggestionList(
  //       isLoading: controller.partSearchLoading.value,
  //       suggestions: controller.partSuggestions.toList(),
  //       onTap: (selected) => controller.selectPartNumber(selected),
  //     );
  //   });
  // }
}
