import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/effects/move_effect.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class CloudSprite extends Component with HasGameRef {
  List<PositionComponent> components = [];
  Size _gameSize;
  CloudSprite(this._gameSize) {
    addRandomCloud();
    addRandomCloud();
    addRandomCloud();
  }

  void addRandomCloud() {
    int randomInt = Random().nextInt(5);
    Sprite.loadSprite('fc-cloud-$randomInt.png').then((value) {
      SpriteComponent component = SpriteComponent();
      component.sprite = value;
      component.y = _gameSize == null ? 0 : Random().nextDouble() * _gameSize.height - value.size.y / 2;
      component.x = _gameSize == null ? -value.size.x : -Random().nextDouble() * value.size.x;
      component.width = value.size.x * 0.5;
      component.height = value.size.y * 0.5;
      component.overridePaint = Paint()..color = Colors.white.withOpacity(0.3);
      component.addEffect(
        MoveEffect(
            destination: Position(_gameSize?.width ?? 0, component.y),
            speed: 10,
            curve: Curves.linear,
            onComplete: () {
              component.clearEffects();
              component.sprite = null;
              Future(() {
                addRandomCloud();
              });
            }),
      );
      components.add(component);
    });
  }

  @override
  bool loaded() {
    return components.isNotEmpty;
  }

  @override
  bool destroy() {
    return components.isEmpty;
  }

  @override
  void resize(Size size) {
    _gameSize = size;
    super.resize(size);
  }

  @override
  int priority() {
    return 1000;
  }

  @override
  void render(Canvas c) {
    components.forEach((element) {
      if (element.loaded()) {
        element.render(c);
      }
    });
  }

  @override
  void update(double t) {
    components.forEach((element) {
      element.update(t);
    });
    components.removeWhere((element) => !element.loaded());
  }
}
