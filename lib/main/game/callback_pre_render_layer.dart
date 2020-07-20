import 'package:flame/layer/layer.dart';
import 'package:flutter/material.dart';

///地图背景layer
class CallbackLayer extends PreRenderedLayer {
  final ValueChanged<Canvas> drawLayerCallback;

  CallbackLayer({this.drawLayerCallback});

  @override
  void render(Canvas canvas, {double x = 0.0, double y = 0.0}) {
    super.render(canvas, x: x, y: y);
  }

  @override
  void drawLayer() {
    drawLayerCallback?.call(canvas);
  }
}