import 'dart:ui';

import 'package:cityCloud/main/game/building/model/building_info.dart';
import 'package:cityCloud/main/game/map_tile/tile_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

class BuildingSprite extends SpriteComponent {
  Set<Component> components = Set<Component>();
  final int tileMapX;
  final int tileMapY;
  final BuildingInfo buildingInfo;
  Position _relativePosition;
  BuildingSprite({this.tileMapX, this.tileMapY, this.buildingInfo}) {
    x = tileMapX * TileWidth;
    y = tileMapY * TileHeight;
    Sprite.loadSprite(buildingInfo.image).then((value) {
      sprite = value;

      width = sprite.size.x / buildingInfo.scale;
      height = sprite.size.y / buildingInfo.scale;
      _relativePosition = buildingInfo.relativePosition - Position(width/2,height);
    });
  }

  @override
  int priority() => (y + buildingInfo.relativePosition.y).toInt();

  @override
  void render(Canvas canvas) {
    prepareCanvas(canvas);
    sprite.renderPosition(canvas, _relativePosition, size: Position(width, height), overridePaint: overridePaint);
  }
}
