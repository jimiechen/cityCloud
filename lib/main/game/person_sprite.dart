import 'dart:async';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/effects/effects.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'callback_pre_render_layer.dart';
import 'model/tile_info.dart';
import 'package:ordered_set/ordered_set.dart';
import 'package:ordered_set/comparing.dart';

enum HorizontalOrigentation {
  Left,
  Right,
}

const double MoveSpeed = 5; //移动速度

const double FootSpacing = 2; //两脚之间距离
const double FootSpeed = 10; //抬脚速度
const double FootPutUpHeight = 2; //脚抬起的高度
const double FootHeight = 8; //脚的高度
const double FootWidth = 2; //脚的宽度

const double HandHeight = 18; //手臂的高度
const double HandWidth = 2; //手臂的宽度
const double HandSpacing = 8; //手臂的间隔
const double HandRotateSpeed = 1; //手臂旋转速度
const double HandRotateRadians = 0.5; //手臂旋转的弧度

const double BodyWidth = 20; //身体宽度
const double BodyHeight = 18; //身体高度
const double BodyOffset = 2; //以为身体有屁股，所以要设置偏移

const double HeadHeight = 18; //头高
const double HeadWidth = 18; //头宽

const double EyeHeight = 6.45; //眼睛宽度
const double EyeWidth = 15; //眼睛高度

/** 
 * 一开始左脚是抬起来的
 */
class FootSprite extends SpriteComponent implements PersonComponent {
  double _originHeight;
  final HorizontalOrigentation origentation;
  FootSprite(
      {@required double personX,
      @required double personY,
      double footWidth = FootWidth,
      double footHeight = FootHeight,
      this.origentation}) {
    assert(personX != null && personY != null && footWidth != null && footHeight != null);
    x = origentation == HorizontalOrigentation.Left ? personX - width - FootSpacing / 2 : personX + FootSpacing / 2;
    y = personY - height;
    width = footWidth;
    _originHeight = footHeight;
    height = origentation == HorizontalOrigentation.Left ? footHeight - FootPutUpHeight : footHeight;

    Sprite.loadSprite('people-leg-5.png').then((value) {
      sprite = value;
      this.addEffect(
        ScaleEffect(
          size: Size(
              width, origentation == HorizontalOrigentation.Left ? _originHeight : _originHeight - FootPutUpHeight),
          isInfinite: true,
          isAlternating: true,
          curve: Curves.linear,
          speed: FootSpeed,
        ),
      );
    });
  }

  void updatePosition({@required double personX, @required double personY}) {
    assert(personX != null && personY != null);
    x = origentation == HorizontalOrigentation.Left ? personX - width - FootSpacing / 2 : personX + FootSpacing / 2;
    y = personY - _originHeight;
  }
}

class HandRotateEffect extends PositionComponentEffect {
  double radians;
  double speed;
  Curve curve;

  double _originalAngle;
  double _peakAngle;

  HandRotateEffect({
    @required this.radians, // As many radians as you want to rotate
    @required this.speed, // In radians per second
    this.curve,
    isInfinite = false,
    isAlternating = false,
  }) : super(isInfinite, isAlternating);

  @override
  void initialize(_comp) {
    super.initialize(_comp);
    if (!isAlternating) {
      endAngle = _comp.angle + radians;
    }
    _originalAngle = component.angle;
    _peakAngle = _originalAngle + radians;
    travelTime = (radians / speed).abs();
  }

  @override
  void update(double dt) {
    super.update(dt);
    final double c = curve?.transform(percentage) ?? 1.0;
    component.angle = _originalAngle + _peakAngle * c;
  }
}

