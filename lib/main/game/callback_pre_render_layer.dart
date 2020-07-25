import 'package:flame/layer/layer.dart';
import 'package:flutter/material.dart';

class CallbackPreRenderedLayer extends PreRenderedLayer {
  final ValueChanged<Canvas> drawLayerCallback;

  CallbackPreRenderedLayer({this.drawLayerCallback});

  @override
  void render(Canvas canvas, {double x = 0.0, double y = 0.0}) {
    super.render(canvas, x: x, y: y);
  }

  @override
  void drawLayer() {
    drawLayerCallback?.call(canvas);
  }
}

class CallbackDynamicLayer extends DynamicLayer {
  final ValueChanged<Canvas> drawLayerCallback;

  CallbackDynamicLayer({this.drawLayerCallback});

  @override
  void render(Canvas canvas, {double x = 0.0, double y = 0.0}) {
    super.render(canvas, x: x, y: y);
  }

  @override
  void drawLayer() {
    drawLayerCallback?.call(canvas);
  }
}
