import 'package:flutter/material.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/scrollable_text_widget.dart';

class PRExpansionTileHeader extends StatelessWidget {
  final String title1;
  final String title2;
  final String title3;

  const PRExpansionTileHeader({
    super.key,
    required this.title1,
    required this.title2,
    required this.title3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _titleText(title1),
        const SizedBox(width: 10),
        Expanded(
          // child:  _titleText(title2),
          child: Center(
            child: ScrollableTextWidget(
              textWidget: _titleText(title2),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _titleText(title3),
      ],
    );
  }

  Widget _titleText(String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: GainerColors.textPrimary,
      ),
    );
  }
}

class _ScrollableTitle extends StatefulWidget {
  // final String text;
  final Widget title;

  const _ScrollableTitle({required this.title});

  @override
  State<_ScrollableTitle> createState() => _ScrollableTitleState();
}

class _ScrollableTitleState extends State<_ScrollableTitle> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,
      thumbVisibility: true, // always visible
      trackVisibility: true,
      thickness: 3,
      radius: const Radius.circular(10),
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        child: widget.title,
        // child: Text(
        //   widget.text,
        //   style: const TextStyle(
        //     fontSize: 13,
        //     fontWeight: FontWeight.bold,
        //     color: GainerColors.textPrimary,
        //   ),
        // ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// import '../../../../core/constants/gainer_color.dart';
//
// class PRExpansionTileHeader extends StatelessWidget {
//   final String title1;
//   final String title2;
//   final String title3;
//
//   const PRExpansionTileHeader({
//     super.key,
//     required this.title1,
//     required this.title2,
//     required this.title3,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       spacing: 10,
//       children: [
//         _titleText(title1),
//         Expanded(
//           child: Center(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: _titleText(title2),
//             ),
//           ),
//         ),
//         _titleText(title3),
//       ],
//     );
//   }
//
//   Widget _titleText(String text) {
//     return Text(
//       text,
//       maxLines: 1,
//       overflow: TextOverflow.ellipsis,
//       style: TextStyle(
//         fontSize: 13,
//         fontWeight: FontWeight.bold,
//         color: GainerColors.textPrimary,
//       ),
//     );
//   }
// }
//
