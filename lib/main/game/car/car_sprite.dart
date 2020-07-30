import 'dart:async';

import 'package:cityCloud/main/game/person/person_const_data.dart';
import 'package:cityCloud/main/game/person/person_effect/person_move_effect.dart';
import 'package:flame/components/component.dart';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../model/tile_info.dart';

class CarSprite extends PositionComponent {
  String _spriteImage = 'excavator_';
  double _scale = 0.15;
  List<SpriteComponent> _backComponents = [];
  List<SpriteComponent> _frontComponents = [];
  List<SpriteComponent> _leftComponents = [];

  List<SpriteComponent> _currentComponents = [];

  ///小车朝向
  AxisDirection _axisDirection;

  ///运动的终点
  PathNode _endPathNode;

  ///移动effect
  PersonMoveEffect _moveEffect;

  CarSprite({@required Position initialPosition, @required PathNode endPathNode}) : assert(initialPosition != null && endPathNode != null) {
    _endPathNode = endPathNode;
    x = initialPosition.x;
    y = initialPosition.y;
    resetMoveEffectAndComponents();
    Sprite.loadSprite('${_spriteImage}back_shadow.png').then((shadow) {
      _backComponents.add(SpriteComponent.fromSprite(shadow.size.x * _scale, shadow.size.y * _scale, shadow));
      Sprite.loadSprite('${_spriteImage}back.png').then((value) {
        _backComponents.add(SpriteComponent.fromSprite(value.size.x * _scale, value.size.y * _scale, value));
      });
    });
    Sprite.loadSprite('${_spriteImage}front_shadow.png').then((shadow) {
      _frontComponents.add(SpriteComponent.fromSprite(shadow.size.x * _scale, shadow.size.y * _scale, shadow));
      Sprite.loadSprite('${_spriteImage}front.png').then((value) {
        _frontComponents.add(SpriteComponent.fromSprite(value.size.x * _scale, value.size.y * _scale, value));
      });
    });

    Sprite.loadSprite('${_spriteImage}side_shadow.png').then((shadow) {
      _leftComponents.add(SpriteComponent.fromSprite(shadow.size.x * _scale, shadow.size.y * _scale, shadow));
      Sprite.loadSprite('${_spriteImage}side.png').then((value) {
        _leftComponents.add(SpriteComponent.fromSprite(value.size.x * _scale, value.size.y * _scale, value));
      });
    });
  }

  ///根据_endPathNode重新设置移动
  void resetMoveEffectAndComponents() {
    if (_moveEffect != null && !_moveEffect.isDisposed) {
      removeEffect(_moveEffect);
    }
    _moveEffect = PersonMoveEffect(
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
    addEffect(_moveEffect);
    if (_moveEffect.endPosition.x > x) {
      _axisDirection = AxisDirection.right;
      _currentComponents = _leftComponents..forEach((e) => e..renderFlipX = true);
    } else if (_moveEffect.endPosition.x < x) {
      _axisDirection = AxisDirection.left;
      _currentComponents = _leftComponents;
    } else if (_moveEffect.endPosition.y > y) {
      _axisDirection = AxisDirection.down;
      _currentComponents = _frontComponents;
    } else if (_moveEffect.endPosition.y < y) {
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
