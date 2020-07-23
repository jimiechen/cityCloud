import 'dart:math';

import 'package:flutter/material.dart';

class DoubleAnimation {
  final double speed;
  final Curve curve;
  final double start;
  final double end;
  final ValueChanged<double> change;
  final VoidCallback complete;

  double travelTime;
  double currentTime = 0.0;
  double _distance;
  bool _finish = false;

  DoubleAnimation({
    @required this.start,
    @required this.end,
    @required this.speed,
    @required this.curve,
    this.change,
    this.complete,
  }) {
    _distance = end - start;
    travelTime = (_distance / speed).abs();
  }

  void dispose() => _finish = true;
  
  void update(double dt) {
    if (_finish) return;
    currentTime += dt;
    double percentage = min(1.0, max(0.0, currentTime / travelTime));
    final double c = curve?.transform(percentage) ?? 1.0;
    change?.call(start + _distance * c);
    if (percentage >= 1) complete?.call();
  }
}
