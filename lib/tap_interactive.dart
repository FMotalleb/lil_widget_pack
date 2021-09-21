import 'package:flutter/material.dart';

class TapInteractive extends StatefulWidget {
  final Widget child;
  final Duration onTapUpDuration;
  final Duration onTapDownDuration;
  final Curve curve;
  final Curve reverseCurve;
  final double minmumScale;
  final double maximumScale;
  final void Function()? onTap;
  final void Function()? onTapDown;
  final void Function()? onTapUp;
  final AnimatedWidget Function(Animation animation, Widget child)? builder;
  const TapInteractive(
      {Key? key,
      required this.child,
      this.onTapUpDuration = const Duration(milliseconds: 300),
      this.onTapDownDuration = const Duration(milliseconds: 100),
      this.curve = Curves.easeInOutBack,
      this.reverseCurve = Curves.elasticIn,
      this.onTap,
      this.onTapDown,
      this.onTapUp,
      this.builder,
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
  late final AnimatedWidget output;
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
            .animate(CurvedAnimation(
                parent: _controller,
                curve: widget.curve,
                reverseCurve: widget.reverseCurve));
    _controller.forward();
    if (widget.builder != null) {
      output = widget.builder!(_animation, widget.child);
    } else {
      output = ScaleTransition(
        scale: _animation,
        child: widget.child,
      );
    }

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
        child: output);
  }
}
