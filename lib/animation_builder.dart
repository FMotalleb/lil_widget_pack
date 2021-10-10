import 'package:flutter/material.dart';

class BuildWithAnimationOf<T> extends AnimatedWidget {
  final Listenable<T> animation;
  final Widget? child;

  ///Build Child widget with params of
  ///
  /// * [BuildContext] context
  ///
  /// * [T] value of animation
  ///
  /// * [Widget] child given in parametrs to avoid performance issue
  final Widget Function(BuildContext, T, Widget?) builder;
  const BuildWithAnimationOf(
      {Key? key, required this.animation, required this.builder, this.child})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, animation.value, child);
  }
}
