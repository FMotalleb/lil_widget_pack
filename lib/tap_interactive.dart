import 'package:flutter/material.dart';
import 'package:lil_widget_pack/animation_builder.dart';

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
      this.onTapUpDuration = const Duration(milliseconds: 150),
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
    with TickerProviderStateMixin {
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
    _controller.value = 1;
    if (widget.builder != null) {
      output = widget.builder!(_animation, widget.child);
    } else {
      output = BuildWithAnimationOf<double, Widget>(
        animation: _animation,
        child: widget.child,
        builder: (_, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
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
    return Listener(
        onPointerDown: (v) {
          _controller.reverse();
          (widget.onTapDown ?? () {})();
        },
        onPointerUp: (v) {
          _controller.forward();
          (widget.onTapUp ?? () {})();
        },
        child: GestureDetector(onTap: (widget.onTap ?? () {}), child: output));
  }
}
