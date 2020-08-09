import 'package:flame/components/component.dart';
import 'package:flame/effects/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import '../person_const_data.dart';

/** 
 * 一开始左脚是抬起来的
 */
class FootSprite extends SpriteComponent {
  final String footImage;
  final HorizontalOrigentation origentation;
  final Color color;
  FootSprite({this.color, double footWidth = FootWidth, double footHeight = FootHeight, @required this.footImage, this.origentation}) {
    assert(footWidth != null && footHeight != null);
    x = origentation == HorizontalOrigentation.Left ? -footWidth - FootSpacing / 2 : FootSpacing / 2;
    y = -footHeight;
    width = footWidth;
    height = origentation == HorizontalOrigentation.Left ? footHeight - FootPutUpHeight : footHeight;

    Sprite.loadSprite(footImage).then((value) {
      sprite = value;
      this.addEffect(
        ScaleEffect(
          size: Size(width, origentation == HorizontalOrigentation.Left ? footHeight : footHeight - FootPutUpHeight),
          isInfinite: true,
          isAlternating: true,
          curve: Curves.linear,
          speed: FootSpeed,
        ),
      );
    });
  }

  @override
  void render(Canvas canvas) {
    prepareCanvas(canvas);
    if (color != null) {
      canvas.drawRect(Rect.fromLTWH(0, 0, width, height * 0.9), Paint()..color = color);
    }

    sprite.render(canvas, width: width, height: height, overridePaint: overridePaint);
  }
}
