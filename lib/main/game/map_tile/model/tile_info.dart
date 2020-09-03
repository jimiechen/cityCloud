import 'package:cityCloud/expanded/database/database.dart';
import 'package:moor/moor.dart';
// import 'package:flutter/material.dart';

class TileInfos extends Table {
  IntColumn get tileMapX => integer()();
  IntColumn get tileMapY => integer()();
  IntColumn get viewID => integer()();
  IntColumn get bgColor => integer()();
  TextColumn get id => text()();

  ///该条数据是否已经上传到服务器了
  BoolColumn get uploaded => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  static bool isAllValueValidated(TileInfo tileInfo) {
    return tileInfo.tileMapX != null &&
        tileInfo.tileMapY != null &&
        tileInfo.viewID != null &&
        tileInfo.bgColor != null &&
        tileInfo.id != null &&
        tileInfo.uploaded != null;
  }
  // int tileMapX;
  // int tileMapY;
  // int viewID;
  // int bgColor;

  // String id; //地图块唯一识别id，用于地图块区分

  // TileInfo({
  //   @required this.tileMapX,
  //   @required this.tileMapY,
  //   this.viewID,
  //   this.id,
  //   @required this.bgColor,
  // }){
  //   assert(tileMapX != null && tileMapY != null && bgColor != null);
  //   id ??= Uuid.generateUuidV4WithoutDashes();
  //   insureValueValid();
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['tileMapX'] = this.tileMapX;
  //   data['tileMapY'] = this.tileMapY;
  //   data['viewID'] = this.viewID;
  //   data['bgColor'] = this.bgColor;
  //   data['id'] = this.id;
  //   return data;
  // }

  // ///确保各个值都有效
  // void insureValueValid() {
  //   Random random = Random();
  //   if (bgColor == null || bgColor > 0xFFFFFFFF) {
  //     bgColor = ColorHelper.mapTile.first.value;
  //   }
  //   if (viewID == null || viewID >= ImageHelper.mapTileViews.length) {
  //     viewID = random.nextInt(ImageHelper.bodys.length);
  //   }
  // }
}
