import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import '../person_const_data.dart';

class FootSprite extends SpriteComponent {
  final String footImage;
  final Color footColor;
  final bool isLeftHand;

  Paint _footPaint;

  FootSprite({
    @required this.footImage,
    @required this.footColor,
    this.isLeftHand = true,
  }) {
    y = -PersonFootLength;
    x = (isLeftHand ? -PersonFootsSpacing / 2 : PersonFootsSpacing / 2) - PersonFootWidth / 2;
    _footPaint = Paint()..color = footColor;
    Sprite.loadSprite(footImage).then((value) {
      sprite = value;
      resetPosition();
    });
  }

  void resetPosition() {
    width = sprite.size.x * PersonScale;
    height = sprite.size.y * PersonScale;
    x = (isLeftHand ? -PersonFootsSpacing / 2 : PersonFootsSpacing / 2) - width / 2;
    y = -height;
  }

  @override
  void render(Canvas canvas) {
    prepareCanvas(canvas);
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(0, 0, width, height), width / 2, width / 2), _footPaint);
    sprite.render(canvas, width: width, height: height, overridePaint: overridePaint);
  }
}
