import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/app_colors.dart';

class ExpandableTableController extends GetxController {
  var expandedMap = <String, bool>{}.obs;

  void toggleExpand(String key) {
    expandedMap[key] = !(expandedMap[key] ?? false);
  }
}

class ExpandableTable extends StatelessWidget {
  final List<String> tableHeader;
  final List<Map<String, dynamic>> data;
  final List<String> headers;
  final List<String> fields;
  final String primaryTitle;
  final String primaryValueKey;
  final String rowKey;
  final String? rowColorKey;

  ExpandableTable({
    super.key,
    required this.tableHeader,
    required this.data,
    required this.headers,
    required this.fields,
    required this.primaryTitle,
    required this.primaryValueKey,
    required this.rowKey,
    this.rowColorKey,
  });

  final ExpandableTableController controller =
      Get.put(ExpandableTableController());

  Color getRowColor(String type) {
    switch (type) {
      case 'Stockable':
        return DMAppColors.stockable;
      case 'Non-Stockable':
        return DMAppColors.nonStockable;
      case 'Non-Moving':
        return DMAppColors.nonMoving;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Container(
              color: DMAppColors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  ...tableHeader.map(
                    (headTitle) => Expanded(
                      child: Text(headTitle,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
            ...data.map((v) {
              bool isExpanded = controller.expandedMap[v[rowKey]] ?? false;

              return Column(
                children: [
                  Container(
                    color: Colors.black,
                    child: ListTile(
                      textColor: Colors.white,
                      title: Text(v[rowKey]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Rs. ${v[primaryValueKey]}',
                              style: const TextStyle(color: Colors.white)),
                          Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: Colors.white),
                        ],
                      ),
                      onTap: () => controller.toggleExpand(v[rowKey]),
                    ),
                  ),
                  if (isExpanded && v['rows'].isNotEmpty)
                    Column(
                      children: [
                        Container(
                          color: DMAppColors.secondary,
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: List.generate(headers.length, (index) {
                              return Expanded(
                                flex: index == 1 ? 2 : 1,
                                child: Text(headers[index]),
                              );
                            }),
                          ),
                        ),
                        ...v['rows'].map<Widget>((row) {
                          final color = rowColorKey != null
                              ? getRowColor(row[rowColorKey])
                              : Colors.white;
                          return Container(
                            color: color,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            child: Row(
                              children: List.generate(fields.length, (index) {
                                final key = fields[index];
                                return Expanded(
                                  flex: index == 1 ? 2 : 1,
                                  child: Text('${row[key]}'),
                                );
                              }),
                            ),
                          );
                        }).toList()
                      ],
                    )
                ],
              );
            })
          ],
        ));
  }
}
