import 'package:flutter/material.dart';

class GoOutEffect {
  final Offset destinationScale;
  final double destinationYTranslate;
  final double travelTime;
  final Function() onComplete;
  final Curve curve;
  final bool reverse;

  double _currentTime = 0;
  bool _finish = false;

  double _xScaleExtent;
  double _yScaleExtent;

  GoOutEffect({
    this.destinationScale = const Offset(0.5, 1.5),
    this.destinationYTranslate = -40,
    this.travelTime = 0.3,
    this.onComplete,
    this.curve = Curves.easeIn,
    this.reverse = false,
  }) : assert(destinationScale != null && destinationYTranslate != null && travelTime != null && curve != null) {
    _xScaleExtent = destinationScale.dx - 1;
    _yScaleExtent = destinationScale.dy - 1;
  }

  void dispose() => _finish = true;

  bool get hasFinished => _finish;

  void setEffectToCanvas(Canvas canvas) {
    double c = curve?.transform(_currentTime / travelTime) ?? 1.0;
    if (reverse) {
      c = 1 - c;
    }
    canvas.translate(0, c * destinationYTranslate);
    canvas.scale(1 + c * _xScaleExtent, 1 + c * _yScaleExtent);
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
