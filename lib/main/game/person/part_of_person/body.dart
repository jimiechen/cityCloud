import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import '../person_const_data.dart';

class BodySprite extends SpriteComponent {
  final HorizontalOrigentation origentation;
  BodySprite({double bodyWidth = BodyWidth, double bodyHeight = BodyHeight, double footHeight = FootHeight, this.origentation}) {
    assert(bodyWidth != null && bodyHeight != null && footHeight != null);
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
}