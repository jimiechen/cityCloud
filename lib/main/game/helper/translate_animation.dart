import 'dart:math';

import 'package:flutter/material.dart';

class TranslateAnimation {
  final Offset start;
  final Offset end;
  final double speed;
  final Curve curve;
  final ValueChanged<Offset> change;
  final VoidCallback complete;

  double _xDistance;
  double _yDistance;
  double travelTime;
  double currentTime = 0.0;

  bool _finish = false;

  TranslateAnimation({
    @required this.start,
    @required this.end,
    @required this.speed,
    @required this.curve,
    this.change,
    this.complete,
  }) {
    _xDistance = end.dx - start.dx;
    _yDistance = end.dy - start.dy;
    final totalDistance = sqrt(pow(_xDistance, 2) + pow(_yDistance, 2));
    travelTime = totalDistance / speed;
  }

  void dispose() => _finish = true;

  void update(double dt) {
    if (_finish) return;
    currentTime += dt;
    double percentage = min(1.0, max(0.0, currentTime / travelTime));
    final double c = curve?.transform(percentage) ?? 1.0;
    change?.call(start + Offset(_xDistance * c, _yDistance * c));
    if (percentage >= 1) complete?.call();
  }
}
