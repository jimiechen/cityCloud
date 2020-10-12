import 'package:cityCloud/dart_class/flame/callback_pre_rendered_layer.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import '../person_const_data.dart';

class FootSprite extends PositionComponent {
  final bool isLeftHand;

  CallbackPreRenderedLayer _layer;

  double _width;
  double _height;

  FootSprite({
    @required String footImage,
    @required Color footColor,
    this.isLeftHand = true,
  }) {
    y = -PersonFootLength;
    x = (isLeftHand ? -PersonFootsSpacing / 2 : PersonFootsSpacing / 2) - PersonFootWidth / 2;
    Sprite.loadSprite(footImage).then((value) {
      _width = value.size.x * PersonScale;
      _height = value.size.y * PersonScale;
      resetPosition();
      _layer = CallbackPreRenderedLayer(drawLayerCallback: (canvas) {
        canvas.drawRRect(
            RRect.fromRectXY(Rect.fromLTWH(0, 0, width, height), width / 2, width / 2), Paint()..color = footColor);
        value.render(canvas, width: width, height: height);
      });
      _layer.createLayer();
    });
  }

  void resetPosition() {
    width = _width;
    height = _height;
    x = (isLeftHand ? -PersonFootsSpacing / 2 : PersonFootsSpacing / 2) - width / 2;
    y = -height;
  }

  @override
  void render(Canvas canvas) {
    prepareCanvas(canvas);
    _layer?.render(canvas);
  }
}
