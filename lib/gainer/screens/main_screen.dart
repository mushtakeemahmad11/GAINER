import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../apis_functionality/api_service.dart';
import '../apis_functionality/firebase_notification_service.dart';
import '../controllers/check_internet/connectivity_controller.dart';
import '../controllers/check_internet/no_internet_screen.dart';
import '../controllers/notification_controller.dart';
import '../controllers/profile_screen_controller.dart';
import '../controllers/user_details/user_controller.dart';
import '../shared_preferences/shared_preferences_get_data.dart';
import '../shared_preferences/shared_preferences_remove_data.dart';
import '../shared_preferences/shared_preferences_set_data.dart';
import '../utility/check_session.dart';
import '../widget/dialog.dart';
import '../widget/profile_widget.dart';
import '../widget/reusable_widget.dart';
import 'bottombar_screen/help_screen.dart';
import 'bottombar_screen/home_screen.dart';
import 'bottombar_screen/part_request/part_request.dart';
import 'bottombar_screen/profile_screen.dart';
import 'bottombar_screen/track_order_screen.dart';
import 'colors.dart';
import 'login_screen.dart';
import 'notification_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final ConnectivityController _connectivityController =
      Get.put(ConnectivityController());
  final ProfileScreenController _profileScreenController =
      Get.put(ProfileScreenController());
  final NotificationController _notificationController =
      Get.put(NotificationController());

  // List of screen names to be displayed in AppBar
  final List<String> screenName = [
    'Part Request',
    'Track Order',
    'Home',
    'Help',
    'Profile'
  ];

  // Variable to keep track of the selected screen index
  int _selectedIndex = 2;

  // UserController to manage user-related data with GetX
  final UserController userController = Get.put(UserController());

  // User's first and last name variables to be used in the drawer header
  String? _firstName;
  String? _lastName;
  String? userImage;

  File? _image;
  String? photo;

  // make instance of Notification class
  NotificationServices notificationServices = NotificationServices();

  // List of screens to be displayed based on the selected index
  final List<Widget> _widgetOptions = [
    // SelectionArea(child: PartRequestScreen()), // for copy the text
    PartRequestScreen(),
    const TrackOrderScreen(),
    const HomeScreen(),
    const HelpScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // _connectivityController.initConnectivity();
    //request call for notification
    // notificationServices.requestNotificationPermission();

    // ever<bool>(_connectivityController.isConnected, (isConnected) {
    //   if (!isConnected) {
    //     _connectivityController.initConnectivity();
    //   }
    // });
    _getUserData(); // Fetch user data on initialization
    WidgetsBinding.instance.addObserver(this);
    _checkSession();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //   _checkSession();
  // }

  Future<void> _checkSession() async {
    if (await isSessionExpired()) {
      int tCode = await getIntData("tCode");
      String userId = await getStringData('UserID');
      String deviceToken = await getStringData("deviceToken");
      final isSuccess = await ApiService().logoutContinue(
        empId: tCode.toString(),
        userId: userId.toString(),
        deviceToken: deviceToken.toString(),
        logoutType: 'SessionExpired',
      );
      if (isSuccess) {
        await setBoolData('isLogin', false);
        await removeData('tCode');
        await removeData('userProfile');
        Get.offAll(() => const LoginScreen());
      }
      // Do logout
      // await logoutUser(); // Your custom logout logic
      // Get.offAllNamed('/login'); // Navigate to login
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkSession();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Method to handle the navigation item tapped
  void _onItemTapped(int index) async {
    // setState(() => _selectedIndex = index);
    // Check connectivity before navigating.
    // await _connectivityController.initConnectivity();

    if (_connectivityController.isConnected.value) {
      // If connected, update the selected index to navigate normally.
      setState(() => _selectedIndex = index);
    } else {
      // If not connected, navigate to NoInternetScreen or show a message.
      Get.to(() => NoInternetScreen());
    }
  }

  // Method to handle back press functionality with specific conditions
  void _handleBackPressed(bool isTopRoute, dynamic result) {
    if (_selectedIndex != 2) {
      setState(() => _selectedIndex = 2);
    } else {
      Navigator.maybePop(context, result);
    }
  }

  // Method to get the user's first and last name from shared preferences
  _getUserData() async {
    // Initialize connectivity checking
    await notificationServices.getFirebaseMessagingToken();
    await notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    // await notificationServices.setUpInteractMessage(context); //comment

    _firstName = await getStringData('firstName');
    _lastName = await getStringData('lastName');
    userImage = await getStringData('userProfile');
    photo = await getStringData('photo');
    setState(() {
      if (userImage != null) {
        _image = File(_profileScreenController.imagePath.value ?? userImage!);
      }
    }); // Refresh the UI after fetching user data
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 2, // Only allow pop if on the app_switcher_view screen
      onPopInvokedWithResult:
          _handleBackPressed, // Handle back press functionality
      child: Scaffold(
        // AppBar with dynamic title based on selected screen
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                screenName[_selectedIndex],
                style: const TextStyle(color: Colors.white),
              ),
              // Spacer(),


              Obx(() {
                final unseenCount = _notificationController.notifications
                    .where((n) => n.isSeen == false)
                    .length;
                return Badge(
                  offset: Offset(2, 1),
                  isLabelVisible: unseenCount < 1 ? false : true,
                  label: Text(
                    unseenCount.toString(),
                    style: TextStyle(
                      fontSize: 12, // ↓ smaller font size
                    ),
                  ),
                  largeSize: 25,
                  child: IconButton(
                      onPressed: () async {
                        String selectedLocationID =
                            await getStringData("selectedLocationID");
                        Get.to(() => NotificationScreen(
                              selectedLocationID: selectedLocationID,
                            ));
                      },
                      icon: Icon(Icons.notifications)),
                );
              })
            ],
          ),
          backgroundColor: AppColor.primary,
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        // Drawer for navigation and user profile details
        drawer: Drawer(
          width: mq.width * .80,
          backgroundColor: AppColor.primary,
          child: Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 26,
                      child: _profileScreenController.imagePath.value == null
                          ? reusableProfile(_image, photo)
                          : Obx(() => reusableProfile(
                              File(_profileScreenController.imagePath.value!),
                              photo)),
                    ),
                    title: SingleChildScrollView(
                      child: Text(
                        '$_firstName $_lastName', // Displaying user's name
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      Get.back();
                      _onItemTapped(4);
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    // Home option in the drawer
                    CustomListTile(
                      icon: Icons.home,
                      onTap: () {
                        Navigator.pop(context);
                        _onItemTapped(2); // Navigate to Home screen
                      },
                      title: "Home Section",
                    ),

                    // Part Request option in the drawer
                    CustomListTile(
                      icon: Icons.trolley,
                      onTap: () {
                        Navigator.pop(context);
                        _onItemTapped(0); // Navigate to Home screen
                      },
                      title: "Part Request",
                    ),

                    CustomListTile(
                      icon: Icons.home,
                      onTap: () {
                        Navigator.pop(context);
                        _onItemTapped(1); // Navigate to Home screen
                      },
                      title: "Track Order",
                    ),

                    CustomListTile(
                      icon: Icons.help,
                      onTap: () {
                        Navigator.pop(context);
                        _onItemTapped(3); // Navigate to Home screen
                      },
                      title: "Help Section",
                    ),

                    CustomListTile(
                      icon: Icons.account_circle,
                      onTap: () {
                        Navigator.pop(context);
                        _onItemTapped(4); // Navigate to Home screen
                      },
                      title: "Profile Section",
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width * .1),
                    child: Column(
                      children: [
                        // Logout button in the drawer
                        CustomOutlinedButton(
                            icon: Icons.logout,
                            onPressed: () {
                              AppDialog.logoutBtnFunctionality(); // Handle logout functionality
                            }),
                        const Text('Logout',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height:
                      mq.height * .02), // Spacer at the bottom of the drawer
            ],
          ),
        ),

        // Body content based on selected screen
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
        // body: Center(
        //     child: _connectivityController.isConnected.value
        //         ? _widgetOptions.elementAt(_selectedIndex)
        //         : NoInternetScreen()),

        // Bottom navigation bar for screen selection
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          // unselectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          // selectedItemColor: Colors.white,
          selectedItemColor: Colors.black,
          backgroundColor: AppColor.primary,
          currentIndex: _selectedIndex,
          onTap:
              _onItemTapped, // Update the selected index when an item is tapped
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.trolley), label: 'Part Req'),
            BottomNavigationBarItem(
                icon: Icon(Icons.auto_graph), label: 'Track Order'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Help'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'Profile'),
          ],
        ),
      ),
    );
    // return Obx(() {
    //   return _connectivityController.isConnected.value
    //       ? PopScope(
    //           canPop:
    //               _selectedIndex == 2, // Only allow pop if on the app_switcher_view screen
    //           onPopInvokedWithResult:
    //               _handleBackPressed, // Handle back press functionality
    //           child: Scaffold(
    //             // AppBar with dynamic title based on selected screen
    //             appBar: AppBar(
    //               title: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     screenName[_selectedIndex],
    //                     style: const TextStyle(color: Colors.white),
    //                   ),
    //                   // Spacer(),
    //                   Obx(() {
    //                     final unseenCount = _notificationController
    //                         .notifications
    //                         .where((n) => n.isSeen == false)
    //                         .length;
    //                     return Badge(
    //                       offset: Offset(2, 1),
    //                       isLabelVisible: unseenCount < 1 ? false : true,
    //                       label: Text(
    //                         unseenCount.toString(),
    //                         style: TextStyle(
    //                           fontSize: 12, // ↓ smaller font size
    //                         ),
    //                       ),
    //                       largeSize: 25,
    //                       child: IconButton(
    //                           onPressed: () async {
    //                             String selectedLocationID =
    //                                 await getStringData("selectedLocationID");
    //                             Get.to(() => NotificationScreen(
    //                                   selectedLocationID: selectedLocationID,
    //                                 ));
    //                           },
    //                           icon: Icon(Icons.notifications)),
    //                     );
    //                   })
    //                 ],
    //               ),
    //               backgroundColor: AppColor.primary,
    //               iconTheme: const IconThemeData(color: Colors.white),
    //             ),
    //
    //             // Drawer for navigation and user profile details
    //             drawer: Drawer(
    //               width: mq.width * .80,
    //               backgroundColor: AppColor.primary,
    //               child: Column(
    //                 children: [
    //                   DrawerHeader(
    //                     child: Center(
    //                       child: ListTile(
    //                         leading: CircleAvatar(
    //                           radius: 26,
    //                           child: _profileScreenController.imagePath.value ==
    //                                   null
    //                               ? reusableProfile(_image, photo)
    //                               : Obx(() => reusableProfile(
    //                                   File(_profileScreenController
    //                                       .imagePath.value!),
    //                                   photo)),
    //                         ),
    //                         title: SingleChildScrollView(
    //                           child: Text(
    //                             '$_firstName $_lastName', // Displaying user's name
    //                             style: const TextStyle(color: Colors.white),
    //                           ),
    //                         ),
    //                         onTap: () {
    //                           Get.back();
    //                           _onItemTapped(4);
    //                         },
    //                       ),
    //                     ),
    //                   ),
    //                   Expanded(
    //                     child: ListView(
    //                       children: [
    //                         // Home option in the drawer
    //                         CustomListTile(
    //                           icon: Icons.app_switcher_view,
    //                           onTap: () {
    //                             Navigator.pop(context);
    //                             _onItemTapped(2); // Navigate to Home screen
    //                           },
    //                           title: "Home Section",
    //                         ),
    //
    //                         // Part Request option in the drawer
    //                         CustomListTile(
    //                           icon: Icons.trolley,
    //                           onTap: () {
    //                             Navigator.pop(context);
    //                             _onItemTapped(0); // Navigate to Home screen
    //                           },
    //                           title: "Part Request",
    //                         ),
    //
    //                         CustomListTile(
    //                           icon: Icons.app_switcher_view,
    //                           onTap: () {
    //                             Navigator.pop(context);
    //                             _onItemTapped(1); // Navigate to Home screen
    //                           },
    //                           title: "Track Order",
    //                         ),
    //
    //                         CustomListTile(
    //                           icon: Icons.help,
    //                           onTap: () {
    //                             Navigator.pop(context);
    //                             _onItemTapped(3); // Navigate to Home screen
    //                           },
    //                           title: "Help Section",
    //                         ),
    //
    //                         CustomListTile(
    //                           icon: Icons.account_circle,
    //                           onTap: () {
    //                             Navigator.pop(context);
    //                             _onItemTapped(4); // Navigate to Home screen
    //                           },
    //                           title: "Profile Section",
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.end,
    //                     children: [
    //                       Padding(
    //                         padding:
    //                             EdgeInsets.symmetric(horizontal: mq.width * .1),
    //                         child: Column(
    //                           children: [
    //                             // Logout button in the drawer
    //                             CustomOutlinedButton(
    //                                 icon: Icons.logout,
    //                                 onPressed: () {
    //                                   AppDialog.logoutBtnFunctionality(); // Handle logout functionality
    //                                 }),
    //                             const Text('Logout',
    //                                 style: TextStyle(color: Colors.white)),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                       height: mq.height *
    //                           .02), // Spacer at the bottom of the drawer
    //                 ],
    //               ),
    //             ),
    //
    //             // Body content based on selected screen
    //             body: Center(
    //                 child: _connectivityController.isConnected.value
    //                     ? _widgetOptions.elementAt(_selectedIndex)
    //                     : NoInternetScreen()),
    //
    //             // Bottom navigation bar for screen selection
    //             bottomNavigationBar: BottomNavigationBar(
    //               type: BottomNavigationBarType.fixed,
    //               // unselectedItemColor: Colors.black,
    //               unselectedItemColor: Colors.white,
    //               // selectedItemColor: Colors.white,
    //               selectedItemColor: Colors.black,
    //               backgroundColor: AppColor.primary,
    //               currentIndex: _selectedIndex,
    //               onTap:
    //                   _onItemTapped, // Update the selected index when an item is tapped
    //               items: const [
    //                 BottomNavigationBarItem(
    //                     icon: Icon(Icons.trolley), label: 'Part Req'),
    //                 BottomNavigationBarItem(
    //                     icon: Icon(Icons.auto_graph), label: 'Track Order'),
    //                 BottomNavigationBarItem(
    //                     icon: Icon(Icons.app_switcher_view), label: 'Home'),
    //                 BottomNavigationBarItem(
    //                     icon: Icon(Icons.help), label: 'Help'),
    //                 BottomNavigationBarItem(
    //                     icon: Icon(Icons.account_circle), label: 'Profile'),
    //               ],
    //             ),
    //           ),
    //         )
    //       : NoInternetScreen();
    // });
  }
}
