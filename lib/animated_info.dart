import 'package:flutter/material.dart';

class AnimatedInfo extends AnimatedWidget {
  final Animation<double> animation;
  final Widget child;

  AnimatedInfo({
    Key key,
    @required this.animation,
    @required this.child,
  }) : super(key: key, listenable: animation);

  static final TweenSequence<double> fadeTween = TweenSequence<double>([
    TweenSequenceItem<double>(
      tween: Tween(begin: 1.0, end: 0.0).chain(
        CurveTween(
          curve: Curves.easeOutExpo,
        ),
      ),
      weight: 40.0,
    ),
    TweenSequenceItem<double>(
      tween: Tween(begin: 0.0, end: 1.0).chain(
        CurveTween(
          curve: Curves.easeInExpo,
        ),
      ),
      weight: 60.0,
    )
  ]);

  static final TweenSequence<double> slideTween = TweenSequence<double>([
    TweenSequenceItem<double>(
      tween: Tween(begin: 0.0, end: 10.0).chain(
        CurveTween(
          curve: Curves.easeOutCubic,
        ),
      ),
      weight: 50.0,
    ),
    TweenSequenceItem<double>(
      tween: Tween(begin: 10.0, end: 0.0).chain(
        CurveTween(
          curve: Curves.easeInCubic,
        ),
      ),
      weight: 50.0,
    )
  ]);

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          0.0,
          slideTween.evaluate(animation),
        ),
      child: Opacity(
        opacity: fadeTween.evaluate(animation),
        child: child,
      ),
    );
  }
}
