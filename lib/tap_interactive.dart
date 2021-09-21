import 'package:flutter/material.dart';

class TapInteractive extends StatefulWidget {
  final Widget child;
  final Duration onTapUpDuration;
  final Duration onTapDownDuration;
  final Curve curve;
  final double minmumScale;
  final double maximumScale;
  final void Function()? onTap;
  final void Function()? onTapDown;
  final void Function()? onTapUp;
  const TapInteractive(
      {Key? key,
      required this.child,
      this.onTapUpDuration = const Duration(milliseconds: 150),
      this.onTapDownDuration = const Duration(milliseconds: 150),
      this.curve = Curves.easeInOutBack,
      this.onTap,
      this.onTapDown,
      this.onTapUp,
      this.minmumScale = 0.9,
      this.maximumScale = 1.0})
      : super(key: key);

  @override
  State<TapInteractive> createState() => _TapInteractiveState();
}

class _TapInteractiveState extends State<TapInteractive>
    with SingleTickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: widget.onTapUpDuration,
        lowerBound: 0.0,
        upperBound: 1.0,
        reverseDuration: widget.onTapDownDuration);
    _animation =
        Tween<double>(begin: widget.minmumScale, end: widget.maximumScale)
            .animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (v) {
          _controller.reverse();
          (widget.onTapDown ?? () {})();
        },
        onTapUp: (v) {
          _controller.forward();
          (widget.onTapUp ?? () {})();
        },
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _animation,
          child: widget.child,
        ));
  }
}
