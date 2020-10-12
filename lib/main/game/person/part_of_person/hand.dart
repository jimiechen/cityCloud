import 'package:cityCloud/dart_class/flame/callback_pre_rendered_layer.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import '../person_const_data.dart';

class HandSprite extends PositionComponent {
  final bool isLeftHand;

  CallbackPreRenderedLayer _layer;

  double _width;
  double _height;

  HandSprite({
    @required String handImage,
    @required Color handColor,
    this.isLeftHand = true,
  }) {
    Sprite.loadSprite(handImage).then((value) {
      _width = value.size.x * PersonScale;
      _height = value.size.y * PersonScale;
      resetPosition();
      _layer = CallbackPreRenderedLayer(drawLayerCallback: (canvas) {
        canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(0, 0, width, height), 2, 2), Paint()..color = handColor);
        value.render(canvas, width: width, height: height);
      });
      _layer.createLayer();
    });
  }

  void resetPosition() {
    angle = 0;
    width = _width;
    height = _height;
    x = (isLeftHand ? -PersonHandsSpacing / 2 : PersonHandsSpacing / 2) - width / 2;
    y = -PersonHandCenterY - height / 2;
  }

  @override
  void render(Canvas canvas) {
    prepareCanvas(canvas);
    _layer?.render(canvas);
  }
}
