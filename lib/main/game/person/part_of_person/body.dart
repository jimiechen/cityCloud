import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import '../person_const_data.dart';

class BodySprite extends SpriteComponent {
  final String bodyImage;
  final HorizontalOrigentation origentation;
  BodySprite({
    double bodyWidth = BodyWidth,
    double bodyHeight = BodyHeight,
    double footHeight = FootHeight,
    this.origentation,
    @required this.bodyImage,
  }) {
    assert(bodyWidth != null && bodyHeight != null && footHeight != null);
    x = -bodyWidth / 2 + BodyOffset;
    y = -bodyHeight - footHeight + 1;
    width = bodyWidth;
    height = bodyHeight;

    sprite = Sprite(bodyImage);
  }
}
