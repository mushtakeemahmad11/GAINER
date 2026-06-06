import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';
import 'package:gainer/dealer_monitoring/core/utils/dm_images.dart';
import 'package:gainer/dealer_monitoring/widgets/head_bar.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_bar.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_primary_button.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_secondary_button.dart';
import '../../core/constants/gainer_color.dart';
import '../../core/utils/input_formatters.dart';
import '../../core/widgets/gainer_text_form_field.dart';
import '../../core/widgets/part_suggestion_list.dart';
import '../../routes/app_routes.dart';
import './widgets/pr_part_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../core/widgets/error_text.dart';
import '../../core/widgets/expansion_tile_skeleton.dart';
import './part_request_controller.dart';
import 'package:get/get.dart';
import 'widgets/search_bar.dart';
import 'widgets/tat_disc/tat_disc_row.dart';

class PartRequestView extends GetView<PartRequestController> {
  const PartRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDealer = controller.isFromDealer.value;
    final bool isDealerDirect = controller.isFromDealerDirect.value;
    final bool isAllowBuying = controller.isAllowBuying.value;
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: isDealer
            ? isDealerDirect
                ? null
                : AppBar(
                    backgroundColor: DMAppColors.secondary,
                    title: Text('Gainer Stock Check'),
                  )
            : GainerAppBar(title: 'Part Request'),
        body: Column(
          children: [
            if (isDealerDirect)
              HeadBar(text: 'Gainer Stock Check', imgSting: DMImages.gLogoW),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Column(
                  children: [
                    Obx(() => controller.partRequestList.isNotEmpty
                        ? const PartRequestSearchBar()
                        : const SizedBox.shrink()),
                    Obx(() {
                      final part = controller.partNo.value;
                      return part == null || part.isEmpty
                          ? GainerTextFormField(
                              hint: "Enter Part Number",
                              controller: controller.partSearchController,
                              onChanged: (val) =>
                                  controller.onSearchChanged(val),
                              inputFormatters: [PartNumberFormatter()],
                              suffixIcon: Obx(
                                () => controller.partSearchText.value.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          controller.onPartSearch();
                                        },
                                        icon: Icon(Icons.search),
                                      )
                                    : SizedBox.shrink(),
                              ),
                            )
                          : const SizedBox.shrink();
                    }),
                    _buildPartSuggestion(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return Skeletonizer(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 5,
                                itemBuilder: (_, index) {
                                  return ExpansionTileSkeleton();
                                },
                              ),
                            );
                          }
                          final err = controller.errorMsg;
                          if (err.value != null && err.value!.isNotEmpty) {
                            if (err.value!.startsWith('Part Not Available')) {
                              return Column(
                                children: [
                                  Center(child: AppErrorText(error: err)),
                                  if (isAllowBuying && Platform.isAndroid)
                                    GainerSecondaryButton(
                                      isAccepted: true,
                                      onTap: () =>
                                          Get.toNamed(Routes.DIRECTREQ),
                                      title: "Direct Request",
                                    ),
                                ],
                              );
                            }
                            return Center(child: AppErrorText(error: err));
                          }
                          // if (controller.filteredList.isEmpty) {
                          //   return const Center(child: Text("No Orders Found"));
                          // }

                          final int partLen = controller.partGroups.length;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: partLen,
                            itemBuilder: (_, index) {
                              return PRPartTile(
                                group: controller.partGroups[index],
                                totalPartLen: partLen,
                              );
                            },
                          );
                        }),
                      ),
                    ),
                    SafeArea(
                      child: Obx(
                        () => controller.partGroups.isNotEmpty
                            ? GainerPrimaryButton(
                                onPressed: controller.submitRequest,
                                title: 'Submit Request',
                                bgColor: isDealer
                                    ? DMAppColors.secondary
                                    : GainerColors.primary,
                              )
                            : const SizedBox.shrink(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(() => controller.partRequestList.isNotEmpty
            ? SafeArea(child: const TatDiscRow())
            : const SizedBox.shrink()),
      ),
    );
  }

  Widget _buildPartSuggestion() {
    return Obx(() {
      return PartSuggestionList(
        isLoading: controller.partSearchLoading.value,
        suggestions: controller.partSuggestions.toList(),
        onTap: (selected) => controller.selectPartNumber(selected),
      );
    });
  }
}
