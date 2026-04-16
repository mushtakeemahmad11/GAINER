import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/input_formatters.dart';
import '../../../core/widgets/gainer_text_form_field.dart';
import '../part_request_controller.dart';

class PartRequestSearchBar extends GetView<PartRequestController> {
  const PartRequestSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GainerTextFormField(
        hint: 'Search by Dealer Name\\Seller Location',
        controller: controller.searchController,
        inputFormatters: [GainerInputFormatters.alphaNumericWithSpace],
        onChanged: (value) => controller.onSearch(value),
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
