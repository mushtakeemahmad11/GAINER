import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/constants/gainer_color.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_loader.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_primary_button.dart';
import 'package:gainer/gainer_app/modules/direct_request_view/tab_view/direct_req_tab/direct_request_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../core/constants/gainer_image.dart';
import '../../core/widgets/gainer_app_bar.dart';
import 'tab_view/direct_req_tab/direct_request_tab.dart';
import 'tab_view/scs_req_tab/scs_inform_tab.dart';

class DirectRequestTabBar extends StatelessWidget {
// class DirectRequestTabBar extends GetView<DirectRequestController> {
  const DirectRequestTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: GainerColors.primary,
          title: const Text('Direct Request'),
          titleTextStyle: TextStyle(fontSize: 18),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(GainerImages.scsCircle, height: 30),
            )
          ],
          bottom: TabBar(
            // labelColor: GainerColors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              // color: GainerColors.white,
              color: Color(0xFFF5F5F5),
              // color: GainerColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            indicatorPadding: EdgeInsetsGeometry.symmetric(horizontal: 10),
            // labelColor: Colors.white,
            labelColor: Colors.black,
            tabs: const <Widget>[
              Tab(text: 'Direct Request'),
              Tab(text: 'SCS Inform'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            DirectRequestTab(),
            ScsInform(),
          ],
        ),
      ),
    );
  }
}
