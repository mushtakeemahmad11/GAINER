import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../core/constants/gainer_color.dart';
import '../home_controller.dart';

/// 🔹 ADVERTISEMENT SLIDER
class AdvertisementSlider extends StatelessWidget {
  const AdvertisementSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 🔹 SLIDER
        CarouselSlider.builder(
          itemCount: controller.ads.length,
          itemBuilder: (context, index, _) {
            final ad = controller.ads[index];
            //can wrap with inkwell if need to onTap functionality
            return AdImageCard(image: ad.image);
          },
          options: CarouselOptions(
            height: 190,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 1,
            enableInfiniteScroll: true,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) =>
                controller.currentAdIndex.value = index,
          ),
        ),

        const SizedBox(height: 8),

        /// 🔹 DOT INDICATOR
        Obx(
          () => CarouselIndicator(
            length: controller.ads.length,
            currentIndex: controller.currentAdIndex.value,
          ),
        ),
      ],
    );
  }
}

/// 🔹 REUSABLE AD IMAGE CARD
class AdImageCard extends StatelessWidget {
  final String image;
  // final String title;

  const AdImageCard({
    super.key,
    required this.image,
    // required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Colors.redAccent
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withAlpha(45),
          //     blurRadius: 10,
          //     offset: const Offset(0, 6),
          //   ),
          // ],
          ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          image,
          fit: BoxFit.fill,
          // fit: BoxFit.cover,
        ),
        // child: Stack(
        //   fit: StackFit.expand,
        //   children: [
        //     Image.asset(
        //       image,
        //       fit: BoxFit.cover,
        //     ),
        //
        //     /// Gradient Overlay
        //     Container(
        //       decoration: const BoxDecoration(
        //         gradient: LinearGradient(
        //           begin: Alignment.bottomCenter,
        //           end: Alignment.topCenter,
        //           colors: [
        //             Color(0xCC000000),
        //             Colors.transparent,
        //           ],
        //         ),
        //       ),
        //     ),
        //
        //     /// Title
        //     Positioned(
        //       left: 14,
        //       right: 14,
        //       bottom: 14,
        //       child: Text(
        //         title,
        //         maxLines: 2,
        //         overflow: TextOverflow.ellipsis,
        //         style: const TextStyle(
        //           color: Colors.white,
        //           fontSize: 15,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

/// 🔹 iSlider Indicator Bottom the Slider Image
class CarouselIndicator extends StatelessWidget {
  final int length;
  final int currentIndex;

  const CarouselIndicator({
    super.key,
    required this.length,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final isActive = currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? GainerColors.primary : GainerColors.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}

/*
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/gainer_image.dart';

class AdvertisementSlider extends StatelessWidget {
  final List<Widget> ads = [
    adItem("⚡ Limited Offer – Get 10% Extra Wallet Credit"),
    adItem("🚚 Free Delivery on Orders Above ₹5000"),
    adItem("🔥 Hot Deals on Engine Parts Today"),
    adItem("📦 Fast Dispatch Available"),
    adItem("💰 Add Funds & Get Bonus Cashback"),
  ];

  final List<Widget> adsImg = [
    adItemWithImg(GainerImages.sliderBanner1,'Slider1'),
    adItemWithImg(GainerImages.sliderBanner2,'Slider2'),
    adItemWithImg(GainerImages.sliderBanner1,'Slider3'),
    adItemWithImg(GainerImages.sliderBanner2,'Slider4'),
  ];

  AdvertisementSlider({super.key});

  static Widget adItem(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      // decoration: BoxDecoration(
      //   color: Colors.blue.shade50,
      //   borderRadius: BorderRadius.circular(8),
      // ),
      // alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      // items: ads,
      items: adsImg.asMap().entries.map((entry) {
        int index = entry.key;
        Widget item = entry.value;

        return InkWell(
          onTap: () => handleAdTap(index),
          child: Container(
            alignment: Alignment.center,
            child: item,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        // height: 45,
        // height: 100,
        height: 190,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: false,
        viewportFraction: 1,
        enableInfiniteScroll: true,
      ),
    );
  }

  void handleAdTap(int index) {
    switch (index) {
      case 0:
        print("⚡ Limited Offer – Get 10% Extra Wallet Credit");
        // Get.to(AddFundsScreen());
        break;

      case 1:
        print("🚚 Free Delivery on Orders Above ₹5000");
        break;

      case 2:
        print("🔥 Hot Deals on Engine Parts Today");
        break;

      case 3:
        print("📦 Fast Dispatch Available");
        break;

      case 4:
        print("💰 Add Funds & Get Bonus Cashback");
        break;
    }
  }

  static Widget adItemWithImg(String image, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          // image: NetworkImage(image),
          // fit: BoxFit.cover,
          image: AssetImage(image),
          fit: BoxFit.fill,
        ),
      ),
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.5), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Text(
          text,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class AdvertisementSliderTest extends StatefulWidget {
  const AdvertisementSliderTest({super.key});

  @override
  State<AdvertisementSliderTest> createState() =>
      _AdvertisementSliderTestState();
}

class _AdvertisementSliderTestState extends State<AdvertisementSliderTest> {
  int currentIndex = 0;

  final List<Widget> ads = [
    adsItem("⚡ Limited Offer – Get 10% Extra Wallet Credit"),
    adsItem("🚚 Free Delivery on Orders Above ₹5000"),
    adsItem("🔥 Hot Deals on Engine Parts Today"),
    adsItem("📦 Fast Dispatch Available"),
    adsItem("💰 Add Funds & Get Bonus Cashback"),
  ];

  static Widget adsItem(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: ads,
          options: CarouselOptions(
            height: 50,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),

        const SizedBox(height: 6),

        /// Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ads.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: currentIndex == entry.key ? 16 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: currentIndex == entry.key
                    ? Colors.blue
                    : Colors.grey.shade400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
*/
