import 'package:flame/effects/effects.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';

class ScalTranslateCanvasEffect extends PositionComponentEffect {
  final Offset destinationScale;
  final Position destinationTranslate;
  final double travelTime;
  final Curve curve;

  ///翻转
  final bool reverse;

  ScalTranslateCanvasEffect({
    @required this.destinationScale,
    @required this.destinationTranslate,
    @required this.travelTime,
    this.curve = Curves.linear,
    isInfinite = false,
    isAlternating = false,
    Function onComplete,
    this.reverse = false,
  })  : assert((destinationScale != null || destinationTranslate != null) && travelTime != null && curve != null),
        super(isInfinite, isAlternating, onComplete: onComplete);

  void setEffectToCanvas(Canvas canvas) {
    if(hasFinished()) return;
    double c = curve?.transform(percentage??0) ?? 1.0;
    if (reverse) {
      c = 1 - c;
    }
    if (destinationTranslate != null) {
      canvas.translate(c * destinationTranslate.x, c * destinationTranslate.y);
    }
    if (destinationScale != null) {
      canvas.scale(1 + c * destinationScale.dx, 1 + c * destinationScale.dy);
    }
  }
}
