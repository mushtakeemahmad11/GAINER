import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/gainer_main/widgets/action_card.dart';
import 'package:gainer/gainer_app/modules/gainer_main/widgets/summary_card.dart';
import 'package:get/get.dart';
import '../../core/constants/gainer_color.dart';
import 'gainer_main_controller.dart';

class GainerMainView extends GetView<GainerMainController> {
  const GainerMainView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GainerColors.background,
      appBar: AppBar(
        backgroundColor: GainerColors.primary,
        title: const Text('Home'),
        actions: const [
          Icon(Icons.notifications),
          SizedBox(width: 12),
          Icon(Icons.settings),
          SizedBox(width: 12),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Track Order"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Part Request"),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Location
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: "Location"),
              items: const [],
              onChanged: (v) {},
            ),

            const SizedBox(height: 12),

            /// Search
            const Text("Search your Part",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter Part No",
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 16),
            const SummaryCard(),

            const SizedBox(height: 20),

            /// Brand
            Column(
              children: const [
                Text("SPARECARE",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text("The Caring Experts"),
              ],
            ),

            const SizedBox(height: 20),

            /// Actions
            const Text("What would you like to do today?",
                style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            /// Buyer
            const Text("Action as a Buyer"),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: const [
                ActionCard(
                  title: "Order Placed",
                  subtitle: "6 orders | 10.13 Lac",
                  status: "Action Pending Since Jan 01, 26",
                  color: GainerColors.buyer,
                ),
                ActionCard(
                  title: "Update PO Details",
                  subtitle: "3 orders | 3.22 Lac",
                  status: "Action Pending Since Jan 01, 26",
                  color: GainerColors.buyer,
                ),
                ActionCard(
                  title: "Part Receipt",
                  subtitle: "8 orders | 13.45 Lac",
                  status: "Action Pending Since Jan 01, 26",
                  color: GainerColors.buyer,
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Seller
            const Text("Action as a Seller"),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: const [
                ActionCard(
                  title: "Order Receive",
                  subtitle: "4 orders | 0.22 Lac",
                  status: "Action Pending Since Jan 01, 26",
                  color: GainerColors.seller,
                ),
                ActionCard(
                  title: "Manifestation",
                  subtitle: "4 orders | 0.06 Lac",
                  status: "Action Pending Since Jan 01, 26",
                  color: GainerColors.seller,
                ),
                ActionCard(
                  title: "Dispatch Details",
                  subtitle: "4 orders | 0.13 Lac",
                  status: "Action Pending Since Jan 01, 26",
                  color: GainerColors.seller,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
