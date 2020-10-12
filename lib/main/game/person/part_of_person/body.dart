import 'package:cityCloud/dart_class/flame/callback_pre_rendered_layer.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../person_const_data.dart';

class BodySprite extends PositionComponent {
  CallbackPreRenderedLayer _layer;

  double _width;
  double _height;

  BodySprite({
    @required String bodyImage,
    @required Color bodyColor,
  }) {
    Sprite.loadSprite(bodyImage).then((value) {
      _width = value.size.x * PersonScale;
      _height = value.size.y * PersonScale;
      resetPosition();
      _layer = CallbackPreRenderedLayer(drawLayerCallback: (canvas) {
        canvas.drawRect(Rect.fromLTWH(0, 0, width * 0.9, height * 0.8), Paint()..color = bodyColor);
        value.render(canvas, width: width, height: height);
      });
      _layer.createLayer();
    });
  }

  void resetPosition() {
    width = _width;
    height = _height;
    x = PersonBodyCenterX - width / 2;
    y = -PersonBodyCenterY - height / 2;
  }

  @override
  void render(Canvas canvas) {
    prepareCanvas(canvas);
    _layer?.render(canvas);
  }
}
