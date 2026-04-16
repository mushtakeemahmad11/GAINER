import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../constants/gainer_color.dart';

class GainerAppLoader extends StatelessWidget {
  final RxBool isLoading;

  const GainerAppLoader({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Obx(() => isLoading.value
        ? Container(
            color: Colors.black26,
            child: Center(
              child: CircularProgressIndicator(
                color: GainerColors.primary,
              ),
            ),
          )
        : const SizedBox.shrink());
  }
}
