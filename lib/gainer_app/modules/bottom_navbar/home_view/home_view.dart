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
    return RefreshIndicator(
      onRefresh: () async {
        final location = await AuthService.getLocation();
        controller.onChangeLocation(location);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Obx(() {
          bool isLoading = controller.isStageDataLoad.value;
          final error = controller.err;
          final dummyData = controller.actionsDummyData;
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
              ],
            ),
          );
        }),
      ),
    );
  }
}
