import 'dart:async';
import 'dart:math';

import 'package:cityCloud/dart_class/extension/Iterable_extension.dart';
import 'package:cityCloud/expanded/global_cubit/global_cubit.dart';
import 'package:cityCloud/expanded/database/database.dart';
import 'package:cityCloud/main/game/person/part_of_person/body.dart';
import 'package:cityCloud/main/game/person/part_of_person/foot.dart';
import 'package:cityCloud/main/game/person/part_of_person/hand.dart';
import 'package:cityCloud/main/game/person/part_of_person/head.dart';
import 'package:cityCloud/main/game/person/part_of_person/remider.dart';
import 'package:cityCloud/main/game/person/person_const_data.dart';
import 'package:cityCloud/dart_class/flame/scale_translate_canvas_effect.dart';
import 'package:cityCloud/main/game/person/person_effect/hand_rotate_effect.dart';
import 'package:cityCloud/util/image_helper.dart';
import 'package:flame/components/component.dart';
import 'package:flame/effects/effects.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import '../map_tile/model/tile_path_node_info.dart';
import 'person_effect/jump_canvas_translate.dart';
import 'person_effect/person_move_effect.dart';

class PersonSprite extends PositionComponent {
  ///小人面朝向
  HorizontalOrigentation _faceOrigentation;

  ///头顶提示sprite
  RemiderSprite _remiderSprite;

  ///运动的终点
  PathNode _endPathNode;

  ///移动effect
  PersonMoveEffect _moveEffect;

  ///入场效果
  ScalTranslateCanvasEffect _enterEffect;

  ///从游戏中消失效果
  ScalTranslateCanvasEffect _goOutEffect;

  ///小人身体各部位信息
  final PersonModel model;

  ///定时倒数改变小人当前动作，走、站立、跳三个动作
  double _randomActionTimeCount = 5;
  PersonActionType _currentActionType;

  ///小人闭眼倒计时
  double _closeEyeTimeCount = 4;

  ///跳动控制
  JumpCanvasTranslate _jumpTranslate;

  ///从一个位置跳到另一个位置
  VoidCallback _jumpToAction;

  ///小人各部位的sprite
  FootSprite _leftFootSprite;
  FootSprite _rightFootSprite;
  BodySprite _bodySprite;
  HandSprite _leftHandSprite;
  HandSprite _rightHandSprite;
  HeadSprite _headSprite;

  ///人影paint
  Paint _shadowPaint = Paint()..color = Colors.grey.withOpacity(0.5);

  PersonSprite({
    @required this.model,
    @required Position initialPosition,
    @required PathNode endPathNode,
  }) {
    _endPathNode = endPathNode;
    x = initialPosition.x;
    y = initialPosition.y;

    Color personColor = Color(model.faceColorValue);
    _leftFootSprite = FootSprite(footColor: personColor, footImage: ImageHelper.foots[model.footID]);
    _rightFootSprite =
        FootSprite(footColor: personColor, footImage: ImageHelper.foots[model.footID], isLeftHand: false);
    _bodySprite = BodySprite(bodyColor: personColor, bodyImage: ImageHelper.bodys[model.bodyID]);
    _leftHandSprite = HandSprite(handColor: personColor, handImage: ImageHelper.hands[model.handID]);
    _rightHandSprite =
        HandSprite(handColor: personColor, handImage: ImageHelper.hands[model.handID], isLeftHand: false);
    _headSprite = HeadSprite(
      eyeImage: ImageHelper.eyes[model.eyeID],
      faceColor: personColor,
      hairImage: ImageHelper.hairs[model.hairID],
      noseImage: ImageHelper.noses[model.noseID],
    );

    _currentActionType = PersonActionType.Walk;
    _randomActionTimeCount = 10;
    resetMoveEffect();
    walk();
  }

  ///根据_endPathNode重新设置移动
  void resetMoveEffect() {
    if (_moveEffect != null && !_moveEffect.isDisposed) {
      removeEffect(_moveEffect);
    }
    _moveEffect = PersonMoveEffect(
      destination: _endPathNode.position,
      curve: Curves.linear,
      speed: PersonMoveSpeed,
      onComplete: () {
        Timer.run(() {
          _endPathNode = _endPathNode.randomLinkedNode;
          if (_endPathNode != null) {
            resetMoveEffect();
          }
        });
      },
    );
    addEffect(_moveEffect);
    if (_moveEffect.endPosition.x > x) {
      _faceOrigentation = HorizontalOrigentation.Right;
      renderFlipX = true;
    } else if (_moveEffect.endPosition.x < x) {
      _faceOrigentation = HorizontalOrigentation.Left;
      renderFlipX = false;
    } else if (_faceOrigentation == null) {
      _faceOrigentation = HorizontalOrigentation.values.randomItem;
    }
  }

