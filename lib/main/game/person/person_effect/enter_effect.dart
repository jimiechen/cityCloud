import 'package:flame/position.dart';
import 'package:flutter/material.dart';

class EnterEffect {
  final Offset beginScale;
  final double beginYTranslate;
  final double travelTime;
  final Function() onComplete;
  final Curve curve;
  final Position personPosition;

  double _currentTime = 0;
  bool _finish = false;

  EnterEffect({
    this.beginScale = const Offset(0, 10),
    this.beginYTranslate = -20,
    this.travelTime = 0.1,
    this.onComplete,
    this.curve = Curves.linear,
    @required this.personPosition,
  }) : assert(
          personPosition != null && beginScale != null && beginYTranslate != null && travelTime != null && curve != null,
        );

  void dispose() => _finish = true;

  bool get hasFinished => _finish;

  void setEffectToCanvas(Canvas canvas) {
    final double c = curve?.transform(_currentTime / travelTime) ?? 1.0;
    double scaleX = beginScale.dx - (beginScale.dx - 1) * c;
    double scaleY = beginScale.dy - (beginScale.dy - 1) * c;
    canvas.translate((1 - scaleX) * personPosition.x, (1 - c) * beginYTranslate + (1 - scaleY) * personPosition.y);
    canvas.scale(scaleX, scaleY);
  }

  void update(double dt) {
    if (_finish) return;
    _currentTime += dt;
    if (_currentTime >= travelTime) {
      _currentTime = travelTime;
      _finish = true;
      onComplete?.call();
    }
  }
}
