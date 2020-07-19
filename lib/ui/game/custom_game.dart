import 'dart:math';

import 'package:cityCloud/ui/game/model/tile_location.dart';
import 'package:cityCloud/ui/game/person_sprite.dart';
import 'package:cityCloud/ui/game/tile_component.dart';
import 'package:cityCloud/ui/game/model/tile_info.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/layer/layer.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'helper/inertial_motion.dart';
import 'helper/translate_animation.dart';
import 'model/tile_info.dart';

enum _GestureType {
  translate,
  scale,
  rotate,
}

Position positionAmong({@required Position beginPosition, @required Position endPosition, @required int movePercent}) {
  assert(movePercent != null);
  if (beginPosition == null || endPosition == null) return beginPosition ?? endPosition;
  return Position(beginPosition.x + (endPosition.x - beginPosition.x) * movePercent / 100, beginPosition.y + (endPosition.y - beginPosition.y) * movePercent / 100);
}

class CustomGame extends BaseGame with TapDetector, ScaleDetector {
  double _scale = 1.0;
  //scal开始的时候的scal记录
  double _scaleStart;
  //开始手势对应地图的坐标
  Offset _startPointFromGame;

  //最终移动
  Offset _translateAfterScale = Offset.zero;
  
  ///记录手势类型
  _GestureType gestureType;

  //手势停止后的移动动画
  TranslateAnimation _translateAnimation;

  ///地图component不添加到CustomGame，而是在_mapLayer中绘制出完整的地图缓存使用，以免每次都绘制一次浪费性能
  final Map<TileMapLocation, TileComponent> _tileComponentLocationMap = {};
  MapLayer _mapLayer;
  // @override
  // bool debugMode() {
  //   // TODO: implement debugMode
  //   return true;
  // }

  CustomGame() {
    Sprite.loadSprite(
      'map_tile_0.png',
    ).then((value) {
      for (int y = 0; y < 10; y++) {
        for (int x = 0; x < 6; x++) {
          TileComponent tileComponent = TileComponent(tileMapLocation: TileMapLocation(x, y));
          tileComponent.sprite = value;
          addTileComponent(tileComponent);
        }
      }
      _mapLayer = MapLayer(drawLayerCallback: (canvas) {
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
    _startPointFromGame = fromGame(details.localFocalPoint);
  }

  @override
  void onScaleUpdate(ScaleUpdateDetails details) {
    super.onScaleUpdate(details);

    if (gestureType == null) {
      // Decide which type of gesture this is by comparing the amount of scale
      // and rotation in the gesture, if any. Scale starts at 1 and rotation
      // starts at 0. Translate will have 0 scale and 0 rotation because it uses
      // only one finger.
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
          }
          break;
        case _GestureType.scale:
          if (_scaleStart != null) {
            _scale = details.scale * _scaleStart;
            Offset gameFocalPointNext = fromGame(details.localFocalPoint);
            _translateAfterScale += gameFocalPointNext - gameFocalPoint;
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
    _startPointFromGame = null;
    _translateAnimation?.dispose();
    _translateAnimation = TranslateAnimation(
        start: _translateAfterScale,
        end: InertialMotion(details.velocity, _translateAfterScale).finalPosition,
        speed: 300,
        curve: Curves.easeOut,
        change: (value) {
          _translateAfterScale = value;
          print(_translateAfterScale);
        },
        complete: () {
          _translateAnimation.dispose();
          _translateAnimation = null;
        });
  }

  // Return the gape point at the given viewport point.
  Offset fromGame(Offset viewportPoint) {
    return (viewportPoint - _translateAfterScale * _scale) / _scale;
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
    // add(tileComponent);
    addPersonSpriteToTileComponent(tileComponent: tileComponent);
  }

  Future<void> addPersonSprite({@required PathNode beginNode, @required PathNode endNode, @required int movePercent}) async {
    PersonSprite personSprite = PersonSprite(25, 25);
    personSprite.beginPathNode = beginNode;
    personSprite.endPathNode = endNode;
    personSprite.center = positionAmong(beginPosition: beginNode.position, endPosition: endNode.position, movePercent: movePercent);
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

  @override
  void update(double t) {
    super.update(t);
    // timeCont += t;
    // if (timeCont > 5) {
    //   timeCont = 0;
    //   jump();
    // }
    _translateAnimation?.update(t);
  }

  @override
  void render(Canvas canvas) {
    canvas.scale(_scale, _scale);
    if (_translateAfterScale != null) {
      canvas.translate(_translateAfterScale.dx, _translateAfterScale.dy);
    }

    // canvas.scale(1, 2);
    // canvas.translate(60, 60);
    _mapLayer?.render(canvas);
    super.render(canvas);
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

class MapLayer extends PreRenderedLayer {
  final ValueChanged<Canvas> drawLayerCallback;

  MapLayer({this.drawLayerCallback});

  @override
  void render(Canvas canvas, {double x = 0.0, double y = 0.0}) {
    super.render(canvas);
  }

  @override
  void drawLayer() {
    drawLayerCallback?.call(canvas);
  }
}
