import 'dart:async';

import 'package:flutter/material.dart';

class BuildWithAnimationOf<T> extends StatefulWidget {
  final Animation<T> animation;
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
      : super(key: key);

  @override
  _BuildWithAnimationOfState<T> createState() => _BuildWithAnimationOfState();
}

class _BuildWithAnimationOfState<T> extends State<BuildWithAnimationOf<T>> {
  @override
  void initState() {
    widget.animation.addListener(() {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.animation.value, widget.child);
  }
}
