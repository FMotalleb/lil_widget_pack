import 'package:flutter/material.dart';

class BuildWithAnimationOf<T, C> extends AnimatedWidget {
  ///Animation value
  final Animation<T> animation;

  ///child widget to prevent constant widgets rebuild for no reason
  final C? child;
  final C? data;

  ///Build Child widget with params of
  ///
  /// * [BuildContext] context
  ///
  /// * [T] value of animation
  ///
  /// * [Widget] child given in parametrs to avoid performance issue
  final Widget Function(BuildContext, T, C?) builder;

  ///Alternative of animation builder
  const BuildWithAnimationOf(
      {Key? key,
      required this.animation,
      required this.builder,
      this.data = null,
      this.child = null})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, animation.value, data ?? child);
  }
}
