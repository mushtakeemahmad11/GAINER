import 'package:flutter/material.dart';

class ScrollableTextWidget extends StatefulWidget {
  final Widget textWidget;

  const ScrollableTextWidget({super.key, required this.textWidget});

  @override
  State<ScrollableTextWidget> createState() => ScrollableTextWidgetState();
}

class ScrollableTextWidgetState extends State<ScrollableTextWidget> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,
      thumbVisibility: true, // always visible
      trackVisibility: true,
      thickness: 2,
      radius: const Radius.circular(10),
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        child: widget.textWidget,
      ),
    );
  }
}
