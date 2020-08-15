import 'dart:async';
import 'dart:math';

import 'package:cityCloud/dart_class/extension/Iterable_extension.dart';
import 'package:cityCloud/main/game/model/tile_location.dart';
import 'package:cityCloud/main/game/person/person_sprite.dart';
import 'package:cityCloud/main/game/tile_component.dart';
import 'package:cityCloud/main/game/model/tile_info.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:cityCloud/util/image_helper.dart';
import 'package:flame/components/component.dart';
import 'package:ordered_set/ordered_set.dart';
import 'package:ordered_set/comparing.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'callback_pre_render_layer.dart';
import 'car/car_sprite.dart';
import 'cloud/cloud_sprite.dart';
import 'helper/double_animation.dart';
import 'helper/inertial_motion.dart';
import 'helper/translate_animation.dart';
import 'model/tile_info.dart';

/*
 * 缩放回调中手势分类
 */
enum _GestureType {
  translate,
  scale,
  rotate,
}

///最大放大倍数
const double MaxScale = 2;

///两点之间随机选一个点
Position positionAmong({@required Position beginPosition, @required Position endPosition, @required int movePercent}) {
  assert(movePercent != null);
  if (beginPosition == null || endPosition == null) return beginPosition ?? endPosition;
  return Position(beginPosition.x + (endPosition.x - beginPosition.x) * movePercent / 100, beginPosition.y + (endPosition.y - beginPosition.y) * movePercent / 100);
}

class CustomGame extends BaseGame with TapDetector, ScaleDetector {
  //scal开始的时候的scal记录
  double _scaleStart;
  //开始手势对应地图canvas的坐标
  Offset _startPointFromGame;
  //最终游戏canvas的scale
  double _scale = 1.0;
  //保存最终游戏canvas偏移
  Offset _translateAfterScale = Offset.zero;

  ///记录手势类型
  _GestureType gestureType;

  //手势停止后的惯性移动动画
  TranslateAnimation _translateAnimation;
  //放大过大的时候从新缩小动画
  DoubleAnimation _scaleAnimation;

  ///地图component不添加到CustomGame，而是在_mapLayer中绘制出完整的地图缓存使用，以免每次都绘制一次浪费性能
  final Map<TileMapLocation, TileComponent> _tileComponentLocationMap = {};

  ///地图背景layer
  CallbackPreRenderedLayer _mapLayer;
  ///云
  CloudSprite _cloudSprite;
  @override
  bool debugMode() {
    return true;
  }

