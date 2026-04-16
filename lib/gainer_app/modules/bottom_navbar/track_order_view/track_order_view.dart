import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/error_text.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_primary_button.dart';
import 'package:get/get.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../core/widgets/gainer_text_form_field.dart';
import '../home_view/home_controller.dart';

class TrackOrderView extends GetView<HomeController> {
  const TrackOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Column(
        children: [
          const Text(
            'You can track your order by using dispatch order number',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          Obx(() {
            final err = controller.trackErr;
            if (err.value != null) return AppErrorText(error: err);
            return const SizedBox.shrink();
          }),
          _searchBar(),
          Obx(() {
            if (controller.trackSearchText.value.isNotEmpty) {
              return GainerPrimaryButton(
                onPressed: controller.trackOrder,
                title: 'Check',
                isLoading: controller.isTracking.value,
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GainerTextFormField(
        hint: 'Enter Dispatch Order Number',
        maxLength: 10,
        controller: controller.trackOrderCtrl,
        keyboardType: TextInputType.number,
        // inputFormatters: [
        //   FilteringTextInputFormatter.digitsOnly,
        // ],
        inputFormatters: [GainerInputFormatters.numbersOnly],
        onChanged: (value) => controller.onChangedTrackOrder(value),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Obx(
          () => controller.trackSearchText.value.isNotEmpty
              ? IconButton(
                  onPressed: controller.trackClearSearchBar,
                  icon: const Icon(Icons.clear))
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
