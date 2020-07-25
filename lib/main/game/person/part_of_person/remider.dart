import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';

class RemiderSprite extends SpriteComponent {
  RemiderSprite.fromSprite(double width, double height,) {
    this.sprite = sprite;
    this.width = width;
    this.height = height;
     Sprite.loadSprite(
        'icon_mail.png',
      ).then((value) {
        sprite = value;
      });
  }
}
