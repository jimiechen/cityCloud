import 'dart:math';

import 'package:cityCloud/styles/color_helper.dart';
import 'package:cityCloud/util/image_helper.dart';
import 'package:cityCloud/util/uuid.dart';
import 'package:flutter/material.dart';

class TileInfo {
  int tileMapX;
  int tileMapY; 
  int viewID;
  int bgColor;

  String id; //地图块唯一识别id，用于地图块区分

  TileInfo({
    @required this.tileMapX,
    @required this.tileMapY,
    @required this.viewID,
    this.id,
    @required this.bgColor,
  }){
    assert(tileMapX != null && tileMapY != null && bgColor != null && viewID != null);
    id ??= Uuid.generateV4() + '_' + DateTime.now().toIso8601String();
    insureValueValid();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tileMapX'] = this.tileMapX;
    data['tileMapY'] = this.tileMapY;
    data['viewID'] = this.viewID;
    data['bgColor'] = this.bgColor;
    return data;
  }

  ///确保各个值都有效
  void insureValueValid() {
    Random random = Random();
    if (bgColor == null || bgColor > 0xFFFFFFFF) {
      bgColor = ColorHelper.mapTile.first.value;
    }
    if (viewID == null || viewID >= ImageHelper.mapTileViews.length) {
      viewID = random.nextInt(ImageHelper.bodys.length);
    }
  }
}