class HandSprite extends SpriteComponent implements PersonComponent {
  final HorizontalOrigentation origentation;
  final double footAndBodyHeight;
  HandSprite(
      {@required double personX,
      @required double personY,
      double handWidth = HandWidth,
      double handHeight = HandHeight,
      this.footAndBodyHeight = FootHeight + BodyHeight,
      this.origentation}) {
    assert(personX != null && personY != null && handWidth != null && handHeight != null);
    x = origentation == HorizontalOrigentation.Left ? personX - width - HandSpacing / 2 : personX + HandSpacing / 2;
    y = personY - footAndBodyHeight;
    width = handWidth;
    height = handHeight;

    Sprite.loadSprite('people-hand-2.png').then((value) {
      sprite = value;
      this.addEffect(
        HandRotateEffect(
            isInfinite: true,
            isAlternating: true,
            curve: Curves.linear,
            speed: HandRotateSpeed,
            radians: origentation == HorizontalOrigentation.Left ? HandRotateRadians : -HandRotateRadians),
      );
    });
  }

  void updatePosition({@required double personX, @required double personY}) {
    assert(personX != null && personY != null);
    x = origentation == HorizontalOrigentation.Left ? personX - width - HandSpacing / 2 : personX + HandSpacing / 2;
    y = personY - footAndBodyHeight;
  }
}

class BodySprite extends SpriteComponent implements PersonComponent {
  final HorizontalOrigentation origentation;
  double _footHeight;
  BodySprite(
      {double bodyWidth = BodyWidth,
      double bodyHeight = BodyHeight,
      double footHeight = FootHeight,
      this.origentation}) {
    assert(bodyWidth != null && bodyHeight != null && footHeight != null);
    _footHeight = footHeight;
    x = -bodyWidth / 2 + BodyOffset;
    y = -bodyHeight - footHeight + 1;
    width = bodyWidth;
    height = bodyHeight;

    Sprite.loadSprite(
      'people-body-5.png',
    ).then((value) {
      sprite = value;
    });
  }

  void updatePosition({@required double personX, @required double personY}) {
    assert(personX != null && personY != null);
    x = personX - width / 2 + 2;
    y = personY - height - _footHeight;
    if (origentation == HorizontalOrigentation.Left) {
      y += BodyOffset;
    } else {
      y -= BodyOffset;
    }
  }
}

class HeadSprite extends PositionComponent with HasGameRef implements PersonComponent {
  OrderedSet<Component> components = OrderedSet(Comparing.on((c) => c.priority()));
  final HorizontalOrigentation origentation;
  final double footAndBodyHeight;

  SpriteComponent hairComponent;
  SpriteComponent noseComponent;

  double _timeCount = 0;
  SequenceEffect _eyeEffect;

  HeadSprite(
      {double headWidth = HeadWidth,
      double headHeight = HeadHeight,
      this.footAndBodyHeight = FootHeight + BodyHeight,
      this.origentation}) {
    assert(headWidth != null && headHeight != null);
    width = headWidth;
    height = headHeight;

    Sprite.loadSprite('people-hair-2.png').then((value) {
      hairComponent = SpriteComponent.fromSprite(30, 30, value);
      hairComponent.x = -14;
      hairComponent.y = -footAndBodyHeight - 23;
      add(hairComponent);
    });
  }

  @override
  bool loaded() {
    return components.length == 1;
  }

  void add(Component c) {
    if (gameRef is BaseGame) {
      (gameRef as BaseGame).preAdd(c);
    }
    components.add(c);
  }

  @override
  void render(Canvas canvas) {
    Paint paint = Paint()..color = Colors.yellow;
    canvas.drawCircle(Offset(0, -footAndBodyHeight - 7), 9, paint);
    canvas.save();
    components.forEach((comp) => _renderComponent(canvas, comp));
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

  void updatePosition({@required double personX, @required double personY}) {
    assert(personX != null && personY != null);
    x = personX - width / 2;
    y = personY - footAndBodyHeight - height * 0.7;
    hairComponent.x = x;
    hairComponent.y = y;
  }
}

abstract class PersonComponent {
  void updatePosition({@required double personX, @required double personY});
}

class PersonSprite extends PositionComponent {
  ///动态的部分，如手脚一直在动的就放在_dynamicComponents中
  OrderedSet<Component> _dynamicComponents = OrderedSet(Comparing.on((c) => c.priority()));

