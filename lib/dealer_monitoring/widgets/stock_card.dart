import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';
import 'package:gainer/dealer_monitoring/widgets/animated_drop_icon.dart';

class OldPartStockCard extends StatefulWidget {
  final String partNumber, description, category, colorType;
  final int rate, stockQty, reservedQty, groupStock;
  final List<Map<String, dynamic>> locations;

  const OldPartStockCard({
    super.key,
    required this.partNumber,
    required this.description,
    required this.category,
    required this.colorType,
    required this.rate,
    required this.stockQty,
    required this.reservedQty,
    required this.groupStock,
    required this.locations,
  });

  @override
  State<OldPartStockCard> createState() => _OldPartStockCardState();
}

class _OldPartStockCardState extends State<OldPartStockCard>
    with SingleTickerProviderStateMixin {
  bool showDetails = false;

  Color getColor(String type) {
    switch (type) {
      case 'Stockable':
        return DMAppColors.stockable;
      case 'Non-Stockable':
        return DMAppColors.nonStockable;
      case 'Non-Moving':
        return DMAppColors.nonMoving;
      default:
        // return Colors.grey.shade200;
        return Colors.grey.shade300;
    }
  }

  Widget _buildInfoRow(
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child:
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: getColor(widget.colorType),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("Part Number:", widget.partNumber),
                _buildInfoRow("Part Description:", widget.description),
                _buildInfoRow("Part Category:", widget.category),
                _buildInfoRow("Part Rate:", widget.rate.toString()),
                _buildInfoRow("Stock Qty:", widget.stockQty.toString()),

                /// 🟢 Reserved & Group Stock with Toggle Button in one Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column with labels
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Reserved for vehicle:",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          Text("Group Stock:",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),

                    // Right column with values and toggle button
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.reservedQty.toString()),
                                Text(widget.groupStock.toString()),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                showDetails = !showDetails;
                              });
                            },
                            icon: AnimatedDropIcon(isTrue: showDetails),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        /// 🟡 Animated dropdown: sub-stock locations
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: showDetails
                ? (widget.locations.isNotEmpty)
                    ? Column(
                        children: widget.locations.map((stock) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: getColor(stock['type']),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 3,
                                    offset: Offset(0,
                                        2), // horizontal, vertical shadow offset
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(stock['location'])),
                                  Text("Qty: ${stock['qty']}"),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : Text("Group Data not available")
                : const SizedBox.shrink(),
          ),
        )
      ],
    );
  }
}
