import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/screens/PPNI_list_view/workshop_manager_first_screen.dart';
import 'package:gainer/dealer_monitoring/screens/PPNI_list_view/general_manager_screen.dart';
import 'package:gainer/dealer_monitoring/screens/gainer_stock_check/gainer_part_req_view.dart';
import 'package:gainer/dealer_monitoring/screens/part_stock_check/part_stock_check_screen.dart';
import 'package:gainer/dealer_monitoring/screens/sale_trend/sale_trend_screen.dart';
import 'package:gainer/dealer_monitoring/screens/scs_norms_view/scs_norms_screen.dart';
import 'package:gainer/dealer_monitoring/screens/substitution_check/substitution_check_screen.dart';
import 'package:gainer/dealer_monitoring/screens/vehicle_search/vehicle_search_screen.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:get/get.dart';
import '../../app_switcher_view/app_switcher_controller.dart';
import '../../gainer_app/core/widgets/profile_circle.dart';
import '../controllers/dm_main_controller.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/dm_images.dart';
import '../widgets/dm_list_tile.dart';
import 'PPNI_list_view/workshop_advisor_screen.dart';
import 'gainer_listing/gainer_listing_screen.dart';
import 'order_information/order_info_screen.dart';

class DMMainScreen extends StatefulWidget {
  const DMMainScreen({super.key});

  @override
  State<DMMainScreen> createState() => _DMMainScreenState();
}

class _DMMainScreenState extends State<DMMainScreen> {
  DMMainController dMMainController = Get.put(DMMainController());
  final appSwitcherCtrl = Get.find<AppSwitcherController>();
  // final LocationController _locationController = Get.put(LocationController());

  final List<Widget> screens = [
    _HomeMenuGrid(), // 0: Home
    // 1+: Other screens
    // BinLocationCheckScreen(),
    PartStockCheckScreen(),
    // PartRequestView(),
    GainerPartReqView(),
    // GainerStockCheck(),
    SubstitutionCheckScreen(),
    Center(child: Text('PPNI List View Role Not Define')),
    VehicleSearchScreen(),
    SaleTrendScreen(),
    OrderInfoScreen(),
    ScsNormsScreen(),
    GainerListingScreen(),

    /// PPNI Screens
    GeneralManagerScreen(),
    WorkshopManagerFirstScreen(),
    WorkshopAdvisorScreen(),
  ];

  void _handleBackPressed(bool isTopRoute, dynamic result) {
    if (dMMainController.currentScreen.value != 0) {
      dMMainController.currentScreen.value = 0;
    } else {
      Navigator.maybePop(context, result);
    }
  }

  late Worker _worker;
  @override
  void initState() {
    super.initState();
    dMMainController.initWork();
    _worker = ever(appSwitcherCtrl.selectedLocationId, (value) {
      _onLocationChanged(value);
    });
  }

  void _onLocationChanged(String? location) {
    dMMainController.initWork();
  }

  @override
  void dispose() {
    _worker.dispose(); // Important!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMAppColors.surface,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: DMAppColors.primary,
        elevation: 0,
        title: Row(
          children: [
            /// DropdownButton with minimal width
            Obx(() {
              return DropdownButton<String>(
                value: appSwitcherCtrl.selectedLocation.value == ''
                    ? null
                    : appSwitcherCtrl.selectedLocation.value,
                hint: const Text('Location'),
                underline: SizedBox(),
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                items: appSwitcherCtrl.locationIdMap.keys.map((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key),
                  );
                }).toList(),
                onChanged: (String? newValue) async {
                  if (newValue != null) {
                    appSwitcherCtrl.selectedLocation.value = newValue;

                    String locationId =
                        appSwitcherCtrl.locationIdMap[newValue].toString();
                    appSwitcherCtrl.selectedLocationId.value = locationId;
                    // appSwitcherCtrl.updateStockDetails(locationId);
                    await AuthService.saveLocationId(locationId);
                    await AuthService.saveLocation(newValue);
                  }
                },
              );
            }),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.notifications_outlined),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      drawer: _buildDrawerButton(),
      // drawer: Drawer(child: ListView(children: [DrawerHeader(child: Text('Header')), ListTile(title: Text('Item'))])),

