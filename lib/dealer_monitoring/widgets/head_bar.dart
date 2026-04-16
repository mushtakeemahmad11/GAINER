import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class HeadBar extends StatelessWidget {
  final String text;
  final String imgSting;
  final Widget? refresh;
  const HeadBar(
      {super.key, required this.text, required this.imgSting, this.refresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DMAppColors.secondary,
      padding: EdgeInsets.all(12),
      width: double.infinity,
      child: Row(
        children: [
          Image.asset(
            imgSting,
            width: 40,
            color: (text.startsWith("Substitution") || text.startsWith("PPNI"))
                ? Colors.white
                : null, // desired color
          ),
          SizedBox(width: 20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (refresh != null) refresh!,

          // SizedBox(
          //     height: 40,
          //     child: Center(
          //         child: IconButton(
          //       onPressed: () {},
          //       icon: Icon(Icons.refresh),
          //     ))),
        ],
      ),
    );
  }
}