  CustomGame() {
    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < 6; x++) {
        TileComponent tileComponent = TileComponent(tileMapLocation: TileMapLocation(x, y), tileImage: 'map_tile_0.png', tileViewImage: 'map_tile_view_0.png');
        addTileComponent(tileComponent);
      }
    }
  
    // Future.delayed(Duration(seconds: 2), () {
    //   ///添加十个小人
    //   List.generate(10, (index) => randomAddPerson());
    // });

    ///异步，要不size值为null
    Timer.run(() {
      _cloudSprite = CloudSprite(size);
    });
  }

  @override
  void onScaleStart(ScaleStartDetails details) {
    super.onScaleStart(details);
    gestureType = null;
    _scaleStart = _scale;
    _translateAnimation?.dispose();
    _translateAnimation = null;
    _scaleAnimation?.dispose();
    _scaleAnimation = null;
    _startPointFromGame = fromGame(details.localFocalPoint);
  }

  @override
  void onScaleUpdate(ScaleUpdateDetails details) {
    super.onScaleUpdate(details);

    if (gestureType == null) {
      if ((details.scale - 1).abs() > details.rotation.abs()) {
        gestureType = _GestureType.scale;
      } else if (details.rotation != 0) {
        gestureType = _GestureType.rotate;
      } else {
        gestureType = _GestureType.translate;
      }
    }

    if (gestureType != null) {
      Offset gameFocalPoint = fromGame(details.localFocalPoint);
      switch (gestureType) {
        case _GestureType.translate:
          if (_startPointFromGame != null) {
            _translateAfterScale += gameFocalPoint - _startPointFromGame;
            confirmTranslateInRange();
          }
          break;
        case _GestureType.scale:
          if (_scaleStart != null) {
            _scale = details.scale * _scaleStart;
            _scale = max(_scale, 1);
            _scale = min(1.1 * MaxScale, _scale);
            Offset gameFocalPointNext = fromGame(details.localFocalPoint);
            _translateAfterScale += gameFocalPointNext - gameFocalPoint;
            confirmTranslateInRange();
          }
          break;
        case _GestureType.rotate:
          break;
      }
    }
  }

  @override
  void onScaleEnd(ScaleEndDetails details) {
    super.onScaleEnd(details);
    _scaleStart = null;
    _translateAnimation?.dispose();
    if (details.velocity.pixelsPerSecond.dx.abs() > 0) {
      _translateAnimation = TranslateAnimation(
          start: _translateAfterScale,
          end: InertialMotion(details.velocity, _translateAfterScale).finalPosition,
          speed: 300,
          curve: Curves.easeOut,
          change: (value) {
            _translateAfterScale = value;
            confirmTranslateInRange();
          },
          complete: () {
            _translateAnimation.dispose();
            _translateAnimation = null;
          });
    }
    _scaleAnimation?.dispose();
    if (_scale > MaxScale) {
      _scaleAnimation = DoubleAnimation(
          start: _scale,
          end: MaxScale,
          speed: 1,
          curve: Curves.easeOut,
          change: (value) {
            _translateAfterScale = (_startPointFromGame + _translateAfterScale) * _scale / value - _startPointFromGame;
            confirmTranslateInRange();
            _scale = value;
          },
          complete: () {
            _scaleAnimation.dispose();
            _scaleAnimation = null;
            _startPointFromGame = null;
          });
    } else {
      _startPointFromGame = null;
    }
  }

  ///将game的viewportPoint点转换成game中canvas的点
  Offset fromGame(Offset viewportPoint) {
    return (viewportPoint - _translateAfterScale * _scale) / _scale;
  }

  ///确保translate在一定范围之内
  void confirmTranslateInRange() {
    _translateAfterScale = Offset(
      min(size.width, max(-size.width, _translateAfterScale.dx)),
      min(size.height, max(-size.height, _translateAfterScale.dy)),
    );
  }

  void addTileComponent(TileComponent tileComponent) {
    assert(tileComponent != null);
    _tileComponentLocationMap[tileComponent.tileMapLocation] = tileComponent;
    TileComponent topTileComponent = _tileComponentLocationMap[TileMapLocation(tileComponent.tileMapLocation.tileMapX, tileComponent.tileMapLocation.tileMapY - 1)];
    TileComponent leftTileComponent = _tileComponentLocationMap[TileMapLocation(tileComponent.tileMapLocation.tileMapX - 1, tileComponent.tileMapLocation.tileMapY)];
    TileComponent bottomTileComponent = _tileComponentLocationMap[TileMapLocation(tileComponent.tileMapLocation.tileMapX, tileComponent.tileMapLocation.tileMapY + 1)];
    TileComponent rightTileComponent = _tileComponentLocationMap[TileMapLocation(tileComponent.tileMapLocation.tileMapX + 1, tileComponent.tileMapLocation.tileMapY)];

    if (topTileComponent != null) {
      tileComponent.linkWithTileComponent(tileComponent: topTileComponent, borderOrientation: BorderOrientation.Top);
    }
    if (leftTileComponent != null) {
      tileComponent.linkWithTileComponent(tileComponent: leftTileComponent, borderOrientation: BorderOrientation.Left);
    }
    if (bottomTileComponent != null) {
      tileComponent.linkWithTileComponent(tileComponent: bottomTileComponent, borderOrientation: BorderOrientation.Bottom);
    }
    if (rightTileComponent != null) {
      tileComponent.linkWithTileComponent(tileComponent: rightTileComponent, borderOrientation: BorderOrientation.Right);
    }
  }

  ///随机添加小车
  void randomAddCar() {
    randomPosition((endNode, position) {
      ///添加小车
      add(CarSprite(endPathNode: endNode, initialPosition: position));
    });
  }

  ///随机添加小人
  void randomAddPerson() {
    randomPosition((endNode, position) {
      PersonSprite personSprite = PersonSprite(
        endPathNode: endNode,
        initialPosition: position,
        faceColor: ColorHelper.faces.randomItem,
        bodyImage: ImageHelper.bodys.randomItem,
        eyeImage: ImageHelper.eyes.randomItem,
        footImage: ImageHelper.foots.randomItem,
        hairImage: ImageHelper.hairs.randomItem,
        handImage: ImageHelper.hands.randomItem,
        noseImage: ImageHelper.noses.randomItem,
      );

      add(personSprite);
      personSprite.enter(targetEndNode: endNode, targetPosition: position);
    });
  }

  void randomPosition(void callback(PathNode endNode, Position position)) {
    TileComponent tile = _tileComponentLocationMap?.values?.randomItem;
    tile?.randomPath(({beginNode, endNode}) {
      if (beginNode != null && endNode != null) {
        Position position = positionAmong(beginPosition: beginNode.position, endPosition: endNode.position, movePercent: Random().nextInt(100));
        callback?.call(endNode, position);
      }
    });
  }

  void jump() {
    List<PersonSprite> personSprite = List<PersonSprite>.from(components.where((element) => element is PersonSprite));
    _tileComponentLocationMap.values?.randomItem?.randomPath(({beginNode, endNode}) {
      int movePercent = Random().nextInt(100);
      Position target = positionAmong(beginPosition: beginNode.position, endPosition: endNode.position, movePercent: movePercent);
      personSprite.randomItem?.jumpto(targetEndNode: endNode, targetCenter: target);
    });
  }

  void jumpInplace() {
    List<PersonSprite> personSprite = List<PersonSprite>.from(components.where((element) => element is PersonSprite));
    personSprite.randomItem?.jumpInPlace();
  }

  void showRemider() {
    List<PersonSprite> personSprite = List<PersonSprite>.from(components.where((element) => element is PersonSprite));
    personSprite.randomItem?.showRemider();
  }

  double showRemiderTimeCount = 0;
  double jumpTimeCount = 0;
  double jumpInPlaceTimeCount = 0;
  @override
  void update(double t) {
    super.update(t);
    showRemiderTimeCount += t;
    if (showRemiderTimeCount > 5) {
      showRemiderTimeCount = 0;
      // jump();
      showRemider();
    }

    jumpTimeCount += t;
    if (jumpTimeCount > 7) {
      jumpTimeCount = 0;
      jump();
    }

    jumpInPlaceTimeCount += t;
    if (jumpInPlaceTimeCount > (components.length > 15 ? 3 : 7)) {
      jumpInPlaceTimeCount = 0;
      jumpInplace();
    }

    _translateAnimation?.update(t);
    _scaleAnimation?.update(t);
    _cloudSprite?.update(t);
    OrderedSet<Component> tmpComponents = OrderedSet(Comparing.on((c) => c.priority()));
    tmpComponents.addAll(components);
    components = tmpComponents;

    if (_mapLayer == null) {
      if (_tileComponentLocationMap.values.every((element) => element.loaded())) {
        _mapLayer = CallbackPreRenderedLayer(drawLayerCallback: (canvas) {
          _tileComponentLocationMap?.forEach((key, value) {
            value.render(canvas);
          });
        });
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.scale(_scale, _scale);
    if (_translateAfterScale != null) {
      canvas.translate(_translateAfterScale.dx, _translateAfterScale.dy);
    }

    // canvas.translate(60, 60);
    // canvas.scale(2, 2);
    _mapLayer?.render(canvas);
    super.render(canvas);
    canvas.restore();
    canvas.save();
    _cloudSprite?.render(canvas);
    canvas.restore();
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    components.where((element) => element is PersonSprite).forEach((element) {
      (element as PersonSprite).handleTapDown(fromGame(details.localPosition));
    });
  }

  @override
  Color backgroundColor() {
    return Color.fromRGBO(142, 211, 240, 1);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      // pause your updates
      // pause all audio players
      pauseEngine();
      print('pase');
    } else {
      // resume your updates
      // resume all audio players
      resumeEngine();
    }

    super.lifecycleStateChange(state);
  }
}
