import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class RemiderSprite extends SpriteComponent {
  double _timeCount = 5;
  RemiderSprite.fromSprite(
    double width,
    double height,
  ) {
    this.sprite = sprite;
    this.width = width;
    this.height = height;
    Sprite.loadSprite(
      'icon_mail.png',
    ).then((value) {
      sprite = value;
    });
  }

  @override
  bool loaded() => _timeCount > 0 && super.loaded();

  @override
  void render(Canvas canvas) {
    if (loaded()) {
      super.render(canvas);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeCount -= dt;
  }
}
