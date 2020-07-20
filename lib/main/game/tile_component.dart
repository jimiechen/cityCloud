import 'dart:ui';

import 'package:cityCloud/main/game/model/tile_info.dart';
import 'package:cityCloud/main/game/model/tile_location.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';

const double PathPadding = 6;
const double TileWidth = 60;
const double TileHeight = 60;

class TileComponent extends SpriteComponent {
  TileInfo _tileInfo;
  TileInfo get tileInfo => _tileInfo;
  final TileMapLocation tileMapLocation;
  TileComponent({@required this.tileMapLocation}) : assert(tileMapLocation != null) {
    x = tileMapLocation.tileMapX * TileWidth;
    y = tileMapLocation.tileMapY * TileHeight;
    width = TileWidth;
    height = TileHeight;
    _createTitleInfoAccordingToSelf();
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
  bool get debugMode => true;

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

    _tileInfo = TileInfo(
        topLeftNode: topLeftNode,
        topRightNode: topRighttNode,
        bottomLeftNode: bottomLeftNode,
        bottomRightNode: bottomRighttNode);
  }

  void randomPath(void callback({@required PathNode beginNode, @required PathNode endNode})) {
    assert(callback != null);

    PathNode beginNode = _tileInfo?.randomPathNode();
    PathNode endNode = beginNode.randomLinkedNode;
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
    if (sprite != null) {
      sprite.renderRect(c, Rect.fromLTWH(x, y, width + 1, height* 194/180));
    }
    // drawPath(c);
  }

  @override
  void update(double t) {
    super.update(t);
  }
}
