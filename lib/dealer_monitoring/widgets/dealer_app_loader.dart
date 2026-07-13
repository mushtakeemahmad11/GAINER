import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';

class DealerAppLoader extends StatelessWidget {
  final Color color;
  const DealerAppLoader({super.key, this.color = DMAppColors.secondary});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isIOS
          ? CircularProgressIndicator.adaptive(backgroundColor: color)
          : CircularProgressIndicator(color: color),
    );
  }
}
