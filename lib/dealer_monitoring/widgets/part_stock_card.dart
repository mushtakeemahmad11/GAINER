import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';
import 'package:gainer/dealer_monitoring/widgets/animated_drop_icon.dart';

class PartStockCard extends StatefulWidget {
  final bool isGroupStock;
  final Map<String, dynamic> partDetails;
  // final String partNumber, description, category, colorType;
  // final int rate, stockQty, reservedQty, groupStock;
  final List<Map<String, dynamic>> locations;

  const PartStockCard({
    super.key,
    // required this.partNumber,
    // required this.description,
    // required this.category,
    // required this.colorType,
    // required this.rate,
    // required this.stockQty,
    // required this.reservedQty,
    // required this.groupStock,
    this.isGroupStock = false,
    required this.partDetails,
    required this.locations,
  });

  @override
  State<PartStockCard> createState() => _PartStockCardState();
}

class _PartStockCardState extends State<PartStockCard>
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
        return DMAppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.partDetails.entries.toList();
    final firstEntries = entries.sublist(1, entries.length - 2);
    final lastTwoEntries = entries.sublist(entries.length - 2);
    return Column(
      spacing: 1,
      children: [
        Card(
          color: getColor(widget.partDetails['ColorType'] ?? "null"),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildInfoRow("Part Number:", widget.partDetails['Part Number']),
                // _buildInfoRow("Part Description:", widget.partDetails['Part Number']),
                // _buildInfoRow("Part Category:", widget.partDetails['Part Number']),
                // _buildInfoRow("Part Rate:", widget.partDetails['Part Number']),
                // _buildInfoRow("Stock Qty:", widget.partDetails['Part Number']),

                ...firstEntries.map((entry) =>
                    InfoRow(label: entry.key, value: entry.value.toString())),

                /// 🟢 Reserved & Group Stock with Toggle Button in one Row
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     // Left column with labels
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         // children:  [
                //         //   Text("Reserved for vehicle:",
                //         //       style: TextStyle(fontWeight: FontWeight.w500)),
                //         //   Text("Group Stock:",
                //         //       style: TextStyle(fontWeight: FontWeight.w500)),
                //         // ],
                //         children: lastTwoEntries.map((entry) =>
                //             Expanded(
                //               // child: InfoRow(label: entry.key, value: entry.value.toString()),
                //               child:  Text(entry.key,
                //                   style: TextStyle(fontWeight: FontWeight.w500)),
                //             ),
                //         ).toList(),
                //       ),
                //     ),
                //
                //     // Right column with values and toggle button
                //     Expanded(
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Expanded(
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Text(widget.partDetails['Part Number']),
                //                 Text(widget.partDetails['Part Number']),
                //               ],
                //             ),
                //           ),
                //           IconButton(
                //             onPressed: () {
                //               setState(() {
                //                 showDetails = !showDetails;
                //               });
                //             },
                //             icon: AnimatedDropIcon(isTrue: showDetails),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),

                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //
                //   children: [
                //     // Left column with labels
                //     Expanded(
                //       child: Column(
                //         // crossAxisAlignment: CrossAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: lastTwoEntries
                //             .map(
                //               (entry) => Padding(
                //                 padding:
                //                     const EdgeInsets.symmetric(vertical: 2),
                //                 child: Text(
                //                   entry.key,
                //                   style: const TextStyle(
                //                       fontWeight: FontWeight.w500),
                //                 ),
                //               ),
                //             )
                //             .toList(),
                //       ),
                //     ),
                //
                //     // Right column with values
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Expanded(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: lastTwoEntries
                //                 .map(
                //                   (entry) => Padding(
                //                     padding:
                //                         const EdgeInsets.symmetric(vertical: 2),
                //                     child: Text(entry.value.toString()),
                //                   ),
                //                 )
                //                 .toList(),
                //           ),
                //         ),
                //       ],
                //     ),
                //     IconButton(
                //       onPressed: () {
                //         setState(() {
                //           showDetails = !showDetails;
                //         });
                //       },
                //       icon: AnimatedDropIcon(isTrue: showDetails),
                //     ),
                //   ],
                // ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column with labels
                    Expanded(
                      child: widget.isGroupStock
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(lastTwoEntries.first.key.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: lastTwoEntries
                                  .map(
                                    (entry) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Text(
                                        entry.key,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),

                    // Right column with values + toggle icon
                    Expanded(
                      child: widget.isGroupStock
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(lastTwoEntries.first.value.toString()),
                                  Text("(for 60 days)   "),
                                ],
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Values column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: lastTwoEntries
                                        .map(
                                          (entry) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2),
                                            // child: Text(entry.value.toString()),
                                            child:
                                                label(entry.value.toString()),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                // Toggle icon
                                _buildIconBtn(),
                              ],
                            ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

        //for only part stock check
        if (widget.isGroupStock)
          // GestureDetector(
          //   onTap: (){
          //     setState(() {
          //       showDetails = !showDetails;
          //     });
          //   },
          //   child:
          Card(
              margin: EdgeInsets.zero,
              // color: getColor(widget.partDetails['ColorType'] ?? "null"),
              color: DMAppColors.secondary,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lastTwoEntries.last.key,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lastTwoEntries.last.value.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            _buildIconBtn(isWhite: true)
                          ],
                        ),
                      ),
                    ]),
              )),
        // ),

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
                                color: getColor(stock['type'] ?? "null"),
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
                                spacing: 5,
                                children: [
                                  // LEFT 50% (location)
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined,
                                            color: Colors.black),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              stock['Location'] ?? "",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // RIGHT 50% (qty / stock date)
                                  stock['qty'] == null
                                      ? Text("${stock['Max']}   ")
                                      : Expanded(
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      minWidth:
                                                          constraints.maxWidth),
                                                  child: Row(
                                                    spacing: 5,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(stock['qty']
                                                          .toString()),
                                                      label(
                                                          "!500Stock Date!500  ${stock['stockdate']} "),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                ],
                              ),

                              // child: Row(
                              //   children: [
                              //     Expanded(
                              //         child: Row(
                              //       children: [
                              //         const Icon(
                              //           Icons.location_on_outlined,
                              //           color: Colors.black,
                              //         ),
                              //         const SizedBox(width: 8),
                              //         Text(
                              //           stock['Location'] ?? "",
                              //           style: TextStyle(
                              //               fontWeight: FontWeight.w500),
                              //         ),
                              //       ],
                              //     )),
                              //     stock['qty'] == null
                              //         ? Text("${stock['Max']}   ")
                              //         // ? (stock['Stock'].toString().isNotEmpty)
                              //         //     //for show norms screen data
                              //         //     ? Expanded(
                              //         //         child: Row(
                              //         //           mainAxisAlignment:
                              //         //               MainAxisAlignment
                              //         //                   .spaceBetween,
                              //         //           children: [
                              //         //             Text(stock['Max'].toString()),
                              //         //             label(
                              //         //                 "!500Stock!500   ${stock['Stock']}"),
                              //         //             // Text(
                              //         //             //     "Stock  ${stock['Qty']}   "),
                              //         //           ],
                              //         //         ),
                              //         //       )
                              //         //     //for show error from screen in location place
                              //         //     : SizedBox.shrink()
                              //         // for part stock check
                              //
                              //     : Expanded(
                              //         child: SingleChildScrollView(
                              //           scrollDirection: Axis.horizontal,
                              //           child: Row(
                              //             spacing: 5,
                              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Text(stock['qty'].toString()),
                              //               label("!500Stock Date!500  ${stock['stockdate']} "),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //   ],
                              // ),
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

  Widget label(String text) {
    final RegExp exp = RegExp(r"!500(.*?)!500");
    final matches = exp.allMatches(text);

    if (matches.isEmpty) return Text(text);

    List<TextSpan> spans = [];
    int start = 0;

    for (final match in matches) {
      // Add normal text before the bold
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }

      // Add bold text
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ));

      start = match.end;
    }

    // Add the remaining text after the last match
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return Text.rich(TextSpan(children: spans));
  }

  Widget _buildIconBtn({bool isWhite = false}) {
    return IconButton(
      // highlightColor: Colors.black12,
      // highlightColor: Colors.white10,
      onPressed: () {
        setState(() {
          showDetails = !showDetails;
        });
      },
      icon: AnimatedDropIcon(
        isTrue: showDetails,
        isWhite: isWhite,
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500))),
        Expanded(child: Text(value)),
      ],
    );
  }
}
