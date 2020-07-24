import 'dart:math';

import 'package:cityCloud/main/game/model/tile_location.dart';
import 'package:cityCloud/main/game/person_sprite.dart';
import 'package:cityCloud/main/game/tile_component.dart';
import 'package:cityCloud/main/game/model/tile_info.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'callback_pre_render_layer.dart';
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
  CallbackLayer _mapLayer;
  @override
  bool debugMode() {
    return true;
  }

  CustomGame() {
    Sprite.loadSprite(
      'map_tile_0.png',
    ).then((value) {
      for (int y = 0; y < 10; y++) {
        for (int x = 0; x < 6; x++) {
          TileComponent tileComponent = TileComponent(tileMapLocation: TileMapLocation(x, y));
          tileComponent.sprite = value;
          addTileComponent(tileComponent);
          addPersonSpriteToTileComponent(tileComponent: tileComponent);
        }
      }
      _mapLayer = CallbackLayer(drawLayerCallback: (canvas) {
        _tileComponentLocationMap?.forEach((key, value) {
          value.render(canvas);
        });
      });
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

  Future<void> addPersonSprite({@required PathNode beginNode, @required PathNode endNode, @required int movePercent}) async {
    PersonSprite personSprite =
        PersonSprite(endPathNode: endNode, initialPosition: positionAmong(beginPosition: beginNode.position, endPosition: endNode.position, movePercent: movePercent));

    add(personSprite);
  }

  void addPersonSpriteToTileComponent({@required TileComponent tileComponent}) {
    tileComponent?.randomPath(({beginNode, endNode}) {
      int movePercent = Random().nextInt(100);
      addPersonSprite(beginNode: beginNode, endNode: endNode, movePercent: movePercent);
    });
  }

  double timeCont = 0;

  void jump() {
    List<TileComponent> tiles = List<TileComponent>.from(components.where((element) => element is TileComponent));
    List<PersonSprite> personSprite = List<PersonSprite>.from(components.where((element) => element is PersonSprite));
    tiles[Random().nextInt(tiles.length)].randomPath(({beginNode, endNode}) {
      int movePercent = Random().nextInt(100);
      Position target = positionAmong(beginPosition: beginNode.position, endPosition: endNode.position, movePercent: movePercent);
      personSprite[Random().nextInt(personSprite.length)].jumpto(targetEndNode: endNode, targetCenter: target);
    });
  }

  void showRemider() {
    List<PersonSprite> personSprite = List<PersonSprite>.from(components.where((element) => element is PersonSprite));
    personSprite[Random().nextInt(personSprite.length)].showRemider();
  }

  @override
  void update(double t) {
    super.update(t);
    timeCont += t;
    if (timeCont > 5) {
      timeCont = 0;
      // jump();
      showRemider();
    }
    _translateAnimation?.update(t);
    _scaleAnimation?.update(t);
  }

  @override
  void render(Canvas canvas) {
    canvas.scale(_scale, _scale);
    if (_translateAfterScale != null) {
      canvas.translate(_translateAfterScale.dx, _translateAfterScale.dy);
    }

    // canvas.scale(2, 2);
    // canvas.translate(60, 60);
    _mapLayer?.render(canvas);
    canvas.save();
    components.toList()
      ..sort((a, b) => a.priority().compareTo(b.priority()))
      ..forEach((comp) => renderComponent(canvas, comp));
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
