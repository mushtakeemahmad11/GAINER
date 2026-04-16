import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/widgets/gainer_text_form_field.dart';
import '../../../../core/widgets/part_suggestion_list.dart';
import '../home_controller.dart';
import 'location_dropdown.dart';

class LocationAndPartSearchCard extends GetView<HomeController> {
  const LocationAndPartSearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _boxDecoration(),
      padding: EdgeInsets.fromLTRB(12, 12, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(' Change You Location', style: TextStyle(color: Colors.black54)),
          LocationDropdown(c: controller),
          const SizedBox(height: 12),
          GainerTextFormField(
            // fillColor: Colors.white12,
            isPartSearch: true,
            hint: "Search Your Part", //0304ABH00181N
            controller: controller.searchController,
            inputFormatters: [PartNumberFormatter()],
            suffixIcon: IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                controller.onSearchPressed();
              },
              icon: Icon(Icons.search),
            ),
            onChanged: (val) => controller.onSearchChanged(val),
          ),
          _buildPartSuggestion(),

          Align(
            alignment: Alignment.topRight,
            child: Text(
              '*Multi part with , separated ',
              style: TextStyle(fontSize: 12, color: GainerColors.error),
            ),
          ),
        ],
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

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: GainerColors.primary,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
    );
  }
}
