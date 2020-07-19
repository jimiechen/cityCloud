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

import 'model/tile_info.dart';
import 'package:ordered_set/ordered_set.dart';
import 'package:ordered_set/comparing.dart';

enum HorizontalOrigentation {
  Left,
  Right,
}
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

const double HeadHeight = 30; //头高
const double HeadWidth = 30; //头宽

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
      {@required double personX,
      @required double personY,
      double bodyWidth = BodyWidth,
      double bodyHeight = BodyHeight,
      double footHeight = FootHeight,
      this.origentation}) {
    assert(personX != null && personY != null && bodyWidth != null && bodyHeight != null && footHeight != null);
    _footHeight = footHeight;
    x = personX - bodyWidth / 2;
    y = personY - height - footHeight + 8;
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

class HeadSprite extends PositionComponent with HasGameRef implements PersonComponent  {
  OrderedSet<Component> components =
      OrderedSet(Comparing.on((c) => c.priority()));
  final HorizontalOrigentation origentation;
  final double footAndBodyHeight;

  SpriteComponent hairComponent;
  SpriteComponent eyeComponent;
  SpriteComponent noseComponent;

  double _timeCount = 0;
  SequenceEffect _eyeEffect;

  HeadSprite(
      {@required double personX,
      @required double personY,
      double headWidth = HeadWidth,
      double headHeight = HeadHeight,
      this.footAndBodyHeight = FootHeight + BodyHeight,
      this.origentation}) {
    assert(personX != null && personY != null && headWidth != null && headHeight != null);
    x = personX - headWidth / 2;
    y = personY - footAndBodyHeight - headHeight;
    width = headWidth;
    height = headHeight;

    Sprite.loadSprite('people-hair-2.png').then((value) {
      hairComponent = SpriteComponent.fromSprite(width, height, value);
      add(hairComponent);
    });
    Sprite.loadSprite('people-eyes-1005.png').then((value) {
      eyeComponent = SpriteComponent.fromSprite(EyeWidth, EyeHeight, value);
      add(eyeComponent);
    });
  }

  void add(Component c) {
    if (gameRef is BaseGame) {
      (gameRef as BaseGame).preAdd(c);
    }
    components.add(c);
  }

  @override
  void update(double t) {
    super.update(t);
    _timeCount += t;
    if (_timeCount > 10 && _eyeEffect == null) {
      _timeCount = 0;
      SequenceEffect effect = SequenceEffect(
          effects: [
            ScaleEffect(
              curve: Curves.linear,
              size: Size(EyeWidth, 1),
              speed: 15,
            ),
            ScaleEffect(
              curve: Curves.linear,
              size: Size(EyeWidth, EyeHeight),
              speed: 15,
            ),
          ],
          onComplete: () {
            _eyeEffect = null;
            eyeComponent.clearEffects();
          });

      eyeComponent.addEffect(effect);
      _eyeEffect = effect;
    }
  }

  @override
  void render(Canvas canvas) {
    Paint paint = Paint()..color = Colors.yellow;
    canvas.drawCircle(Offset(x + width / 2 - 1, y + height / 2), 9, paint);
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
    eyeComponent.x = x + (width - EyeWidth) / 2;
    eyeComponent.y = y + (height - eyeComponent.height) / 2;
  }
}

abstract class PersonComponent {
  void updatePosition({@required double personX, @required double personY});
}

class PersonSprite extends PositionComponent with HasGameRef {
  OrderedSet<Component> components =
      OrderedSet(Comparing.on((c) => c.priority()));
  ///运动的起始点和终点
  PathNode beginPathNode;
  PathNode endPathNode;

  ///移动比例，也就是从beginPathNode到endPathNode移动了多少
  int movePercent;

  ///跳的时候存储的信息
  JumpInfo jumpInfo;

  double get xScale {
    double tmpX = endPathNode.position.x - center.x;
    double tmpY = endPathNode.position.y - center.y;
    return tmpX / sqrt(tmpX * tmpX + tmpY * tmpY);
  }

  double get yScale {
    double tmpX = endPathNode.position.x - center.x;
    double tmpY = endPathNode.position.y - center.y;
    return tmpY / sqrt(tmpX * tmpX + tmpY * tmpY);
  }

  set center(Position position) {
    x = position.x - width / 2;
    y = position.y - height / 2;
  }

  Position get center {
    return Position(x + width / 2, y + height / 2);
  }

  PersonSprite(double width, double height) {
    add(FootSprite(personY: 200, personX: 150, origentation: HorizontalOrigentation.Left));
    add(FootSprite(personY: 200, personX: 150, origentation: HorizontalOrigentation.Right));
    add(BodySprite(personY: 200, personX: 150, origentation: HorizontalOrigentation.Left));
    add(HandSprite(personY: 200, personX: 150, origentation: HorizontalOrigentation.Left));
    add(HandSprite(personY: 200, personX: 150, origentation: HorizontalOrigentation.Right));
    add(HeadSprite(personY: 200, personX: 150, origentation: HorizontalOrigentation.Right));
  }

  void add(Component c) {
    if (gameRef is BaseGame) {
      (gameRef as BaseGame).preAdd(c);
    }
    components.add(c);
  }

  void jumpto({@required PathNode targetEndNode, @required Position targetCenter}) {
    if (jumpInfo == null) {
      endPathNode = targetEndNode;
      jumpInfo = JumpInfo(
          originPosition: toPosition(),
          originSize: Size(width, height),
          targetCenterPosition: targetCenter,
          targetEndPathNode: targetEndNode);
      jumpInfo.upEffects?.forEach((element) {
        addEffect(element);
      });
    }
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
      center = jumpInfo.targetCenterPosition;
      jumpInfo.jumpStatus = JumpStatus.Finish;
      jumpInfo = null;
    }
    if (jumpInfo != null) {
      jumpInfo.time += dt;
    }
  }

  @override
  void update(double dt) {
    // super.update(dt);

    if (jumpInfo != null) {
      _updateJumpStatus(dt);
    } else {
      double moveLength = dt * 5;
      x += moveLength * xScale;
      y += moveLength * yScale;

      Position endPosition = endPathNode.position;
      Position centerPosition = center;
      if ((endPosition.x - centerPosition.x).abs() < 1 && (endPosition.y - centerPosition.y).abs() < 1) {
        // print('change');
        // print(centerPosition);
        // print(endPathNode.position);
        endPathNode = endPathNode.randomLinkedNode;
        // print(endPathNode.position);
      }

      components.forEach((c) {
        (c as PersonComponent).updatePosition(personX: x, personY: y);
        c.update(dt);
      });
      components.removeWhere((c) => c.destroy());
    }
  }

  @override
  void render(Canvas canvas) {
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
