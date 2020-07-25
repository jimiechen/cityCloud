import 'package:flame/effects/effects.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';

class JumpInPlaceEffect extends PositionComponentEffect {
  final Offset endScale;
  final double endYTranslate;
  final Curve curve;
  final Position personPosition;

  VoidCallback _onComplete;

  double standTimeBeforJump;
  double standTimeAfterJump;

  JumpInPlaceEffect({
    this.endScale = const Offset(1.1, 0.9),
    this.endYTranslate = -15,
    double inputTravelTime = 0.3,
    VoidCallback onComplete,
    this.curve = Curves.linear,
    this.standTimeBeforJump = 3,
    this.standTimeAfterJump = 3,
    @required this.personPosition,
  })  : assert(
          personPosition != null && endScale != null && endYTranslate != null && inputTravelTime != null && curve != null,
        ),
        super(
          false,
          true,
          onComplete: standTimeAfterJump == null ? onComplete : null,
        ) {
    _onComplete = onComplete;
    travelTime = inputTravelTime;
  }

  void setEffectToCanvas(Canvas canvas) {
    if (percentage == null) return;

    final double c = curve?.transform(percentage) ?? 1.0;
    double scaleX = 1 + (endScale.dx - 1) * c;
    double scaleY = 1 + (endScale.dy - 1) * c;
    canvas.translate((1 - scaleX) * personPosition.x, c * endYTranslate + (1 - scaleY) * personPosition.y);
    canvas.scale(scaleX, scaleY);
  }

  void update(double dt) {
    if (standTimeBeforJump != null && standTimeBeforJump > 0) standTimeBeforJump -= dt;
    if (standTimeBeforJump == null || standTimeBeforJump < 0) {
      if (hasFinished()) {
        if (standTimeAfterJump != null && standTimeAfterJump > 0) {
          standTimeAfterJump -= dt;
          if (standTimeAfterJump < 0) {
            _onComplete?.call();
          }
        }
      } else {
        super.update(dt);
      }
    }
  }
}
