import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import '../person_const_data.dart';

class HandSprite extends SpriteComponent {
  final String handImage;
  final Color handColor;
  final bool isLeftHand;

  Paint _handPaint;

  HandSprite({
    @required this.handImage,
    @required this.handColor,
    this.isLeftHand = true,
  }) {
    _handPaint = Paint()..color = handColor;
    Sprite.loadSprite(handImage).then((value) {
      sprite = value;
      resetPosition();
    });
  }

  void resetPosition() {
    angle = 0;
    width = sprite.size.x * PersonScale;
    height = sprite.size.y * PersonScale;
    x = (isLeftHand ? -PersonHandsSpacing / 2 : PersonHandsSpacing / 2) - width / 2;
    y = -PersonHandCenterY - height / 2;
  }

  @override
  void render(Canvas canvas) {
    prepareCanvas(canvas);
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(0, 0, width, height), 2, 2), _handPaint);
    sprite.render(canvas, width: width, height: height, overridePaint: overridePaint);
  }
}
