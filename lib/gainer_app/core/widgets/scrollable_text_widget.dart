import 'dart:io';
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
        // child: widget.textWidget,
        child: Padding(
          padding: EdgeInsets.only(bottom: Platform.isIOS ? 4.0 : 0),
          child: widget.textWidget,
        ),
      ),
    );
  }
}

// class ScrollableTextWidgetState extends State<ScrollableTextWidget> {
//   final ScrollController _controller = ScrollController();
//   bool _hasScrollbar = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _checkOverflow();
//
//       _controller.addListener(() {
//         _checkOverflow();
//       });
//     });
//   }
//
//   void _checkOverflow() {
//     if (!_controller.hasClients) return;
//
//     final hasScrollbar = _controller.position.maxScrollExtent > 0;
//
//     if (hasScrollbar != _hasScrollbar) {
//       setState(() {
//         _hasScrollbar = hasScrollbar;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scrollbar(
//       controller: _controller,
//       thumbVisibility: _hasScrollbar,
//       trackVisibility: _hasScrollbar,
//       thickness: 2,
//       radius: const Radius.circular(10),
//       child: SingleChildScrollView(
//         controller: _controller,
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.only(
//           bottom: _hasScrollbar && Platform.isIOS ? 4 : 0,
//         ),
//         child: widget.textWidget,
//       ),
//     );
//   }
// }
