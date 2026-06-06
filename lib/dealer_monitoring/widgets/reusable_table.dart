import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class ReusableTable extends StatelessWidget {
  final List<String> headers;
  final List<List<dynamic>> rows;
  final Color headerColor;
  final Color rowColor;
  final List<TableColumnWidth>? columnWidths;
  final void Function(List<dynamic> row)? onRowLongPress;
  final List<Color?>? rowColorsList;

  const ReusableTable({
    super.key,
    required this.headers,
    required this.rows,
    this.headerColor = DMAppColors.secondary, // DMAppColors.secondary
    this.rowColor = DMAppColors.primaryShade, // DMAppColors.primaryShade
    this.columnWidths,
    this.onRowLongPress,
    this.rowColorsList,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: Colors.black12),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: columnWidths != null
            ? Map.fromIterables(
                List.generate(columnWidths!.length, (i) => i),
                columnWidths!,
              )
            : null,
        children: [
          // Header Row
          TableRow(
            decoration: BoxDecoration(color: headerColor),
            children: headers
                .map((header) => _buildCell(header, isHeader: true))
                .toList(),
          ),
          // Data Rows
          // ...rows.map((row) {
          ...rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;

            final color =
                (rowColorsList != null && index < rowColorsList!.length)
                    ? rowColorsList![index] ?? DMAppColors.primary
                    : DMAppColors.primary;

            return TableRow(
              // decoration: row.first.toString().startsWith("PN6789")?BoxDecoration(color: DMAppColors.stockable):BoxDecoration(color: rowColor),
              // decoration: BoxDecoration(color: rowColor),
              decoration: BoxDecoration(color: color),
              // children: row.map((cell) {
              //   return GestureDetector(
              //       onLongPress: (){
              //         print("LongPress on table: $row");
              //       },
              //       child: _buildCell(cell.toString()));
              // }).toList(),
              children: row
                  .map(
                    (cell) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onLongPress: onRowLongPress != null
                          ? () => onRowLongPress!(row)
                          : null,
                      // child: _buildCell(cell.toString()),
                      child:
                          (cell is Widget) ? cell : _buildCell(cell.toString()),
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCell(String content, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          content,
          textAlign: TextAlign.center, // show cellText in center even new line
          style: TextStyle(
            color: isHeader ? Colors.white : Colors.black,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class ReusableTableTest extends StatefulWidget {
  final List<String> headers;
  final List<List<dynamic>> rows;
  final Color headerColor;
  final Color rowColor;
  final Color longPressColor;
  final List<TableColumnWidth>? columnWidths;
  final void Function(List<dynamic> rowData, int rowIndex)? onRowLongPress;

  const ReusableTableTest({
    super.key,
    required this.headers,
    required this.rows,
    this.headerColor = DMAppColors.secondary,
    this.rowColor = DMAppColors.primaryShade,
    this.longPressColor = Colors.amber,
    this.columnWidths,
    this.onRowLongPress,
  });

  @override
  State<ReusableTableTest> createState() => _ReusableTableTestState();
}

class _ReusableTableTestState extends State<ReusableTableTest> {
  final Set<int> _highlightedRows = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: widget.columnWidths != null
            ? Map.fromIterables(
                List.generate(widget.columnWidths!.length, (i) => i),
                widget.columnWidths!,
              )
            : null,
        children: [
          // Header Row
          TableRow(
            decoration: BoxDecoration(color: widget.headerColor),
            children: widget.headers
                .map((header) => _buildCell(header, isHeader: true))
                .toList(),
          ),
          // Data Rows
          ...List.generate(widget.rows.length, (index) {
            final row = widget.rows[index];
            final isHighlighted = _highlightedRows.contains(index);
            final color =
                isHighlighted ? widget.longPressColor : widget.rowColor;

            return TableRow(
              decoration: BoxDecoration(color: color),
              children: row.map((cell) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onLongPress: () {
                    setState(() {
                      if (isHighlighted) {
                        _highlightedRows.remove(index);
                      } else {
                        _highlightedRows.add(index);
                      }
                    });

                    // Trigger external callback if provided
                    if (widget.onRowLongPress != null) {
                      widget.onRowLongPress!(row, index);
                    }
                  },
                  child: _buildCell(cell.toString()),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCell(String content, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          content,
          style: TextStyle(
            color: isHeader ? Colors.white : Colors.black,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
