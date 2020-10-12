import 'dart:async';
import 'dart:math';

import 'package:cityCloud/dart_class/flame/callback_pre_rendered_layer.dart';
import 'package:cityCloud/dart_class/flame/scale_translate_canvas_effect.dart';
import 'package:cityCloud/expanded/database/database.dart';
import 'package:cityCloud/main/game/person/person_const_data.dart';
import 'package:cityCloud/main/game/person/person_effect/person_move_effect.dart';
import 'package:cityCloud/util/image_helper.dart';
import 'package:flame/components/component.dart';
import 'package:flame/effects/effects.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../map_tile/model/tile_path_node_info.dart';

class CarSprite extends PositionComponent {
  double _scale = 0.1;

  CallbackPreRenderedLayer _leftLayer;
  CallbackPreRenderedLayer _backLayer;
  CallbackPreRenderedLayer _frontLayer;

  CallbackPreRenderedLayer _currentLayer;

  ///运动的终点
  PathNode _endPathNode;

  SpriteComponent shadowTest;

  ///小车信息
  final CarInfo carInfo;

  ///左右移动的时候小车高度
  double _carHeight = 0;

  ScalTranslateCanvasEffect _scalTranslateCanvasEffect;

  CarSprite({@required Position initialPosition, @required PathNode endPathNode, @required this.carInfo})
      : assert(initialPosition != null && endPathNode != null && carInfo != null) {
    _endPathNode = endPathNode;
    x = initialPosition.x;
    y = initialPosition.y;
    Paint shadowPaint = Paint()
      ..color = Colors.black12
      ..blendMode = BlendMode.dstOut;
    _leftLayer = CallbackPreRenderedLayer();
    Sprite.loadSprite(ImageHelper.carShadowBack[carInfo.carID]).then((shadow) {
      SpriteComponent shadowSpriteComponent =
          SpriteComponent.fromSprite(shadow.size.x * _scale, shadow.size.y * _scale, shadow);
      shadowSpriteComponent.overridePaint = shadowPaint;
      shadowSpriteComponent.x = -shadowSpriteComponent.width / 2;
      shadowSpriteComponent.y = -shadowSpriteComponent.height / 2;
      shadowTest = shadowSpriteComponent;
      Sprite.loadSprite(ImageHelper.carBack[carInfo.carID]).then((value) {
        SpriteComponent carSpriteComponent =
            SpriteComponent.fromSprite(value.size.x * _scale, value.size.y * _scale, value);
        carSpriteComponent.x = -carSpriteComponent.width / 2;
        carSpriteComponent.y = -carSpriteComponent.height / 2;
        _backLayer = CallbackPreRenderedLayer(drawLayerCallback: (canvas) {
          canvas.save();
          shadowSpriteComponent.render(canvas);
          canvas.restore();
          canvas.save();
          carSpriteComponent.render(canvas);
          canvas.restore();
        });
        _backLayer.createLayer();
      });
    });
    Sprite.loadSprite(ImageHelper.carShadowFront[carInfo.carID]).then((shadow) {
      SpriteComponent shadowSpriteComponent =
          SpriteComponent.fromSprite(shadow.size.x * _scale, shadow.size.y * _scale, shadow);
      shadowSpriteComponent.overridePaint = shadowPaint;
      shadowSpriteComponent.x = -shadowSpriteComponent.width / 2;
      shadowSpriteComponent.y = -shadowSpriteComponent.height / 2;
      Sprite.loadSprite(ImageHelper.carFront[carInfo.carID]).then((value) {
        SpriteComponent carSpriteComponent =
            SpriteComponent.fromSprite(value.size.x * _scale, value.size.y * _scale, value);
        carSpriteComponent.x = -carSpriteComponent.width / 2;
        carSpriteComponent.y = -carSpriteComponent.height / 2;
        _frontLayer = CallbackPreRenderedLayer(drawLayerCallback: (canvas) {
          canvas.save();
          shadowSpriteComponent.render(canvas);
          canvas.restore();
          canvas.save();
          carSpriteComponent.render(canvas);
        });
        _frontLayer.createLayer();
      });
    });

    Sprite.loadSprite(ImageHelper.carShadowSide[carInfo.carID]).then((shadow) {
      SpriteComponent shadowSpriteComponent =
          SpriteComponent.fromSprite(shadow.size.x * _scale, shadow.size.y * _scale, shadow);
      shadowSpriteComponent.overridePaint = shadowPaint;
      shadowSpriteComponent.x = -shadowSpriteComponent.width / 2;
      shadowSpriteComponent.y = -shadowSpriteComponent.height / 2;
      Sprite.loadSprite(ImageHelper.carSide[carInfo.carID]).then((value) {
        SpriteComponent carSpriteComponent =
            SpriteComponent.fromSprite(value.size.x * _scale, value.size.y * _scale, value);
        carSpriteComponent.x = -carSpriteComponent.width * 0.5;
        carSpriteComponent.y = -carSpriteComponent.height * 0.8;
        _carHeight = carSpriteComponent.height;
        _leftLayer = CallbackPreRenderedLayer(drawLayerCallback: (canvas) {
          canvas.save();
          shadowSpriteComponent.render(canvas);
          canvas.restore();
          canvas.save();
          carSpriteComponent.render(canvas);
        });
        _leftLayer.createLayer();
      });
    });

    resetMoveEffectAndComponents();
  }

  ///根据_endPathNode重新设置移动
  void resetMoveEffectAndComponents() {
    clearEffects();
    _scalTranslateCanvasEffect = null;
    PersonMoveEffect moveEffect = PersonMoveEffect(
      destination: _endPathNode.position,
      curve: Curves.linear,
      speed: CarMoveSpeed,
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
    renderFlipX = false;
    if (moveEffect.destination.x > x) {
      ///向右
      renderFlipX = true;
      _currentLayer = _leftLayer;
      addScaleEffect();
    } else if (moveEffect.destination.x < x) {
      ///向左
      _currentLayer = _leftLayer;
      addScaleEffect();
    } else if (moveEffect.destination.y > y) {
      ///向下
      _currentLayer = _frontLayer;
      addRotateEffect();
    } else if (moveEffect.destination.y < y) {
      /// 向上
      _currentLayer = _backLayer;
      addRotateEffect();
    }
  }

  void addScaleEffect() {
    double scaleExtent = 0.1;
    _scalTranslateCanvasEffect = ScalTranslateCanvasEffect(
        destinationTranslate: Position(0, _carHeight * scaleExtent / 2),
        destinationScale: Offset(0, -scaleExtent),
        travelTime: 0.3,
        isAlternating: true,
        isInfinite: true,
        onComplete: () {});
  }

  void addRotateEffect() {
    double travelTime = 0.5;
    double rotate = pi / 80;

    RotateEffect rotateEffect = RotateEffect(
      radians: rotate * 2,
      speed: rotate * 2 / travelTime,
      curve: Curves.linear,
      isInfinite: true,
      isAlternating: true,
    );
    angle = -rotate;
    addEffect(rotateEffect);
  }

  @override
  int priority() {
    return y.toInt();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _scalTranslateCanvasEffect?.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    prepareCanvas(canvas);
    canvas.save();
    _scalTranslateCanvasEffect?.setEffectToCanvas(canvas);
    _currentLayer?.render(canvas);
    canvas.restore();
    canvas.restore();
  }
}
