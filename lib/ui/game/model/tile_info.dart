import 'dart:math';

import 'package:cityCloud/ui/game/dash_path.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';

const List<double> DashPattern = [8, 4];
const double AngleRadius = 3;

enum BorderOrientation {
  Top,
  Left,
  Bottom,
  Right,
}

enum TraverseDirection {
  Bottom,
  Right,
}

class TileInfo {
  ///四大角
  final PathNode topLeftNode;
  final PathNode topRightNode;
  final PathNode bottomLeftNode;
  final PathNode bottomRightNode;

  TileInfo({
    this.topLeftNode,
    this.topRightNode,
    this.bottomLeftNode,
    this.bottomRightNode,
  }) : assert(topLeftNode != null && topRightNode != null && bottomLeftNode != null && bottomRightNode != null);

  double get pathWidth => topRightNode.position.x - topLeftNode.position.x;
  double get pathHeight => bottomLeftNode.position.y - topLeftNode.position.y;

  PathNode randomPathNode() {
    return [topLeftNode, topRightNode, bottomLeftNode, bottomRightNode][Random().nextInt(4)];
  }

  void linkPathNode({@required PathNode node, @required BorderOrientation orientation}) {
    assert(node != null);
    switch (orientation) {
      case BorderOrientation.Top:
        if (node.position.x == topLeftNode.position.x || node.position.x == topRightNode.position.x) {
          if (node.position.x == topLeftNode.position.x) {
            topLeftNode.top = node;
            node.bottom = topLeftNode;
          } else {
            topRightNode.top = node;
            node.bottom = topRightNode;
          }
        } else {
          PathNode insertNode = _insertPathNodeBetweenNodes(begin: topLeftNode, end: topRightNode, traverseOrientation: TraverseDirection.Right, toLinkPathNode: node);
          if (insertNode != null) {
            insertNode.top = node;
            node.bottom = insertNode;
          }
        }

        break;
      case BorderOrientation.Left:
        if (node.position.y == topLeftNode.position.y || node.position.y == bottomLeftNode.position.y) {
          if (node.position.y == topLeftNode.position.y) {
            topLeftNode.left = node;
            node.right = topLeftNode;
          } else {
            bottomLeftNode.left = node;
            node.right = bottomLeftNode;
          }
        } else {
          PathNode insertNode = _insertPathNodeBetweenNodes(begin: topLeftNode, end: bottomLeftNode, traverseOrientation: TraverseDirection.Bottom, toLinkPathNode: node);
          if (insertNode != null) {
            insertNode.left = node;
            node.right = insertNode;
          }
        }
        break;
      case BorderOrientation.Bottom:
        if (node.position.x == bottomLeftNode.position.x || node.position.x == bottomRightNode.position.x) {
          if (node.position.x == bottomLeftNode.position.x) {
            bottomLeftNode.bottom = node;
            node.top = bottomLeftNode;
          } else {
            bottomRightNode.bottom = node;
            node.top = bottomRightNode;
          }
        } else {
          PathNode insertNode = _insertPathNodeBetweenNodes(begin: bottomLeftNode, end: bottomRightNode, traverseOrientation: TraverseDirection.Right, toLinkPathNode: node);
          if (insertNode != null) {
            insertNode.bottom = node;
            node.top = insertNode;
          }
        }
        break;
      case BorderOrientation.Right:
        if (node.position.y == topRightNode.position.y || node.position.y == bottomRightNode.position.y) {
          if (node.position.y == topRightNode.position.y) {
            topRightNode.right = node;
            node.left = topRightNode;
          } else {
            bottomRightNode.right = node;
            node.left = bottomRightNode;
          }
        } else {
          PathNode insertNode = _insertPathNodeBetweenNodes(begin: topRightNode, end: bottomRightNode, traverseOrientation: TraverseDirection.Bottom, toLinkPathNode: node);
          if (insertNode != null) {
            insertNode.right = node;
            node.left = insertNode;
          }
        }
        break;
    }
  }

  PathNode _insertPathNodeBetweenNodes({
    @required PathNode begin,
    @required PathNode end,
    @required TraverseDirection traverseOrientation,
    @required PathNode toLinkPathNode,
  }) {
    switch (traverseOrientation) {
      case TraverseDirection.Bottom:
        if (begin.position.y < toLinkPathNode.position.y) {
          PathNode tmpNode = begin;
          int breakCount = 0;
          do {
            if (breakCount >= 100) {
              print('break for do while');
              break;
            }
            breakCount++;
            tmpNode = tmpNode.bottom;
          } while (tmpNode != end && tmpNode.position.y < toLinkPathNode.position.y && tmpNode != null && tmpNode != begin);
          if (tmpNode != null && tmpNode.position.y > toLinkPathNode.position.y && tmpNode.top != null && tmpNode.top.position.y < toLinkPathNode.position.y) {
            PathNode newNode = PathNode(position: Position(begin.position.x, toLinkPathNode.position.y));
            newNode.bottom = tmpNode;
            newNode.top = tmpNode.top;
            newNode.bottom.top = newNode;
            newNode.top.bottom = newNode;
            return newNode;
          }
        }
        break;
      case TraverseDirection.Right:
        if (begin.position.x < toLinkPathNode.position.x) {
          PathNode tmpNode = begin;
          int breakCount = 0;
          do {
            if (breakCount >= 100) {
              print('break for do while');
              break;
            }
            breakCount++;
            tmpNode = tmpNode.right;
          } while (tmpNode != end && tmpNode.position.x < toLinkPathNode.position.x && tmpNode != null && tmpNode != begin);
          if (tmpNode != null && tmpNode.position.x > toLinkPathNode.position.x && tmpNode.top != null && tmpNode.top.position.x < toLinkPathNode.position.x) {
            PathNode newNode = PathNode(position: Position(toLinkPathNode.position.x, begin.position.y));
            newNode.right = tmpNode;
            newNode.left = tmpNode.top;
            newNode.right.left = newNode;
            newNode.left.right = newNode;
            return newNode;
          }
        }
        break;
    }
    return null;
  }

  void drawPath(Canvas canvas) {
    ///用四大角画出人物可以运动的路径
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    canvas.drawPath(_getRRectPath(), paint);
  }

  Path _getRRectPath() {
    Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            topLeftNode.position.x,
            topLeftNode.position.y,
            pathWidth,
            pathHeight,
          ),
          Radius.circular(AngleRadius),
        ),
      );
    return dashPath(path, dashArray: CircularIntervalList(DashPattern));
  }
}

///路径上的节点，可以理解为人物运动的转弯点
class PathNode {
  ///上下左右节点，也就是说从this这个节点可以移动到哪个节点，用于规划人物路线
  PathNode top;
  PathNode left;
  PathNode bottom;
  PathNode right;

  ///地图上的位置
  final Position position;

  List<PathNode> get linkedNodes => [top, left, bottom, right].where((element) => element != null).toList();

  PathNode get randomLinkedNode {
    List<PathNode> list = linkedNodes;
    if (list.isEmpty) {
      return null;
    } else {
      return list[Random().nextInt(list.length)];
    }
  }

  PathNode({@required this.position}) : assert(position != null);
}
