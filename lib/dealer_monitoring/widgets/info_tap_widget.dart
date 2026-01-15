import 'package:flutter/material.dart';

class InfoTap extends StatefulWidget {
  final String label;
  final String info;

  const InfoTap({super.key, required this.label, required this.info});

  @override
  State<InfoTap> createState() => _InfoTapState();
}

class _InfoTapState extends State<InfoTap> {
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context, Offset position) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx - 100,
        top: position.dy + 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.info,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Auto remove after 3 sec
    Future.delayed(const Duration(seconds: 2), () {
      _removeOverlay();
    });
  }

  void _removeOverlay() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _removeOverlay(); // close any old one
        _showOverlay(context, details.globalPosition);
      },
      child: Text(
        widget.label,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
