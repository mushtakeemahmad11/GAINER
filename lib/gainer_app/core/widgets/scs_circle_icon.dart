import 'package:flutter/cupertino.dart';

import '../constants/gainer_image.dart';

class ScsCircleIcon extends StatelessWidget {
  const ScsCircleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Image.asset(GainerImages.scsCircle, height: 30),
    );
  }
}
