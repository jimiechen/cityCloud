import 'dart:ui';

import 'package:flutter/material.dart';

class CallbackPreRenderedLayer {
  Picture _picture;

  PictureRecorder _recorder;
  Canvas _canvas;

  bool get haveLayerPicture => _picture != null;

  final ValueChanged<Canvas> drawLayerCallback;

  CallbackPreRenderedLayer({this.drawLayerCallback});

  void render(Canvas canvas, {double x = 0.0, double y = 0.0}) {
    if (_picture == null) {
      return;
    }
    canvas.save();
    canvas.translate(x, y);
    canvas.drawPicture(_picture);
    canvas.restore();
  }

  Canvas get canvas {
    assert(
      _canvas != null,
      'Layer is not ready for rendering, call beginRendering first',
    );
    return _canvas;
  }

  void beginRendering() {
    _recorder = PictureRecorder();
    _canvas = Canvas(_recorder);
  }

  void finishRendering() {
    _picture = _recorder.endRecording();

    _recorder = null;
    _canvas = null;
  }

  void createLayer() {
    beginRendering();
    drawLayer();
    finishRendering();
  }

  void drawLayer() {
    drawLayerCallback?.call(canvas);
  }
}