  ///静态的部分，如身体和头这些随人物整体移动，没有自身动画的就放在_quietComponents中，然后渲染到_quietLayer中缓存
  OrderedSet<Component> _quietComponents = OrderedSet(Comparing.on((c) => c.priority()));

  ///用于判断是否所有_quietComponents都已经loaded
  bool _isQuietcomponentsAllLoaded = false;
  CallbackLayer _quietLayer;

  ///小人面朝向
  HorizontalOrigentation _faceOrigentation;

  ///小人各部位的sprite
  FootSprite _leftFootSprite;
  FootSprite _rightFootSprite;
  HandSprite _leftHandSprite;
  HandSprite _rightHandSprite;
  BodySprite _bodySprite;
  HeadSprite _headSprite;
  SpriteComponent _eyeSprite;

  ///移动effect
  MoveEffect _moveEffect;

  ///运动的终点
  PathNode _endPathNode;

  ///跳的时候存储的信息
  JumpInfo jumpInfo;

  PersonSprite({@required Position initialPosition, @required PathNode endPathNode})
      : assert(initialPosition != null && endPathNode != null) {
    _endPathNode = endPathNode;
    x = initialPosition.x;
    y = initialPosition.y;
    resetMoveEffect();
    _leftFootSprite = FootSprite(personY: y, personX: x, origentation: HorizontalOrigentation.Left);
    _rightFootSprite = FootSprite(personY: y, personX: x, origentation: HorizontalOrigentation.Right);
    _bodySprite = BodySprite(origentation: HorizontalOrigentation.Left);
    _leftHandSprite = HandSprite(personY: y, personX: x, origentation: HorizontalOrigentation.Left);
    _rightHandSprite = HandSprite(personY: y, personX: x, origentation: HorizontalOrigentation.Right);
    _headSprite = HeadSprite(origentation: HorizontalOrigentation.Right);
    _eyeSprite = SpriteComponent.rectangle(EyeWidth, EyeHeight, 'people-eyes-1005.png');
    _eyeSprite.x = -EyeWidth / 2;
    _eyeSprite.y = -BodyHeight - FootHeight - 11;

    _dynamicComponents.add(_leftFootSprite);
    _dynamicComponents.add(_rightFootSprite);
    _dynamicComponents.add(_leftHandSprite);
    _dynamicComponents.add(_rightHandSprite);

    _quietComponents.add(_bodySprite);
    _quietComponents.add(_headSprite);
    _quietComponents.add(_eyeSprite);

    _quietLayer = CallbackLayer(drawLayerCallback: (canvas) {
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
    } else {
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

      _dynamicComponents.forEach((c) {
        (c as PersonComponent).updatePosition(personX: x, personY: y);
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
    canvas.save();
    if (_faceOrigentation == HorizontalOrigentation.Right) {
      ///小人往右
      canvas.translate(x, y);
      canvas.scale(-1.0, 1.0);
      _quietLayer?.render(
        canvas,
      );
    } else {
      _quietLayer?.render(
        canvas,
        x: x,
        y: y,
      );
    }

    canvas.restore();
    canvas.save();
    _dynamicComponents.forEach((comp) => _renderComponent(canvas, comp));
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
    final scaleDistance =
        sqrt(pow(scaleSize.width - originSize.width, 2) + pow(scaleSize.height - originSize.height, 2));
    scaleTravelTime = scaleDistance / scaleSpeed;

    Position scaleTargetPosition = Position(originPosition.x + originSize.width / 2, originPosition.y - upMoveDistance);
    final moveDistance =
        sqrt(pow(scaleTargetPosition.x - originPosition.x, 2) + pow(scaleTargetPosition.y - originPosition.y, 2));
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
      MoveEffect(
          speed: targetSpeed,
          destination:
              Position(targetCenterPosition.x - originSize.width / 2, targetCenterPosition.y - originSize.height / 2),
          curve: Curves.linear),
    ];
  }
}
