import 'package:flame/effects/effects.dart';
import 'package:flutter/material.dart';

class HandRotateEffect extends PositionComponentEffect {
  double radians;
  double speed;
  Curve curve;

  double _originalAngle;
  double _peakAngle;

  HandRotateEffect({
    @required this.radians, // As many radians as you want to rotate
    @required this.speed, // In radians per second
    this.curve,
    isInfinite = false,
    isAlternating = false,
  }) : super(isInfinite, isAlternating);

  @override
  void initialize(_comp) {
    super.initialize(_comp);
    if (!isAlternating) {
      endAngle = _comp.angle + radians;
    }
    _originalAngle = component.angle;
    _peakAngle = _originalAngle + radians;
    travelTime = (radians / speed).abs();
  }

  @override
  void update(double dt) {
    super.update(dt);
    final double c = curve?.transform(percentage??0) ?? 1.0;
    component.angle = _originalAngle + _peakAngle * c;
  }
}