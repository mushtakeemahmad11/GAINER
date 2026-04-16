import 'package:flutter/material.dart';
import 'dart:math' as math;

class RotatingRefreshIcon extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final bool isRotating; // ✅ External flag
  final Color? color;

  const RotatingRefreshIcon({
    super.key,
    required this.onRefresh,
    required this.isRotating,
    this.color = Colors.white,
  });

  @override
  State<RotatingRefreshIcon> createState() => _RotatingRefreshIconState();
}

class _RotatingRefreshIconState extends State<RotatingRefreshIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant RotatingRefreshIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRotating && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isRotating && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (!widget.isRotating) {
      await widget.onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _handleTap,
      icon: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: child,
          );
        },
        child: Icon(Icons.refresh, color: widget.color),
      ),
    );
  }
}
