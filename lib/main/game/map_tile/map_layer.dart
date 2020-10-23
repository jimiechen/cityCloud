import 'dart:async';
import 'dart:ui';

import 'package:cityCloud/main/game/map_tile/tile_component.dart';
import 'package:flame/effects/effects.dart';
import 'package:flame/layer/layer.dart';
import 'package:flutter/material.dart';

class MapLayer extends PreRenderedLayer {
  bool _allTileLoaded = false;
  bool _hadCreatePicture = false;

  Set<TileComponent> _tileList;

  Set<TileComponent> _toAddTileSet = Set();

  MapLayer(Iterable<TileComponent> tileList) : _tileList = Set.from(tileList);

  @override
  void render(Canvas canvas, {double x = 0.0, double y = 0.0}) {
    if (_allTileLoaded) {
      if (!_hadCreatePicture) {
        reRender();
        _hadCreatePicture = true;
      }

      super.render(canvas, x: x, y: y);
      canvas.save();
      _toAddTileSet.forEach((element) {
        element.render(canvas);
      });
      canvas.restore();
    } else {
      canvas.save();
      canvas.translate(x, y);
      _allTileLoaded = true;
      _tileList?.forEach((element) {
        if (element.loaded()) {
          element.render(canvas);
        } else {
          _allTileLoaded = false;
        }
      });
      canvas.restore();
    }
  }

  void addTile(TileComponent tile) {
    _toAddTileSet.add(tile);
    Size originSize = Size(tile.width, tile.height);
    tile.width *= 1.2;
    tile.height *= 1.2;
    tile.addEffect(
      ScaleEffect(
          size: originSize,
          speed: tile.width * 0.2 * 2,
          curve: Curves.linear,
          onComplete: () {
            Timer.run(() {
              _toAddTileSet.remove(tile);
              _tileList.add(tile);
              reRender();
            });
          }),
    );
  }

  void update(double t) {
    _toAddTileSet.forEach((element) => element.update(t));
  }

  @override
  void drawLayer() {
    _tileList?.forEach((element) {
      if (element.loaded()) {
        element.render(canvas);
      }
    });
  }
}
