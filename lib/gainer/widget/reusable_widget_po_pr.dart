//reusable widget for making order container
import 'package:flutter/material.dart';
import '../../main.dart';
import '../screens/colors.dart';
Widget customOderContainer(String text, Color color) {
  return Container(
    height: 49,
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      // padding: EdgeInsets.all(mq.width*.02),
      child: Text(text),
    ),
  );
}

Widget customSearchBar(String hintText,TextEditingController controller,VoidCallback onSearch) {
  return Column(
    children: [
      SizedBox(height: mq.height * .02),
      SearchBar(
        controller: controller,
        hintText: hintText,
      // backgroundColor: WidgetStatePropertyAll(AppColor.primaryShade),
        trailing: [
          IconButton(
              highlightColor: Colors.black12,
              onPressed: onSearch,
              icon: Icon(
                Icons.search,
                color: AppColor.primary,
              ))
        ],
      ),
    ],
  );
}