  ///从一个位置跳到另一个位置
  void jumpto({@required PathNode targetEndNode, @required Position targetCenter}) {
    if (_goOutEffect == null && _enterEffect == null) {
      _jumpToAction = () {
        goOut(() {
          enter(
              targetEndNode: targetEndNode,
              targetPosition: targetCenter,
              onComplete: () {
                _jumpToAction = null;
                changeAction();
              });
        });
      };
    }
  }

  ///小人进入游戏界面
  void enter({@required PathNode targetEndNode, @required Position targetPosition, VoidCallback onComplete}) {
    assert(targetEndNode != null && targetPosition != null);
    if (_goOutEffect == null && _enterEffect == null) {
      _endPathNode = targetEndNode;
      x = targetPosition.x;
      y = targetPosition.y;
      _enterEffect = ScalTranslateCanvasEffect(
          destinationTranslate: Position(0,-40),
          destinationScale: Offset(-0.5, 1.5),
          travelTime: 0.3,
          reverse: true,
          onComplete: () {
            _enterEffect = null;
            x = targetPosition.x;
            y = targetPosition.y;
            resetMoveEffect();
            onComplete?.call();
          });
    }
  }

  ///小人从游戏界面消失
  void goOut(VoidCallback onComplete) {
    if (_goOutEffect == null && _enterEffect == null) {
      _goOutEffect = ScalTranslateCanvasEffect(
          destinationTranslate: Position(0,-40),
          destinationScale: Offset(-0.5, 1.5),
          travelTime: 0.3,
          onComplete: () {
            _goOutEffect = null;

            onComplete?.call();
          });
    }
  }

