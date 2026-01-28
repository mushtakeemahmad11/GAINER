import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/input_formatters.dart';
import '../../../../core/widgets/gainer_text_form_field.dart';
import '../update_po_controller.dart';

class PoSearchBar extends GetView<UpdatePoController> {
  const PoSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GainerTextFormField(
        hint: 'Search by Part number\\Dealer Name',
        controller: controller.searchController,
        inputFormatters: [GainerInputFormatters.alphaNumericWithSpace],
        onChanged: (value) => controller.onSearch(value),
        suffixIcon: IconButton(
            onPressed: controller.clearSearchBar, icon: Icon(Icons.clear)),
      ),
    );
  }
}
