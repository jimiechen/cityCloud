import 'dart:async';
import 'dart:math';

import 'package:cityCloud/dart_class/extension/Iterable_extension.dart';
import 'package:cityCloud/expanded/global_cubit/global_cubit.dart';
import 'package:cityCloud/expanded/database/database.dart';
import 'package:cityCloud/main/game/person/part_of_person/remider.dart';
import 'package:cityCloud/main/game/person/person_const_data.dart';
import 'package:cityCloud/main/game/person/person_effect/enter_effect.dart';
import 'package:cityCloud/main/game/person/person_effect/go_out_effect.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:cityCloud/main/game/person/person_flare_controller.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame_flare/flame_flare.dart';
import 'package:flutter/material.dart';
import '../map_tile/model/tile_path_node_info.dart';
import 'person_effect/person_move_effect.dart';

class PersonSprite extends FlareActorComponent {
  ///小人面朝向
  HorizontalOrigentation _faceOrigentation;

  ///头顶提示sprite
  RemiderSprite _remiderSprite;

  ///运动的终点
  PathNode _endPathNode;

  ///移动effect
  PersonMoveEffect _moveEffect;

  ///入场效果
  EnterEffect _enterEffect;

  ///从游戏中消失效果
  GoOutEffect _goOutEffect;

  ///小人身体各部位信息
  final PersonModel model;

  ///小人flare动画控制
  final PersonSpriteFlareController animationController;

  ///定时倒数改变小人当前动作，走、站立、跳三个动作
  double _randomActionTimeCount = 5;

  Timer _closeEyeTimer;

  PersonSprite(
      {@required this.animationController,
      @required this.model,
      @required Position initialPosition,
      @required PathNode endPathNode,
      double width = PersonSize,
      double height = PersonSize})
      : super(
          FlareActorAnimation.asset(
            // PersonFlareLoader().createAssetProvider(),
            AssetFlare(bundle: Flame.bundle, name: PersonFlareAsset),
            controller: animationController,
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
          ),
          width: width,
          height: height,
        ) {
    _endPathNode = endPathNode;
    x = initialPosition.x;
    y = initialPosition.y;
    animationController.resetImage(model);
    _closeEyeTimer = Timer.periodic(Duration(milliseconds: Random().nextInt(1500) + 2500), (timer) {
      animationController.play(PersonAction_CloseEye);
    });
  }

  ///根据_endPathNode重新设置移动
  void resetMoveEffect() {
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
      goOut(() {
        Timer.run(() {
          enter(targetEndNode: targetEndNode, targetPosition: targetCenter);
        });
      });
    }
  }

  ///小人进入游戏界面
  void enter({@required PathNode targetEndNode, @required Position targetPosition}) {
    assert(targetEndNode != null && targetPosition != null);
    if (_goOutEffect == null && _enterEffect == null) {
      _endPathNode = targetEndNode;
      x = targetPosition.x;
      y = targetPosition.y;
      _enterEffect = EnterEffect(
          personPosition: toPosition(),
          onComplete: () {
            _enterEffect = null;
            x = targetPosition.x;
            y = targetPosition.y;
            resetMoveEffect();
          });
    }
  }

  ///小人从游戏界面消失
  void goOut(VoidCallback onComplete) {
    if (_goOutEffect == null && _enterEffect == null) {
      _goOutEffect = GoOutEffect(
          personPosition: toPosition(),
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
    String animationName;
    switch (Random().nextInt(3)) {
      case 0:
        animationName = PersonAction_Jump;
        _moveEffect?.dispose();
        _randomActionTimeCount = 1;
        break;
      case 1:
        animationName = PersonAction_Stand;
        _moveEffect?.dispose();
        _randomActionTimeCount = 2;
        break;
      default:
        animationName = PersonAction_Walk;
        _randomActionTimeCount = 5;
        resetMoveEffect();
    }
    animationController.changeToAnimation(animationName);
  }

  @override
  bool destroy() {
    _closeEyeTimer?.cancel();
    return super.destroy();
  }

  @override
  void update(double dt) {
    if (_enterEffect != null || _goOutEffect != null) {
      _remiderSprite = null;
      _enterEffect?.update(dt);
      _goOutEffect?.update(dt);
    } else {
      _remiderSprite?.update(dt);
      _randomActionTimeCount -= dt;
      if (_randomActionTimeCount < 0) {
        changeAction();
      }
      super.update(dt);
    }
  }

  @override
  void render(Canvas canvas) {
    ///画脚下阴影
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: ShadowWidth, height: ShadowHeight),
      Paint()..color = Colors.grey.withOpacity(0.5),
    );
    canvas.save();
    canvas.translate(-width / 2, -height);
    _remiderSprite?.render(canvas);
    super.render(canvas);
    canvas.restore();
  }
}
