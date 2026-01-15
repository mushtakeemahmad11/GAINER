import 'package:flutter/material.dart';
import 'package:gainer/scanapp/screens/pi_audit/by_part_tab_screen.dart';
import 'package:gainer/scanapp/screens/pi_audit/pi_generic_tab_screen.dart';
import '../../core/themes/scanapp_colors.dart';
import '../location_audit/camera_tab.dart';

class PIAuditScreen extends StatefulWidget {
  const PIAuditScreen({super.key});

  @override
  State<PIAuditScreen> createState() => _PIAuditScreenState();
}

class _PIAuditScreenState extends State<PIAuditScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Perpetual Inventory Audit (PIA)"),
          backgroundColor: ScanappColors.primary,
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            TabBar(
              unselectedLabelColor: ScanappColors.black,
              tabs: [
                Tab(text: "By Parts"),
                Tab(text: "Generic"),
                Tab(
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    size: 35,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  const ByPartTab(),
                  const PIGenericTab(),
                  const CameraScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
