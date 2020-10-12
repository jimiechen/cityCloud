import 'package:flame/effects/effects.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class JumpTranslate extends PositionComponentEffect {
  double jumpHeight;
  double speed;
  Curve curve;

  double _currentTranslate = 0;

  JumpTranslate({
    @required this.jumpHeight,
    @required this.speed,
    this.curve,
    isInfinite = false,
    isAlternating = false,
    Function onComplete,
  }) : super(isInfinite, isAlternating, onComplete: onComplete) {
    travelTime = jumpHeight / speed;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final double c = curve?.transform(percentage) ?? 1.0;
    _currentTranslate = jumpHeight * c;
  }

  void translate(Canvas canvas) {
    canvas.translate(0, -_currentTranslate);
  }
}
