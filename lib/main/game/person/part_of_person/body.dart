import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../person_const_data.dart';

class BodySprite extends SpriteComponent {
  final String bodyImage;
  final Color bodyColor;

  Paint _bodyPaint;

  BodySprite({
    @required this.bodyImage,
    @required this.bodyColor,
  }) {
    _bodyPaint = Paint()..color = bodyColor;
    Sprite.loadSprite(bodyImage).then((value) {
      sprite = value;
      resetPosition();
    });
  }

  void resetPosition() {
    width = sprite.size.x * PersonScale;
    height = sprite.size.y * PersonScale;
    x = PersonBodyCenterX - width / 2;
    y = -PersonBodyCenterY - height / 2;
  }

  @override
  void render(Canvas canvas) {
    prepareCanvas(canvas);
    canvas.drawRect(Rect.fromLTWH(0, 0, width * 0.9, height * 0.8), _bodyPaint);
    sprite.render(canvas, width: width, height: height, overridePaint: overridePaint);
  }
}
