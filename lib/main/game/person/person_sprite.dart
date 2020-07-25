import 'dart:async';

import 'package:cityCloud/expanded/cubit/global_cubit.dart';
import 'package:cityCloud/main/game/person/part_of_person/body.dart';
import 'package:cityCloud/main/game/person/part_of_person/foot.dart';
import 'package:cityCloud/main/game/person/part_of_person/hand.dart';
import 'package:cityCloud/main/game/person/part_of_person/head.dart';
import 'package:cityCloud/main/game/person/part_of_person/remider.dart';
import 'package:cityCloud/main/game/person/person_const_data.dart';
import 'package:flame/components/component.dart';

import 'package:flame/effects/effects.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../callback_pre_render_layer.dart';
import '../model/tile_info.dart';
import 'package:ordered_set/ordered_set.dart';
import 'package:ordered_set/comparing.dart';

class PersonSprite extends PositionComponent {
  ///动态的部分，如手脚一直在动的就放在_dynamicComponents中
  OrderedSet<Component> _dynamicComponents = OrderedSet(Comparing.on((c) => c.priority()));

  ///静态的部分，如身体和头这些随人物整体移动，没有自身动画的就放在_quietComponents中，然后渲染到_quietLayer���缓存
  OrderedSet<Component> _quietComponents = OrderedSet(Comparing.on((c) => c.priority()));

  ///用于判断是否所有_quietComponents都已经loaded
  bool _isQuietcomponentsAllLoaded = false;
  CallbackPreRenderedLayer _quietLayer;

  ///小人面朝向
  HorizontalOrigentation _faceOrigentation;

  ///小人各部位的sprite
  FootSprite _leftFootSprite;
  FootSprite _rightFootSprite;
  HandSprite _leftHandSprite;
  HandSprite _rightHandSprite;
  BodySprite _bodySprite;
  HeadSprite _headSprite;

  ///头顶提示sprite
  RemiderSprite _remiderSprite;

  ///隐藏提示定时器
  Timer _hideRemiderTimer;

  ///移动effect
  MoveEffect _moveEffect;

  ///运动的终点
  PathNode _endPathNode;

  ///跳的时候存储的信息
  JumpInfo jumpInfo;

  PersonSprite({@required Position initialPosition, @required PathNode endPathNode}) : assert(initialPosition != null && endPathNode != null) {
    _endPathNode = endPathNode;
    x = initialPosition.x;
    y = initialPosition.y;
    resetMoveEffect();
    _leftFootSprite = FootSprite(origentation: HorizontalOrigentation.Left);
    _rightFootSprite = FootSprite(origentation: HorizontalOrigentation.Right);
    _bodySprite = BodySprite(origentation: HorizontalOrigentation.Left);
    _leftHandSprite = HandSprite(origentation: HorizontalOrigentation.Left);
    _rightHandSprite = HandSprite(origentation: HorizontalOrigentation.Right);

    _headSprite = HeadSprite(origentation: HorizontalOrigentation.Right);

    _dynamicComponents.add(_leftFootSprite);
    _dynamicComponents.add(_rightFootSprite);
    _dynamicComponents.add(_leftHandSprite);
    _dynamicComponents.add(_rightHandSprite);

    _quietComponents.add(_bodySprite);
    // _quietComponents.add(_headSprite);

    _quietLayer = CallbackPreRenderedLayer(drawLayerCallback: (canvas) {
      canvas.save();
      _quietComponents?.forEach((value) {
        if (value.loaded()) {
          value.render(canvas);
          canvas.restore();
        }
      });
    });
  }

  void resetMoveEffect() {
    _moveEffect = MoveEffect(destination: _endPathNode.position, curve: Curves.linear, speed: MoveSpeed);
    addEffect(_moveEffect);
    if (_moveEffect.endPosition.x > x) {
      _faceOrigentation = HorizontalOrigentation.Right;
    } else if (_moveEffect.endPosition.x < x) {
      _faceOrigentation = HorizontalOrigentation.Left;
    } else if (_faceOrigentation == null) {
      _faceOrigentation = HorizontalOrigentation.values[Random().nextInt(1)];
    }
  }

  void jumpto({@required PathNode targetEndNode, @required Position targetCenter}) {
    // if (jumpInfo == null) {
    //   endPathNode = targetEndNode;
    //   jumpInfo = JumpInfo(
    //       originPosition: toPosition(),
    //       originSize: Size(width, height),
    //       targetCenterPosition: targetCenter,
    //       targetEndPathNode: targetEndNode);
    //   jumpInfo.upEffects?.forEach((element) {
    //     addEffect(element);
    //   });
    // }
  }

  void _updateJumpStatus(double dt) {
    if (jumpInfo.time > jumpInfo.scaleTravelTime && jumpInfo.jumpStatus != JumpStatus.Downing) {
      jumpInfo.time = jumpInfo.scaleTravelTime;
      clearEffects();
      setByPosition(jumpInfo.downBeginPosition);
      setBySize(Position.fromSize(jumpInfo.scaleSize));
      jumpInfo.jumpStatus = JumpStatus.Downing;
      jumpInfo.downEffects?.forEach((element) {
        addEffect(element);
      });
    }

    if (jumpInfo.time > jumpInfo.scaleTravelTime * 2 && jumpInfo.jumpStatus != JumpStatus.Finish) {
      clearEffects();
      width = jumpInfo.originSize.width;
      height = jumpInfo.originSize.height;
      // center = jumpInfo.targetCenterPosition;
      jumpInfo.jumpStatus = JumpStatus.Finish;
      jumpInfo = null;
    }
    if (jumpInfo != null) {
      jumpInfo.time += dt;
    }
  }

