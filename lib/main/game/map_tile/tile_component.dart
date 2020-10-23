import 'dart:ui';

import 'package:cityCloud/expanded/database/database.dart';
import 'package:cityCloud/main/game/map_tile/model/tile_location.dart';
import 'package:cityCloud/main/game/map_tile/model/tile_path_node_info.dart';
import 'package:cityCloud/util/image_helper.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

const double PathPadding = 6;
const double TileWidth = 60;
const double TileHeight = 60;

class TileComponent extends SpriteComponent {
  TilePathNodeInfo _tilePathNodeInfo;
  TilePathNodeInfo get tilePathNodeInfo => _tilePathNodeInfo;

  SpriteComponent wallSpriteComponent;
  TileMapLocation get tileMapLocation => TileMapLocation(tileInfo.tileMapX, tileInfo.tileMapY);

  final TileInfo tileInfo;
  bool _showWall;

  set showWall(bool b) {
    if (b) {
      Sprite.loadSprite('wall.png').then((value) {
        wallSpriteComponent = SpriteComponent.fromSprite(width, value.size.y * TileWidth / value.size.x, value);
        wallSpriteComponent.x = 0;
        wallSpriteComponent.y = height;
      });
    }
    _showWall = b;
  }

  TileComponent({
    @required this.tileInfo,
  }) : assert(tileInfo != null) {
    x = tileInfo.tileMapX * TileWidth;
    y = tileInfo.tileMapY * TileHeight;
    width = TileWidth;
    height = TileHeight;
    _createTitleInfoAccordingToSelf();
    Sprite.loadSprite(ImageHelper.mapTileViews[tileInfo?.viewID ?? 0]).then((value) => sprite = value);
  }

  @override
  bool loaded() {
    bool b = super.loaded();
    if (_showWall == true) {
      return b && (wallSpriteComponent?.loaded() == true);
    }
    return b;
  }

  void _createTitleInfoAccordingToSelf() {
    PathNode topLeftNode = PathNode(position: Position(x + PathPadding, y + PathPadding));
    PathNode topRighttNode = PathNode(position: Position(x + width - PathPadding, y + PathPadding));
    PathNode bottomLeftNode = PathNode(position: Position(x + PathPadding, y + TileHeight - PathPadding));
    PathNode bottomRighttNode = PathNode(position: Position(x + width - PathPadding, y + TileHeight - PathPadding));

    topLeftNode.bottom = bottomLeftNode;
    topLeftNode.right = topRighttNode;

    bottomLeftNode.top = topLeftNode;
    bottomLeftNode.right = bottomRighttNode;

    bottomRighttNode.left = bottomLeftNode;
    bottomRighttNode.top = topRighttNode;

    topRighttNode.left = topLeftNode;
    topRighttNode.bottom = bottomRighttNode;

    _tilePathNodeInfo = TilePathNodeInfo(topLeftNode: topLeftNode, topRightNode: topRighttNode, bottomLeftNode: bottomLeftNode, bottomRightNode: bottomRighttNode);
  }

  void randomPath(void callback({@required PathNode beginNode, @required PathNode endNode})) {
    assert(callback != null);

    PathNode beginNode = _tilePathNodeInfo?.randomPathNode();
    PathNode endNode = beginNode?.randomLinkedNode;
    callback(beginNode: beginNode, endNode: endNode);
  }

  void linkWithTileComponent({@required TileComponent tileComponent, @required BorderOrientation borderOrientation}) {
    assert(tileComponent != null && borderOrientation != null);
    TilePathNodeInfo toLinkTileInfo = tileComponent._tilePathNodeInfo;
    switch (borderOrientation) {
      case BorderOrientation.Top:
        _tilePathNodeInfo.linkPathNode(node: toLinkTileInfo.bottomLeftNode, orientation: borderOrientation);
        _tilePathNodeInfo.linkPathNode(node: toLinkTileInfo.bottomRightNode, orientation: borderOrientation);
        break;
      case BorderOrientation.Left:
        _tilePathNodeInfo.linkPathNode(node: toLinkTileInfo.topRightNode, orientation: borderOrientation);
        _tilePathNodeInfo.linkPathNode(node: toLinkTileInfo.bottomRightNode, orientation: borderOrientation);
        break;
      case BorderOrientation.Bottom:
        _tilePathNodeInfo.linkPathNode(node: toLinkTileInfo.topLeftNode, orientation: borderOrientation);
        _tilePathNodeInfo.linkPathNode(node: toLinkTileInfo.topRightNode, orientation: borderOrientation);
        break;
      case BorderOrientation.Right:
        _tilePathNodeInfo.linkPathNode(node: toLinkTileInfo.topLeftNode, orientation: borderOrientation);
        _tilePathNodeInfo.linkPathNode(node: toLinkTileInfo.bottomLeftNode, orientation: borderOrientation);
        break;
    }
  }

  @override
  void render(Canvas c) {
    c.save();
    prepareCanvas(c);
    c.drawRect(Rect.fromLTWH(0, 0, width, height), Paint()..color = Color(tileInfo.bgColor));
    sprite?.render(c, width: width, height: height, overridePaint: overridePaint);

    if (_showWall && wallSpriteComponent != null) {
      wallSpriteComponent.y = height;
      wallSpriteComponent.width = width;
      wallSpriteComponent.render(c);
    }
    c.restore();
  }

  @override
  void update(double t) {
    super.update(t);
  }
}
