import 'dart:async';

import 'package:cityCloud/dart_class/extension/Iterable_extension.dart';
import 'package:cityCloud/expanded/cubit/global_cubit.dart';
import 'package:cityCloud/main/game/person/part_of_person/body.dart';
import 'package:cityCloud/main/game/person/part_of_person/foot.dart';
import 'package:cityCloud/main/game/person/part_of_person/hand.dart';
import 'package:cityCloud/main/game/person/part_of_person/head.dart';
import 'package:cityCloud/main/game/person/part_of_person/remider.dart';
import 'package:cityCloud/main/game/person/person_const_data.dart';
import 'package:cityCloud/main/game/person/person_effect/enter_effect.dart';
import 'package:cityCloud/main/game/person/person_effect/go_out_effect.dart';
import 'package:cityCloud/main/game/person/person_effect/jump_in_place_effect.dart';
import 'package:flame/components/component.dart';

import 'package:flame/position.dart';
import 'package:flutter/material.dart';

import '../callback_pre_render_layer.dart';
import '../model/tile_info.dart';
import 'package:ordered_set/ordered_set.dart';
import 'package:ordered_set/comparing.dart';

import 'person_effect/person_move_effect.dart';

class PersonSprite extends PositionComponent {
  ///动态的部分，如手脚一直在动的就放在_dynamicComponents中
  OrderedSet<Component> _dynamicComponents = OrderedSet(Comparing.on((c) => c.priority()));

  ///静态的部分，如身体和头这些随人物整体移动，没有自身动画的就放在_quietComponents中，然后渲染到_quietLayer缓存
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

  ///运动的终点
  PathNode _endPathNode;

  ///移动effect
  PersonMoveEffect _moveEffect;

  ///入场效果
  EnterEffect _enterEffect;

  ///从游戏中消失效果
  GoOutEffect _goOutEffect;

  ///原地跳效果
  JumpInPlaceEffect _jumpInPlaceEffect;

  PersonSprite({
    @required String hairImage,
    @required String eyeImage,
    @required String noseImage,
    @required String bodyImage,
    @required String footImage,
    @required String handImage,
    @required Color faceColor,
    @required Position initialPosition,
    @required PathNode endPathNode,
  }) : assert(initialPosition != null && endPathNode != null) {
    _endPathNode = endPathNode;
    x = initialPosition.x;
    y = initialPosition.y;
    resetMoveEffect();
    _leftFootSprite = FootSprite(origentation: HorizontalOrigentation.Left, footImage: footImage, color: faceColor);
    _rightFootSprite = FootSprite(origentation: HorizontalOrigentation.Right, footImage: footImage, color: faceColor);
    _bodySprite = BodySprite(origentation: HorizontalOrigentation.Left, bodyImage: bodyImage);
    _leftHandSprite = HandSprite(origentation: HorizontalOrigentation.Left, handImage: handImage, color: faceColor);
    _rightHandSprite = HandSprite(origentation: HorizontalOrigentation.Right, handImage: handImage, color: faceColor);

    _headSprite = HeadSprite(
      origentation: HorizontalOrigentation.Right,
      faceColor: faceColor,
      hairImage: hairImage,
      eyeImage: eyeImage,
      noseImage: noseImage,
    );

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
    } else if (_moveEffect.endPosition.x < x) {
      _faceOrigentation = HorizontalOrigentation.Left;
    } else if (_faceOrigentation == null) {
      _faceOrigentation = HorizontalOrigentation.values.randomItem;
    }
  }

  ///原地跳
  void jumpInPlace() {
    if (_goOutEffect == null && _enterEffect == null && _jumpInPlaceEffect == null) {
      removeEffect(_moveEffect);
      _jumpInPlaceEffect = JumpInPlaceEffect(
          personPosition: toPosition(),
          onComplete: () {
            _jumpInPlaceEffect = null;
            resetMoveEffect();
          });
    }
  }

  ///从一个位置跳到另一个位置
  void jumpto({@required PathNode targetEndNode, @required Position targetCenter}) {
    if (_goOutEffect == null && _enterEffect == null && _jumpInPlaceEffect == null) {
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
    if (_goOutEffect == null && _enterEffect == null && _jumpInPlaceEffect == null) {
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
    if (_goOutEffect == null && _enterEffect == null && _jumpInPlaceEffect == null) {
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
    if (_enterEffect != null || _goOutEffect != null) {
      _enterEffect?.update(dt);
      _goOutEffect?.update(dt);
    } else {
      super.update(dt);
      _jumpInPlaceEffect?.update(dt);
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
    ///画脚下阴影
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: ShadowWidth, height: ShadowHeight),
      Paint()..color = Colors.grey.withOpacity(0.5),
    );
    canvas.save();
    _enterEffect?.setEffectToCanvas(canvas);
    _goOutEffect?.setEffectToCanvas(canvas);
    _jumpInPlaceEffect?.setEffectToCanvas(canvas);
    _render(canvas);
    canvas.restore();
  }

  void _render(Canvas canvas) {
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
