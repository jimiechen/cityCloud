import 'package:cityCloud/dart_class/flame/callback_pre_rendered_layer.dart';
import 'package:cityCloud/main/game/person/person_const_data.dart';
import 'package:cityCloud/main/game/person/person_effect/eye_scale_effect.dart';
import 'package:cityCloud/main/game/person/person_effect/person_move_effect.dart';
import 'package:flame/components/component.dart';
import 'package:flame/effects/effects.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HeadSprite extends PositionComponent {
  final String hairImage;
  final String eyeImage;
  final String noseImage;
  final Color faceColor;

  SpriteComponent eyeSprite;

  Paint _facePaint;

  CallbackPreRenderedLayer _layer;

  HeadSprite({
    @required this.hairImage,
    @required this.eyeImage,
    @required this.noseImage,
    @required this.faceColor,
  }) {
    _facePaint = Paint()..color = faceColor;
    x = 0;
    y = -PersonFaceCenterY;
    Sprite.loadSprite(hairImage).then((value) {
      double imageWidth = value.size.x * PersonScale;
      double imageHeight = value.size.y * PersonScale;
      SpriteComponent hairComponent = SpriteComponent.fromSprite(imageWidth, imageHeight, value);
      hairComponent.x = PersonHairCenterXInFace - imageWidth / 2;
      hairComponent.y = PersonHairCenterYInFace - imageHeight / 2;
      Sprite.loadSprite(noseImage).then((value) {
        double imageWidth = value.size.x * PersonScale;
        double imageHeight = value.size.y * PersonScale;
        SpriteComponent noseComponent = SpriteComponent.fromSprite(imageWidth, imageHeight, value);
        noseComponent.x = PersonNoseCenterXInFace - imageWidth / 2;
        noseComponent.y = PersonNoseCenterYInFace - imageHeight / 2;
        _layer = CallbackPreRenderedLayer(drawLayerCallback: (canvas) {
          canvas.drawOval(
              Rect.fromCenter(center: Offset.zero, width: PersonFaceWidth, height: PersonFaceHeight), _facePaint);
          canvas.save();
          noseComponent.render(canvas);
          canvas.restore();
          canvas.save();
          hairComponent.render(canvas);
          canvas.restore();
        });
        _layer.createLayer();
      });
    });

    Sprite.loadSprite(eyeImage).then((value) {
      double imageWidth = value.size.x * PersonScale;
      double imageHeight = value.size.y * PersonScale;
      eyeSprite = SpriteComponent.fromSprite(imageWidth, imageHeight, value);
      eyeSprite.x = PersonEyeCenterXInFace - imageWidth / 2;
      eyeSprite.y = PersonEyeCenterYInFace - imageHeight / 2;
    });
  }

  void resetPosition() {
    x = 0;
    y = -PersonFaceCenterY;
  }

  void closeEye() {
    eyeSprite?.clearEffects();
    eyeSprite.addEffect(
      EyeScaleEffect(
        size: Size(eyeSprite.width, 0),
        speed: eyeSprite.height * 4,
        curve: Curves.linear,
        isAlternating: true,
        onComplete: () {},
      ),
    );

    eyeSprite?.addEffect(
      PersonMoveEffect(
        isAlternating: true,
        curve: Curves.linear,
        destination: eyeSprite.toPosition().add(Position(0, eyeSprite.height / 2)),
        speed: eyeSprite.height * 2,
      ),
    );
  }

  bool loaded() {
    return _layer?.haveLayerPicture == true && eyeSprite?.loaded() == true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    eyeSprite?.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(x, y);
    _layer?.render(canvas);
    _renderComponent(canvas, eyeSprite);
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