  ///显示头顶提示
  void showRemider() {
    _remiderSprite = RemiderSprite.fromSprite(
      20,
      20,
    );
    _remiderSprite.x = -width / 2;
    _remiderSprite.y = -height;
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

  ///改变小人动作，走、跳、立定
  void changeAction() {
    PersonActionType preActionType = _currentActionType;
    _currentActionType = PersonActionType.values.randomItem;
    if (_jumpToAction != null) {
      reset();
      _jumpToAction.call();
    } else if (preActionType != _currentActionType) {
      reset();
      switch (_currentActionType) {
        case PersonActionType.Jump:
          jump();
          _randomActionTimeCount = 0.6;
          break;
        case PersonActionType.Stand:
          _randomActionTimeCount = 2;
          stand();
          break;
        default:
          _randomActionTimeCount = 10;
          walk();
          resetMoveEffect();
      }
    } else {
      switch (_currentActionType) {
        case PersonActionType.Jump:
          _randomActionTimeCount = 0.6;
          break;
        case PersonActionType.Stand:
          _randomActionTimeCount = 2;
          break;
        default:
          _randomActionTimeCount = 10;
      }
    }
  }

  void reset() {
    clearEffects();
    _leftFootSprite?.resetPosition();
    _leftFootSprite?.clearEffects();
    _rightFootSprite?.resetPosition();
    _rightFootSprite?.clearEffects();
    _bodySprite?.resetPosition();
    _bodySprite?.clearEffects();
    _leftHandSprite?.resetPosition();
    _leftHandSprite?.clearEffects();
    _rightHandSprite?.resetPosition();
    _rightHandSprite?.clearEffects();
    _headSprite?.resetPosition();
    _headSprite?.clearEffects();
  }

  void jump() {
    double tralvelTime = 0.3;
    _leftHandSprite.addEffect(
      HandRotateEffect(
          curve: Curves.linear,
          isAlternating: true,
          radians: PersonHandJumpRotate,
          speed: PersonHandJumpRotate / tralvelTime),
    );
    _rightHandSprite.addEffect(
      HandRotateEffect(
          curve: Curves.linear,
          isAlternating: true,
          radians: -PersonHandJumpRotate,
          speed: PersonHandJumpRotate / tralvelTime),
    );

    _jumpTranslate = JumpCanvasTranslate(
        curve: Curves.easeOut,
        jumpHeight: PersonJumpHeight,
        speed: PersonJumpHeight / tralvelTime,
        isAlternating: true);

    _leftFootSprite.addEffect(
      MoveEffect(
        isAlternating: true,
        destination: _leftFootSprite.toPosition().add(Position(0, -PersonFootJumpTakeBackLength)),
        speed: PersonFootJumpTakeBackLength / tralvelTime,
        curve: Curves.linear,
      ),
    );
    _rightFootSprite.addEffect(
      MoveEffect(
        isAlternating: true,
        destination: _rightFootSprite.toPosition().add(Position(0, -PersonFootJumpTakeBackLength)),
        speed: PersonFootJumpTakeBackLength / tralvelTime,
        curve: Curves.linear,
      ),
    );
  }

  void stand() {
    double tralvelTime = 0.4;
    _leftHandSprite.addEffect(
      HandRotateEffect(
          curve: Curves.linear,
          isAlternating: true,
          radians: PersonHandWalkRotate,
          speed: PersonHandWalkRotate / tralvelTime,
          isInfinite: true),
    );

    _rightHandSprite.addEffect(
      HandRotateEffect(
          curve: Curves.linear,
          isAlternating: true,
          radians: -PersonHandWalkRotate,
          speed: PersonHandWalkRotate / tralvelTime,
          isInfinite: true),
    );

    _headSprite.addEffect(
      MoveEffect(
        isAlternating: true,
        isInfinite: true,
        destination: _headSprite.toPosition().add(Position(0, PersonFootPutUpHeight)),
        speed: PersonHeadMoveRange / tralvelTime,
        curve: Curves.linear,
      ),
    );
  }

  void walk() {
    double tralvelTime = 0.4;
    _leftFootSprite.addEffect(
      MoveEffect(
        isAlternating: true,
        isInfinite: true,
        destination: _leftFootSprite.toPosition().add(Position(0, -PersonFootPutUpHeight)),
        speed: PersonFootPutUpHeight / tralvelTime,
        curve: Curves.linear,
      ),
    );
    Position originPosition = _rightFootSprite.toPosition();
    _rightFootSprite.y -= PersonFootPutUpHeight;
    _rightFootSprite.addEffect(
      MoveEffect(
        isAlternating: true,
        isInfinite: true,
        destination: originPosition,
        speed: PersonFootPutUpHeight / tralvelTime,
        curve: Curves.linear,
      ),
    );

    _leftHandSprite.addEffect(
      HandRotateEffect(
          curve: Curves.linear,
          isAlternating: true,
          radians: PersonHandWalkRotate,
          speed: PersonHandWalkRotate / tralvelTime,
          isInfinite: true),
    );

    _rightHandSprite.addEffect(
      HandRotateEffect(
          curve: Curves.linear,
          isAlternating: true,
          radians: -PersonHandWalkRotate,
          speed: PersonHandWalkRotate / tralvelTime,
          isInfinite: true),
    );

    _headSprite.addEffect(
      MoveEffect(
        isAlternating: true,
        isInfinite: true,
        destination: _headSprite.toPosition().add(Position(0, PersonFootPutUpHeight)),
        speed: PersonHeadMoveRange / tralvelTime,
        curve: Curves.linear,
      ),
    );
  }

  @override
  bool loaded() {
    return _leftFootSprite?.loaded() == true &&
        _rightFootSprite?.loaded() == true &&
        _bodySprite.loaded() &&
        _leftHandSprite.loaded() &&
        _rightHandSprite.loaded() &&
        _headSprite.loaded();
  }

  @override
  void update(double dt) {
    _closeEyeTimeCount -= dt;
    if (_closeEyeTimeCount < 0) {
      _closeEyeTimeCount = Random().nextDouble() * 1.5 + 2.5;
      _headSprite?.closeEye();
    }

    super.update(dt);
    if (_jumpTranslate?.hasFinished() == true) {
      _jumpTranslate = null;
    }
    _jumpTranslate?.update(dt);
    _leftFootSprite?.update(dt);
    _rightFootSprite?.update(dt);
    _bodySprite?.update(dt);
    _leftHandSprite?.update(dt);
    _rightHandSprite?.update(dt);
    _headSprite?.update(dt);
    _remiderSprite?.update(dt);
    if (_enterEffect != null || _goOutEffect != null) {
      _enterEffect?.update(dt);
      _goOutEffect?.update(dt);
    } else {
      _randomActionTimeCount -= dt;
      if (_randomActionTimeCount < 0) {
        changeAction();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(x, y);
    if (_faceOrigentation == HorizontalOrigentation.Right) {
      ///小人往右
      canvas.scale(-1.0, 1.0);
    }

    ///画脚下阴影
    canvas.drawOval(
        Rect.fromCenter(center: Offset(0, 0), width: PersonShadowWidth, height: PersonShadowHeight), _shadowPaint);
    _jumpTranslate?.translate(canvas);
    canvas.save();
    _enterEffect?.setEffectToCanvas(canvas);
    _goOutEffect?.setEffectToCanvas(canvas);
    _renderComponent(canvas, _remiderSprite);
    _renderComponent(canvas, _leftFootSprite);
    _renderComponent(canvas, _rightFootSprite);
    _renderComponent(canvas, _bodySprite);
    _renderComponent(canvas, _leftHandSprite);
    _renderComponent(canvas, _rightHandSprite);
    _renderComponent(canvas, _headSprite);
    canvas.restore();
    canvas.restore();
  }

  void _renderComponent(Canvas canvas, Component c) {
    if (c?.loaded() != true) {
      return;
    }
    canvas.save();
    c.render(canvas);
    canvas.restore();
  }
}
