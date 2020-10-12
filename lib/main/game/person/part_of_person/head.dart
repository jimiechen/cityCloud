import 'package:cityCloud/main/game/person/person_const_data.dart';
import 'package:flame/components/component.dart';
import 'package:flame/effects/combined_effect.dart';
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

  SpriteComponent hairComponent;
  SpriteComponent noseComponent;
  SpriteComponent eyeSprite;

  Paint _facePaint;

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
      hairComponent = SpriteComponent.fromSprite(imageWidth, imageHeight, value);
      hairComponent.x = PersonHairCenterXInFace - imageWidth / 2;
      hairComponent.y = PersonHairCenterYInFace - imageHeight / 2;
    });

    Sprite.loadSprite(eyeImage).then((value) {
      double imageWidth = value.size.x * PersonScale;
      double imageHeight = value.size.y * PersonScale;
      eyeSprite = SpriteComponent.fromSprite(imageWidth, imageHeight, value);
      eyeSprite.x = PersonEyeCenterXInFace - imageWidth / 2;
      eyeSprite.y = PersonEyeCenterYInFace - imageHeight / 2;
    });

    Sprite.loadSprite(noseImage).then((value) {
      double imageWidth = value.size.x * PersonScale;
      double imageHeight = value.size.y * PersonScale;
      noseComponent = SpriteComponent.fromSprite(imageWidth, imageHeight, value);
      noseComponent.x = PersonNoseCenterXInFace - imageWidth / 2;
      noseComponent.y = PersonNoseCenterYInFace - imageHeight / 2;
    });
  }

  void resetPosition() {
    x = 0;
    y = -PersonFaceCenterY;
  }

  void closeEye() {
    eyeSprite?.clearEffects();
    eyeSprite.addEffect(
      ScaleEffect(
        size: Size(eyeSprite.width, 0),
        speed: eyeSprite.height * 4,
        curve: Curves.linear,
        isAlternating: true,
        onComplete: () {},
      ),
    );

    eyeSprite?.addEffect(
      MoveEffect(
        isAlternating: true,
        curve: Curves.linear,
        destination: eyeSprite.toPosition().add(Position(0, eyeSprite.height / 2)),
        speed: eyeSprite.height * 2,
      ),
    );
  }

  bool loaded() {
    return hairComponent?.loaded() == true && noseComponent?.loaded() == true && eyeSprite?.loaded() == true;
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
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: PersonFaceWidth, height: PersonFaceHeight), _facePaint);
    _renderComponent(canvas, eyeSprite);
    _renderComponent(canvas, noseComponent);
    _renderComponent(canvas, hairComponent);
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
