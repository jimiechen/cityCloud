import 'package:flame/effects/scale_effect.dart';
import 'package:flutter/material.dart';

class EyeScaleEffect extends ScaleEffect {
  EyeScaleEffect({
    @required Size size,
    @required double speed,
    Curve curve,
    isInfinite = false,
    isAlternating = false,
    Function onComplete,
  }) : super(
          size: size,
          speed: speed,
          curve: curve,
          isAlternating: isAlternating,
          isInfinite: isInfinite,
          onComplete: onComplete,
        );
  @override
  void update(double dt) {
    ///解决percentage为null的时候MoveEffect就已经被remove的bug
    if (!isDisposed || percentage != null) {
      super.update(dt);
    }
  }
}
