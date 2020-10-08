import 'dart:ui';

import 'package:cityCloud/main/game/map_tile/tile_component.dart';
import 'package:flame/layer/layer.dart';

class MapLayer extends PreRenderedLayer {
  bool _allTileLoaded = false;
  bool _hadCreatePicture = false;

  Iterable<TileComponent> _tileList;

  MapLayer(Iterable<TileComponent> tileList) : _tileList = tileList;

  @override
  void render(Canvas canvas, {double x = 0.0, double y = 0.0}) {
    if (_allTileLoaded) {
      if (!_hadCreatePicture) {
        reRender();
        _hadCreatePicture = true;
      }

      super.render(canvas, x: x, y: y);
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

  @override
  void drawLayer() {
    _tileList?.forEach((element) {
      if (element.loaded()) {
        element.render(canvas);
      }
    });
  }
}
