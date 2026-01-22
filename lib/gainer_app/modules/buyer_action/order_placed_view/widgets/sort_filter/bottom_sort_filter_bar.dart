import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/buyer_action/order_placed_view/widgets/sort_filter/sort_bottom_sheet.dart';

import '../../../../../core/constants/gainer_color.dart';

class BottomSortFilterBar extends StatelessWidget {
  const BottomSortFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        // color: Colors.white70,
        color: GainerColors.lightWhite,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => showSortBottomSheet(context),
              child: SizedBox.expand(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.swap_vert,
                      color: Colors.black,
                    ),
                    SizedBox(width: 6),
                    Text("SORT"),
                  ],
                ),
              ),
            ),
          ),
          VerticalDivider(width: 1),
          Expanded(
            child: InkWell(
              onTap: () {
                // showSortBottomSheet(context);
                print('Tap on Filter');
              },
              child: SizedBox.expand(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(width: 6),
                    Text("FILTER"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
