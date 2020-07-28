import 'package:flame/effects/effects.dart';
import 'package:flame/position.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

class PersonMoveEffect extends MoveEffect {
  PersonMoveEffect({
    @required Position destination,
    @required double speed,
    Curve curve,
    isInfinite = false,
    isAlternating = false,
    Function onComplete,
  }) : super(
          destination: destination,
          speed: speed,
          curve: curve,
          isInfinite: isInfinite,
          isAlternating: isAlternating,
          onComplete:onComplete,
        );

  @override
  void update(double dt) {
    ///解决percentage为null的时候MoveEffect就已经被remove的bug
    if (!isDisposed || percentage != null) {
      super.update(dt);
    }
  }
}
