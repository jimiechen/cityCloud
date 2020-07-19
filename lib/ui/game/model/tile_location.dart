/**
 * tileMapX:在地图中，这个瓦片所在x轴位置，从0开始
 * tileMapY：在地图中，这个瓦片所在y轴位置，从0开始
 */
class TileMapLocation {
  final int tileMapX;
  final int tileMapY;
  TileMapLocation(this.tileMapX, this.tileMapY):assert(tileMapX != null && tileMapY != null);

  bool operator == (other) {
    if (other is TileMapLocation) {
      return other.tileMapX == tileMapX && other.tileMapY == tileMapY;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => tileMapX * 10000 + tileMapY;
}