      body: Obx(() {
        return PopScope(
          canPop: dMMainController.currentScreen.value ==
              0, // Only allow pop if on the home screen
          onPopInvokedWithResult: _handleBackPressed,
          child: screens[dMMainController.currentScreen.value],
        );
      }),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: DMAppColors.secondary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.home_outlined, size: 35),
              onPressed: () {
                // Get.to(() => VehicleTestScreen());
                dMMainController.currentScreen.value = 0;
              },
            ),
            // //Dealer Name
            // Expanded(
            //   child: Center(
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       child: Text(
            //         _locationController.stockDetails['Dealer'] ?? 'Dealer Name',
            //         style: TextStyle(color: Colors.white,fontSize: 18),
            //         // overflow: TextOverflow.ellipsis,
            //       ),
            //     ),
            //   ),
            // ),
            IconButton(
              icon: Icon(Icons.logout_outlined, size: 35),
              // onPressed: () => AppDialog.logoutBtnFunctionality(),
              onPressed: () => AuthService.logout('UserLogoutSIMS'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerButton() {
    return Drawer(
      backgroundColor: DMAppColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            child: Center(
              child: Obx(
                () => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ProfileCircle(
                    size: 55,
                    pickedImg: dMMainController.pickedProfileImg.value,
                    apiImg: dMMainController.profileImage.value,
                  ),
                  title: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      dMMainController.name.value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  subtitle: Text(
                    dMMainController.userRole.value,
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _drawerItems(),
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text("version:  1.1", style: TextStyle(color: Colors.grey)),
          // ),
        ],
      ),
    );
  }

  List<Widget> _drawerItems() {
    return [
      _drawerTile(DMImages.partStockCheck, "Part Stock Check", 0),
      _drawerTile(DMImages.gLogoW, "Gainer Stock Check", 1),
      _drawerTile(DMImages.substitutionCheck, "Substitution Check", 2),
      _drawerTile(DMImages.ppniList, "PPNI List", 3),
      _drawerTile(DMImages.vehicleSearch, "Vehicle Search", 4),
      _drawerTile(DMImages.saleTrend, "Sale Trend", 5),
      _drawerTile(DMImages.orderInfo, "Order info", 6),
      _drawerTile(DMImages.scsNorms, "SCS Norms", 7),
      // _drawerTile(ConstantImages.gainerListening, "My Gainer Listing", 9),
    ];
  }

  Widget _drawerTile(String imageUrl, String title, int index) {
    return DmListTile(
      url: imageUrl,
      title: title,
      onTap: () {
        Get.back();
        dMMainController.goto(title, index);
      },
    );
  }
}

// class PartReqView extends StatelessWidget {
//   const PartReqView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     PartRequestBinding().dependencies();
//     return const PartRequestView();
//   }
// }

class _HomeMenuGrid extends StatelessWidget {
  final DMMainController controller = Get.find();

  // onRefresh: () => controller.initWork(),
  @override
  Widget build(BuildContext context) {
    final menuItems = controller.menuItems;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: DMAppColors.secondary,
            padding: EdgeInsets.all(12),
            width: double.infinity,
            child: Center(
                //28th April 2024
                child: Obx(
              () => Text(
                "Stock Uploaded on  ${controller.stockDate.value}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: menuItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (context, index) {
              final label = menuItems[index]['label'];
              return GestureDetector(
                onTap: () => controller.goto(label, index),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: DMAppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // child: Icon(menuItems[index]['icon'],
                      //     size: 30, color: Colors.black,
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          menuItems[index]['img'],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