  void showRemider() {
    if (_remiderSprite == null) {
      _remiderSprite = RemiderSprite.fromSprite(
        20,
        20,
      );
      _remiderSprite.x = -10;
      _remiderSprite.y = -FootHeight - BodyHeight - HeadHeight - 20;
      _dynamicComponents.add(_remiderSprite);
      _hideRemiderTimer?.cancel();
      _hideRemiderTimer = Timer(Duration(seconds: 5), () {
        _hideRemiderTimer?.cancel();
        if (_dynamicComponents.contains(_remiderSprite)) {
          _dynamicComponents.remove(_remiderSprite);
        }
        _remiderSprite = null;
      });
    }
  }

  @override
  int priority() {
    return y.toInt();
  }

  /**
   * 四个Tapable相关方法只处理头部弹出的提示的点击
   */
  void onTapDown() {
    GlobalCubit().add(GlobalTapOnPersionSpriteRemider());
  }

  void handleTapDown(Offset o) {
    if (checkTapOverlap(o)) {
      onTapDown();
    }
  }

  bool checkTapOverlap(Offset o) {
    return _remiderSprite != null && toRect().contains(o);
  }

  @override
  Rect toRect() => Rect.fromLTWH(x - 10, y - FootHeight - BodyHeight - HeadHeight - 20, 20, 20);

  @override
  void update(double dt) {
    super.update(dt);

    if (jumpInfo != null) {
      _updateJumpStatus(dt);
    } else {
      if (_moveEffect?.isMax() == true) {
        removeEffect(_moveEffect);
        _endPathNode = _endPathNode.randomLinkedNode;
        if (_endPathNode != null) {
          resetMoveEffect();
        }
      }
      _headSprite.update(dt);
      _dynamicComponents.forEach((c) {
        c.update(dt);
      });
      _dynamicComponents.removeWhere((c) => c.destroy());
    }
    if (!_isQuietcomponentsAllLoaded) {
      _isQuietcomponentsAllLoaded = true;
      Timer.run(() {
        _quietComponents?.firstWhere((value) {
          if (!value.loaded()) {
            _isQuietcomponentsAllLoaded = false;
            return true;
          }
          return false;
        }, orElse: () => null);
        if (_isQuietcomponentsAllLoaded) {
          _quietLayer.reRender();
        }
      });
    }
  }

  @override
  void render(Canvas canvas) {
    ///身体
    canvas.save();
    canvas.translate(x, y);
    if (_faceOrigentation == HorizontalOrigentation.Right) {
      ///小人往右
      canvas.scale(-1.0, 1.0);
    }
    _quietLayer?.render(
      canvas,
    );
    canvas.restore();

    ///画脚下阴影
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: 16, height: 8),
      Paint()..color = Colors.grey.withOpacity(0.5),
    );
    ///手脚
    canvas.save();
    _dynamicComponents.forEach((comp) => _renderComponent(canvas, comp));
    canvas.restore();
    ///头
    canvas.save();
    canvas.translate(x, y);
    if (_faceOrigentation == HorizontalOrigentation.Right) {
      ///小人往右
      canvas.scale(-1.0, 1.0);
    }
    _headSprite.render(canvas);
    canvas.restore();
  }

  void _renderComponent(Canvas canvas, Component c) {
    if (!c.loaded()) {
      return;
    }
    canvas.translate(x, y);
    c.render(canvas);
    canvas.restore();
    canvas.save();
  }
}

enum JumpStatus { Upping, Downing, Finish }

class JumpInfo {
  final Size scaleSize;
  final Size originSize;
  final Position originPosition;

  final Position targetCenterPosition;
  final PathNode targetEndPathNode;

  final double scaleSpeed;
  final double upMoveDistance;

  double scaleTravelTime;

  List<PositionComponentEffect> _upEffects;
  List<PositionComponentEffect> get upEffects => _upEffects;

  List<PositionComponentEffect> _downEffects;
  List<PositionComponentEffect> get downEffects => _downEffects;

  Position get downBeginPosition => Position(targetCenterPosition.x, targetCenterPosition.y - upMoveDistance);

  ///用来判断状态变换的
  double time = 0;
  JumpStatus jumpStatus;

  JumpInfo({
    @required this.originSize,
    @required this.originPosition,
    @required this.targetCenterPosition,
    @required this.targetEndPathNode,
    this.scaleSize = const Size(0, 60),
    this.scaleSpeed = 200,
    this.upMoveDistance = 80,
  }) {
    final scaleDistance = sqrt(pow(scaleSize.width - originSize.width, 2) + pow(scaleSize.height - originSize.height, 2));
    scaleTravelTime = scaleDistance / scaleSpeed;

    Position scaleTargetPosition = Position(originPosition.x + originSize.width / 2, originPosition.y - upMoveDistance);
    final moveDistance = sqrt(pow(scaleTargetPosition.x - originPosition.x, 2) + pow(scaleTargetPosition.y - originPosition.y, 2));
    double targetSpeed = moveDistance / scaleTravelTime;

    _upEffects = [
      ScaleEffect(
        size: scaleSize,
        speed: scaleSpeed,
        curve: Curves.linear,
      ),
      MoveEffect(speed: targetSpeed, destination: scaleTargetPosition, curve: Curves.linear),
    ];

    _downEffects = [
      ScaleEffect(
        size: originSize,
        speed: scaleSpeed,
        curve: Curves.linear,
      ),
      MoveEffect(speed: targetSpeed, destination: Position(targetCenterPosition.x - originSize.width / 2, targetCenterPosition.y - originSize.height / 2), curve: Curves.linear),
    ];
  }
}
