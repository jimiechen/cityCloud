import 'package:cityCloud/main/game/callback_pre_render_layer.dart';
import 'package:flame/components/component.dart';
import 'package:flame/effects/combined_effect.dart';
import 'package:flame/effects/effects.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../person_const_data.dart';

class HeadSprite extends PositionComponent {
  final HorizontalOrigentation origentation;
  final double footAndBodyHeight;

  SpriteComponent hairComponent;
  SpriteComponent noseComponent;
  EyeSprite eyeSprite;

  CallbackDynamicLayer _layer;

  HeadSprite({double headWidth = HeadWidth, double headHeight = HeadHeight, this.footAndBodyHeight = FootHeight + BodyHeight, this.origentation}) {
    assert(headWidth != null && headHeight != null);
    width = headWidth;
    height = headHeight;
    ///此xy是头的中心点
    x = 0;
    y = -footAndBodyHeight - 7;

    hairComponent = SpriteComponent.square(30, 'people-hair-2.png');
    hairComponent.x = -14;
    hairComponent.y = -16;

    eyeSprite = EyeSprite(Position(x,y));

    _layer = CallbackDynamicLayer(drawLayerCallback: (canvas) {
      Paint paint = Paint()..color = Colors.yellow;
      canvas.drawCircle(Offset(0, 0), 9, paint);
      canvas.save();
      hairComponent.render(canvas);
      canvas.restore();
    });
    setupEffect();
  }

  void setupEffect() {
    addEffect(MoveEffect(
      curve: Curves.linear,
      destination: toPosition() - Position(0, -3),
      speed: 6,
      isInfinite: true,
      isAlternating: true,
    ));
  }

  @override
  bool loaded() {
    return hairComponent.loaded();
  }

  @override
  void update(double dt) {
    super.update(dt);
    eyeSprite?.update(dt);
    eyeSprite?.updateCenter(Position(x,y));
  }

  @override
  void render(Canvas canvas) {
    if (loaded()) {
      _layer.render(canvas, x: x, y: y);
    }
    eyeSprite.render(canvas);
  }
}

class EyeSprite extends SpriteComponent {
  CombinedEffect _eyeEffect;
  double _timeCount = 0;
  EyeSprite(Position center) {
    width = EyeWidth;
    height = EyeHeight;
    updateCenter(center);
    Sprite.loadSprite('people-eyes-1005.png').then((value) {
      sprite = value;
    });
  }

  void updateCenter(Position center){
    x = center.x - width /2;
    y = center.y - height /2;
  }

  void setEffect() {
    if (_eyeEffect != null) return;
    final Rect originRect = Rect.fromLTWH(x, y, width, height);
    double travelTime = height / EyeSpeed;
    _eyeEffect = CombinedEffect(
        isAlternating: true,
        effects: <PositionComponentEffect>[
          ScaleEffect(
            curve: Curves.linear,
            size: Size(EyeWidth, 0),
            speed: EyeSpeed,
          ),
          MoveEffect(
            curve: Curves.linear,
            destination: Position(x, y + height / 2),
            speed: height / 2 / travelTime,
          ),
        ],
        onComplete: () {
          clearEffects();
          _eyeEffect = null;
          x = originRect.left;
          y = originRect.top;
          width = originRect.width;
          height = originRect.height;
        });
    addEffect(_eyeEffect);
  }

  @override
  void update(double t) {
    super.update(t);
    _timeCount += t;
    if (_timeCount > 5 && _eyeEffect == null) {
      _timeCount = 0;
      setEffect();
    }
  }
}
