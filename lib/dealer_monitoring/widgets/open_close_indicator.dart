import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/utils/dm_images.dart';

import '../../main.dart';

class OpenCloseIndicator extends StatelessWidget {
  const OpenCloseIndicator({super.key});

  Widget _legendItem(Color color, String label, imgUrl) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imgUrl, height: 25),
        Icon(Icons.square, color: color),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mq.width,
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        // spacing: 10,
        // runSpacing: 10,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem(Colors.black45, "Job Card Open",DMImages.jobCardOpen),
          _legendItem(Colors.black12, "Job Card Closed",DMImages.jobCardClose),
        ],
      ),
    );
  }
}
