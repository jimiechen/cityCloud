import 'dart:math';

import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

enum RemiderType {
  Message, //信封样式，点击之后跳到关注页
  Number, //显示一个数字，点击之后显示广告
}

///头顶提示信息
class RemiderInfo {
  final RemiderType type;

  ///type是Number的时候有用
  final int number;
  RemiderInfo({@required this.type, this.number}) : assert(type != null);
}

class RemiderSprite extends SpriteComponent {
  final double radius;
  final RemiderInfo info;
  RemiderSprite.fromSprite({@required this.info, @required this.radius}) {
    width = radius * 1.2;
    height = radius * 1.2;
    Sprite.loadSprite(
      'icon_mail.png',
    ).then((value) {
      sprite = value;
    });
  }

  @override
  bool loaded() => super.loaded();

  @override
  void render(Canvas canvas) {
    Paint paint = Paint()..color = Colors.red;
    canvas.drawCircle(Offset(0, y), radius, paint);
    Path path = Path();
    path.moveTo(-radius * 0.3, y + radius * 0.8);
    path.lineTo(-radius * 0.1, y + radius * 1.1);
    path.arcTo(
        Rect.fromCenter(center: Offset(x, y + radius * 1.1), width: radius * 0.1 * 2, height: radius * 0.1 * 2),
        0,
        pi,
        false);
    path.lineTo(radius * 0.1, y + radius * 1.1);
    path.lineTo(radius * 0.3, y + radius * 0.8);
    path.close();
    canvas.drawPath(path, paint);
    if (loaded()) {
      canvas.save();
      canvas.translate(-width /2, -height/2);
      super.render(canvas);
      canvas.restore();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
