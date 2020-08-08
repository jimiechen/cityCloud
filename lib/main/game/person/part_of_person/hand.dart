import 'package:flame/components/component.dart';
import 'package:flame/effects/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import '../person_const_data.dart';

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

class HandSprite extends SpriteComponent {
  final String handImage;
  final HorizontalOrigentation origentation;
  final double footAndBodyHeight;
  HandSprite({double handWidth = HandWidth, double handHeight = HandHeight, @required this.handImage, this.footAndBodyHeight = FootHeight + BodyHeight, this.origentation}) {
    assert(handWidth != null && handHeight != null);
    x = origentation == HorizontalOrigentation.Left ? -handWidth - HandSpacing / 2 : HandSpacing / 2;
    y = -footAndBodyHeight;
    width = handWidth;
    height = handHeight;

    Sprite.loadSprite(handImage).then((value) {
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
}
