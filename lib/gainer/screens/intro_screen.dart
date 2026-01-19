import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_navigate.dart';
import '../../main.dart';
import '../shared_preferences/shared_preferences_get_data.dart';
import '../shared_preferences/shared_preferences_set_data.dart';
import 'colors.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _checkIfFirstTime();
  }

  // Check if it's the first time the user is logging in
  _checkIfFirstTime() async {
    bool isFirstTime = await getBoolData('isFirstTime') ?? true;

    if (!isFirstTime) {
      // if (false) {
      // If it's not the first time, skip intro and navigate to the main screen
      _skipIntro();
    } else {
      // Mark as seen and set the flag to false
      setBoolData('isFirstTime', false);
    }
  }

  // // Navigate to the main screen
  // _navigateToMainScreen() {
  //   Get.offAll(() => MainScreen());
  // }

  // Skip the intro and go directly to the main screen
  _skipIntro() {
    Get.offAll(() => AppLauncherScreen());
  }

  // // Go to the next page
  // _nextPage() {
  //   if (_currentPage < 3) {
  //     _pageController.nextPage(
  //         duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  //   } else {
  //     _navigateToMainScreen();
  //   }
  // }

  // _previousPage() {
  //   if (_currentPage > 0) {
  //     _pageController.previousPage(
  //         duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Add a gradient background for a smooth look
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.primary, AppColor.secondary],
                // colors: [AppColor.primary, AppColor.primaryShade],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() => _currentPage = page);
            },
            children: [
              _buildIntroPage(
                  "Welcome to Gainer app!",
                  "Your ultimate platform for buying and selling parts.\n"
                      "• Buyers: Request and browse parts.\n"
                      "• Sellers: Respond to requests and fulfill orders.\n"
                      "• Dual-Role Users: Enjoy both buying and selling in one place!\n\n"
                      "Let’s get started and make the most of Gainer!"),
              _buildIntroPage(
                  "Welcome to Dealer Monitoring!",
                  "Your all-in-one platform for smarter inventory management.\n"
                      "• SIMS: Audit stock across locations with real-time visibility.\n"
                      "• PPNI: Track parts procured but not issued, advisor-wise & location-wise.\n"
                      "• Insights: Access substitution checks, sales trends, and vehicle/job card data.\n\n"
                      "Streamline operations and take full control of your dealership performance!"),
              _buildIntroPage(
                  "One Platform, Endless Possibilities!",
                  "Whether you’re managing inventory or liquidating dead stock,\n"
                      "our apps give you the power to:\n"
                      "• Simplify operations with smart automation.\n"
                      "• Improve decision-making with real-time analytics.\n"
                      "• Enhance performance across your dealer network.\n\n"
                      "Let’s get started and transform the way you manage parts!"),
              // _buildIntroPage("Get started now!", "Slide 4 description"),
            ],
          ),
          // Skip Button with animation
          Positioned(
            top: 40,
            right: 20,
            child: AnimatedOpacity(
              opacity: _currentPage == 0 ? 1.0 : 0.5,
              duration: Duration(milliseconds: 300),
              child: TextButton(
                onPressed: _skipIntro,
                child: Text(_currentPage != 3 ? "Skip" : "Continue",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ),
          // if (_currentPage == 3)
          //   Positioned(
          //     bottom: 60,
          //     right: 20,
          //     child: AnimatedOpacity(
          //       opacity: _currentPage == 3 ? 1.0 : 0.0,
          //       duration: const Duration(milliseconds: 500),
          //       curve: Curves.easeInOut,
          //       child: TextButton(
          //         onPressed: _skipIntro,
          //         // child: Text("Skip",
          //         //     style: TextStyle(color: Colors.white, fontSize: 18)),
          //         child: Icon(
          //           Icons.arrow_right_alt,
          //           color: Colors.white,
          //           size: 30,
          //         ),
          //       ),
          //     ),
          //   ),

          // Navigation buttons (Previous and Next)
          // if (_currentPage > 0)
          //   Positioned(
          //     bottom: 40,
          //     left: 20,
          //     child: IconButton(
          //       onPressed: _previousPage,
          //       icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          //     ),
          //   ),
          // Positioned(
          //   bottom: 40,
          //   right: 20,
          //   child: IconButton(
          //     onPressed: _nextPage,
          //     icon: Icon(
          //       _currentPage < 3 ? Icons.arrow_forward : Icons.start,
          //       color: Colors.white,
          //       size: 30,
          //     ),
          //   ),
          // ),
          // Custom page indicators
          Positioned(
            bottom: 80,
            left: mq.width * 0.5 - 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 20 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColor.primary
                        : Colors.white54,
                    // : AppColor.primaryShade,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  // child: GestureDetector(
                  //   onTap: (){
                  //
                  //   },
                  //     child: Text("")),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Stack(
  //       children: [
  //         PageView(
  //           controller: _pageController,
  //           onPageChanged: (page) {
  //             setState(() {
  //               _currentPage = page;
  //             });
  //           },
  //           children: [
  //             _buildIntroPage("Welcome to our app!",
  //                 "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius turpis et commodo pharetra est eros."),
  //             _buildIntroPage(
  //                 "Explore new features!", "Slide 2 description here."),
  //             _buildIntroPage(
  //                 "Stay connected with us!", "Slide 3 description here."),
  //             _buildIntroPage("Get started now!", "Slide 4 description here."),
  //           ],
  //         ),
  //         Positioned(
  //           top: 40,
  //           right: 20,
  //           // child: ElevatedButton(
  //           //   onPressed: _skipIntro,
  //           //   child: Text("Skip"),
  //           // ),
  //           child: TextButton(
  //             onPressed: _skipIntro,
  //             child: Text("Skip"),
  //           ),
  //         ),
  //         if (_currentPage > 0)
  //           Positioned(
  //             bottom: 40,
  //             left: 20,
  //             // child: ElevatedButton(
  //             //   onPressed: _skipIntro,
  //             //   child: Text("Skip"),
  //             // ),
  //             child: IconButton(
  //                 onPressed: _previousPage,
  //                 icon: Icon(Icons.arrow_back,
  //                     color: AppColor.primary, size: 30)),
  //           ),
  //         Positioned(
  //           bottom: 40,
  //           right: 20,
  //           child: IconButton(
  //               onPressed: _nextPage,
  //               icon: Icon(
  //                 _currentPage < 3 ? Icons.arrow_forward : Icons.start,
  //                 color: AppColor.primary,
  //                 size: 30,
  //               ),
  //           ),
  //           // child: ElevatedButton(
  //           //   onPressed: _nextPage,
  //           //   child: Text(_currentPage < 3 ? "Next" : "Start"),
  //           // ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Helper function to create individual pages
  Widget _buildIntroPage(String title, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .1),
          child: Text(
            description,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
