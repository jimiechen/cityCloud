import 'dart:async';
import 'dart:math';

import 'package:cityCloud/main/game/person/person_const_data.dart';
import 'package:cityCloud/main/game/person/person_effect/person_move_effect.dart';
import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/effects/combined_effect.dart';
import 'package:flame/effects/effects.dart';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../map_tile/model/tile_info.dart';

class CarSprite extends PositionComponent {
  String _spriteImage = 'excavator_';
  double _scale = 0.1;
  List<SpriteComponent> _backComponents = [];
  List<SpriteComponent> _frontComponents = [];
  List<SpriteComponent> _leftComponents = [];

  List<SpriteComponent> _currentComponents = [];

  ///小车朝向
  AxisDirection _axisDirection;

  ///运动的终点
  PathNode _endPathNode;

  CarSprite({@required Position initialPosition, @required PathNode endPathNode}) : assert(initialPosition != null && endPathNode != null) {
    _endPathNode = endPathNode;
    x = initialPosition.x;
    y = initialPosition.y;
    Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..blendMode = BlendMode.difference;
    Paint carPaint = Paint()
      ..color = Colors.white
      ..isAntiAlias = true;

    Sprite.loadSprite('${_spriteImage}back_shadow.png').then((shadow) {
      SpriteComponent shadowSpriteComponent = SpriteComponent.fromSprite(shadow.size.x * _scale, shadow.size.y * _scale, shadow);
      shadowSpriteComponent.overridePaint = shadowPaint;
      shadowSpriteComponent.x = -shadowSpriteComponent.width / 2;
      shadowSpriteComponent.y = -shadowSpriteComponent.height / 2 - 2;
      _backComponents.add(shadowSpriteComponent);
      Sprite.loadSprite('${_spriteImage}back.png').then((value) {
        SpriteComponent carSpriteComponent = SpriteComponent.fromSprite(value.size.x * _scale, value.size.y * _scale, value);
        carSpriteComponent.overridePaint = carPaint;
        RotateEffect rotateEffect = RotateEffect(
          radians: pi / 30,
          speed: 0.5,
          curve: Curves.linear,
          isInfinite: true,
          isAlternating: true,
        );
        carSpriteComponent.anchor = Anchor(Offset(0.5, 0.7));
        carSpriteComponent.addEffect(rotateEffect);
        _backComponents.add(carSpriteComponent);
      });
    });
    Sprite.loadSprite('${_spriteImage}front_shadow.png').then((shadow) {
      SpriteComponent shadowSpriteComponent = SpriteComponent.fromSprite(shadow.size.x * _scale, shadow.size.y * _scale, shadow);
      shadowSpriteComponent.overridePaint = shadowPaint;
      shadowSpriteComponent.x = -shadowSpriteComponent.width / 2;
      shadowSpriteComponent.y = -shadowSpriteComponent.height / 2 + 8;
      _frontComponents.add(shadowSpriteComponent);

      Sprite.loadSprite('${_spriteImage}front.png').then((value) {
        SpriteComponent carSpriteComponent = SpriteComponent.fromSprite(value.size.x * _scale, value.size.y * _scale, value);
        carSpriteComponent.overridePaint = carPaint;
        RotateEffect rotateEffect = RotateEffect(
          radians: pi / 30,
          speed: 0.5,
          curve: Curves.linear,
          isInfinite: true,
          isAlternating: true,
        );
        carSpriteComponent.anchor = Anchor(Offset(0.5, 1 / 3));
        carSpriteComponent.addEffect(rotateEffect);
        _frontComponents.add(carSpriteComponent);
      });
    });

    Sprite.loadSprite('${_spriteImage}side_shadow.png').then((shadow) {
      SpriteComponent shadowSpriteComponent = SpriteComponent.fromSprite(shadow.size.x * _scale, shadow.size.y * _scale, shadow);
      shadowSpriteComponent.overridePaint = shadowPaint;
      shadowSpriteComponent.x = -shadowSpriteComponent.width / 2 - 6;
      shadowSpriteComponent.y = -shadowSpriteComponent.height / 2;
      _leftComponents.add(shadowSpriteComponent);
      Sprite.loadSprite('${_spriteImage}side.png').then((value) {
        SpriteComponent carSpriteComponent = SpriteComponent.fromSprite(value.size.x * _scale, value.size.y * _scale, value);
        carSpriteComponent.x = -carSpriteComponent.width * 0.7;
        carSpriteComponent.y = -carSpriteComponent.height * 0.8;
        carSpriteComponent.overridePaint = carPaint;
        ScaleEffect scaleEffect = ScaleEffect(
          size: Size(carSpriteComponent.width, carSpriteComponent.height - 4),
          speed: 10,
          curve: Curves.linear,
        );
        MoveEffect moveEffect = MoveEffect(
          destination: carSpriteComponent.toPosition() + Position(0, 4),
          speed: 10,
          curve: Curves.linear,
        );
        carSpriteComponent.addEffect(
          CombinedEffect(
            effects: [scaleEffect, moveEffect],
            isAlternating: true,
            isInfinite: true,
          ),
        );
        _leftComponents.add(carSpriteComponent);
        if (_axisDirection == AxisDirection.right && !_leftComponents.every((element) => element.renderFlipX)) {
          _leftComponents.forEach((e) => e..renderFlipX = true);
        }
      });
    });

    resetMoveEffectAndComponents();
  }

  ///根据_endPathNode重新设置移动
  void resetMoveEffectAndComponents() {
    clearEffects();
    PersonMoveEffect moveEffect = PersonMoveEffect(
      destination: _endPathNode.position,
      curve: Curves.linear,
      speed: MoveSpeed,
      onComplete: () {
        Timer.run(() {
          _endPathNode = _endPathNode.randomLinkedNode;
          if (_endPathNode != null) {
            resetMoveEffectAndComponents();
          }
        });
      },
    );
    addEffect(moveEffect);

    if (moveEffect.destination.x > x) {
      _axisDirection = AxisDirection.right;
      _currentComponents = _leftComponents..forEach((e) => e..renderFlipX = true);
    } else if (moveEffect.destination.x < x) {
      _axisDirection = AxisDirection.left;
      _currentComponents = _leftComponents..forEach((e) => e..renderFlipX = false);
    } else if (moveEffect.destination.y > y) {
      _axisDirection = AxisDirection.down;
      _currentComponents = _frontComponents;
    } else if (moveEffect.destination.y < y) {
      _axisDirection = AxisDirection.up;
      _currentComponents = _backComponents;
    }
  }

  @override
  int priority() {
    return y.toInt();
  }

  @override
  Rect toRect() => Rect.fromLTWH(x - 10, y - FootHeight - BodyHeight - HeadHeight - 20, 20, 20);
  @override
  void update(double dt) {
    super.update(dt);
    _currentComponents.forEach((element) => element.update(dt));
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(x, y);

    ///手脚
    canvas.save();
    _currentComponents.forEach((comp) => _renderComponent(canvas, comp));
    canvas.restore();
    canvas.restore();
  }

  void _renderComponent(Canvas canvas, Component c) {
    if (!c.loaded()) {
      return;
    }

    c.render(canvas);
    canvas.restore();
    canvas.save();
  }
}
