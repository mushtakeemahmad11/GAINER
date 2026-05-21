import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/widgets/gainer_text_form_field.dart';
import '../dr_received_controller.dart';

class DrReceivedSearchBar extends GetView<DrReceivedController> {
  const DrReceivedSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GainerTextFormField(
        hint: 'Search by Part Number\\Dealer Name',
        controller: controller.searchController,
        inputFormatters: [GainerInputFormatters.alphaNumericWithSpace],
        onChanged: (value) => controller.onChangedSearch(value),
        prefixIcon: Icon(Icons.search),
        suffixIcon: Obx(
          () => controller.searchText.value.isNotEmpty
              ? IconButton(
                  onPressed: controller.clearSearchBar, icon: Icon(Icons.clear))
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}
