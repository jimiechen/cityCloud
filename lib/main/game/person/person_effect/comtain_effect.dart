import 'dart:math';

import 'package:flame/effects/effects.dart';
import 'package:meta/meta.dart';

class ContainEffect extends PositionComponentEffect {
  final double startTime;
  final PositionComponentEffect effect;
  ContainEffect({
    @required this.startTime,
    @required this.effect,
    @required double travel,
    isInfinite = false,
    isAlternating = false,
    Function onComplete,
  }) : super(isInfinite, isAlternating, onComplete: onComplete) {
    travelTime = travel;
  }

  @override
  // ignore: must_call_super
  void initialize(_comp) {
    effect.initialize(_comp);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final double time = max(dt - startTime, 0);
    effect.update(time);
  }
}
