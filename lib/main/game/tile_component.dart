import 'dart:ui';

import 'package:cityCloud/main/game/model/tile_info.dart';
import 'package:cityCloud/main/game/model/tile_location.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

const double PathPadding = 6;
const double TileWidth = 60;
const double TileHeight = 60;

class TileComponent extends SpriteComponent {
  final String tileImage;
  final String tileViewImage;
  TileInfo _tileInfo;
  TileInfo get tileInfo => _tileInfo;
  final TileMapLocation tileMapLocation;
  SpriteComponent viewSpriteComponent;
  TileComponent({
    @required this.tileMapLocation,
    this.tileViewImage,
    @required this.tileImage,
  }) : assert(tileMapLocation != null && tileImage != null) {
    x = tileMapLocation.tileMapX * TileWidth;
    y = tileMapLocation.tileMapY * TileHeight;
    width = TileWidth;
    height = TileHeight * 194 / 180;
    _createTitleInfoAccordingToSelf();
    Sprite.loadSprite(tileImage).then((value) => sprite = value);
    if (tileViewImage != null) {
      viewSpriteComponent = SpriteComponent.rectangle(TileWidth - PathPadding * 4, TileWidth - PathPadding * 4, tileViewImage);
      viewSpriteComponent.x = x + PathPadding * 2;
      viewSpriteComponent.y = y + PathPadding * 2;
    }
  }
  // TileComponent({@required this.tileMapLocation, @required Rect rect})
  //     : assert(tileMapLocation != null && rect != null) {
  //   x = rect.left;
  //   y = rect.top;
  //   width = rect.width;
  //   height = rect.height;
  //   _createTitleInfoAccordingToSelf();
  // }

  @override
  bool loaded() {
    bool b = super.loaded();
    if (tileViewImage != null) {
      return b && (viewSpriteComponent?.loaded() == true);
    }
    return b;
  }

  // @override
  // bool get debugMode => true;

  void _createTitleInfoAccordingToSelf() {
    PathNode topLeftNode = PathNode(position: Position(x + PathPadding, y + PathPadding));
    PathNode topRighttNode = PathNode(position: Position(x + width - PathPadding, y + PathPadding));
    PathNode bottomLeftNode = PathNode(position: Position(x + PathPadding, y + height - PathPadding));
    PathNode bottomRighttNode = PathNode(position: Position(x + width - PathPadding, y + height - PathPadding));

    topLeftNode.bottom = bottomLeftNode;
    topLeftNode.right = topRighttNode;

    bottomLeftNode.top = topLeftNode;
    bottomLeftNode.right = bottomRighttNode;

    bottomRighttNode.left = bottomLeftNode;
    bottomRighttNode.top = topRighttNode;

    topRighttNode.left = topLeftNode;
    topRighttNode.bottom = bottomRighttNode;

    _tileInfo = TileInfo(topLeftNode: topLeftNode, topRightNode: topRighttNode, bottomLeftNode: bottomLeftNode, bottomRightNode: bottomRighttNode);
  }

  void randomPath(void callback({@required PathNode beginNode, @required PathNode endNode})) {
    assert(callback != null);

    PathNode beginNode = _tileInfo?.randomPathNode();
    PathNode endNode = beginNode?.randomLinkedNode;
    callback(beginNode: beginNode, endNode: endNode);
  }

  void linkWithTileComponent({@required TileComponent tileComponent, @required BorderOrientation borderOrientation}) {
    assert(tileComponent != null && borderOrientation != null);
    TileInfo toLinkTileInfo = tileComponent._tileInfo;
    switch (borderOrientation) {
      case BorderOrientation.Top:
        _tileInfo.linkPathNode(node: toLinkTileInfo.bottomLeftNode, orientation: borderOrientation);
        _tileInfo.linkPathNode(node: toLinkTileInfo.bottomRightNode, orientation: borderOrientation);
        break;
      case BorderOrientation.Left:
        _tileInfo.linkPathNode(node: toLinkTileInfo.topRightNode, orientation: borderOrientation);
        _tileInfo.linkPathNode(node: toLinkTileInfo.bottomRightNode, orientation: borderOrientation);
        break;
      case BorderOrientation.Bottom:
        _tileInfo.linkPathNode(node: toLinkTileInfo.topLeftNode, orientation: borderOrientation);
        _tileInfo.linkPathNode(node: toLinkTileInfo.topRightNode, orientation: borderOrientation);
        break;
      case BorderOrientation.Right:
        _tileInfo.linkPathNode(node: toLinkTileInfo.topLeftNode, orientation: borderOrientation);
        _tileInfo.linkPathNode(node: toLinkTileInfo.bottomLeftNode, orientation: borderOrientation);
        break;
    }
  }

  @override
  void render(Canvas c) {
    c.save();
    super.render(c);
    c.restore();
    // if (sprite != null) {
    //   sprite.renderRect(c, Rect.fromLTWH(x, y, width + 1, height * 194 / 180));
    // }
    c.save();
    viewSpriteComponent?.render(c);
    c.restore();
    // drawPath(c);
  }

  @override
  void update(double t) {
    super.update(t);
  }
}
