import 'dart:math';

import 'package:cityCloud/const/const.dart';
import 'package:cityCloud/dart_class/extension/Iterable_extension.dart';
import 'package:cityCloud/expanded/database/database.dart';
import 'package:cityCloud/expanded/network_api/model/common_server_data_model.dart';
import 'package:cityCloud/expanded/network_api/network_api.dart';
import 'package:cityCloud/main/game/car/model/car_info.dart';
import 'package:cityCloud/main/game/map_tile/model/tile_info.dart';
import 'package:cityCloud/main/game/person/model/person_model.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:cityCloud/user_info/user_info.dart';
import 'package:cityCloud/util/image_helper.dart';
import 'package:cityCloud/util/uuid.dart';

class GameDataDownloader {
  ///下载游戏相关数据，并存到数据库,返回布尔值标识是否所有数据都请求成功，如果所有数据都成功获取则返回true，否则false。请求到数据后存储到本地数据库
  static Future<bool> getGameData() {
    return Future.wait<bool>(
      [NetworkDataType.person, NetworkDataType.car, NetworkDataType.map].map((dataType) {
        return NetworkDio.post<List<CommonServerDataModel>, CommonServerDataModel>(
          modelFromJson: (json) => CommonServerDataModel.fromJson(json),
          pathForData: ['data', 'list'],
          url: API_QUERY_OBJECT,
          body: {
            'uid': UserInfo().uid,
            'data_type': dataType,
          },
        ).then((value) async {
          Iterable<CommonServerDataModel> tmpList = value?.data?.where((element) => element.json is Map && element.dataType == dataType);
          if (dataType == NetworkDataType.person) {
            await CustomDatabase.share.delete(CustomDatabase.share.personModels).go();
            Set<String> idsSet = {};
            var dataList = tmpList?.map((e) {
              e.json['uploaded'] = true;
              return PersonModel.fromJson(e.json);
            })?.where((element) {
              bool b = idsSet.add(element.id);
              return b && PersonModels.isAllValueValidated(element);
            })?.toList();
            CustomDatabase.share.batch((batch) {
              batch.insertAll(CustomDatabase.share.personModels, dataList);
            });
            dataList = null;
            idsSet = null;
          } else if (dataType == NetworkDataType.car) {
            await CustomDatabase.share.delete(CustomDatabase.share.carInfos).go();
            Set<String> idsSet = {};
            var dataList = tmpList?.map((e) {
              e.json['uploaded'] = true;
              return CarInfo.fromJson(e.json);
            })?.where((element) {
              bool b = idsSet.add(element.id);
              return b && CarInfos.isAllValueValidated(element);
            })?.toList();
            CustomDatabase.share.batch((batch) {
              batch.insertAll(CustomDatabase.share.carInfos, dataList);
            });
            dataList = null;
            idsSet = null;
          } else if (dataType == NetworkDataType.map) {
            await CustomDatabase.share.delete(CustomDatabase.share.tileInfos).go();
            Set<String> idsSet = {};
            var dataList = tmpList?.map((e) {
              e.json['uploaded'] = true;
              return TileInfo.fromJson(e.json);
            })?.where((element) {
              bool b = idsSet.add(element.id);
              return b && TileInfos.isAllValueValidated(element);
            })?.toList();
            CustomDatabase.share.batch((batch) {
              batch.insertAll(CustomDatabase.share.tileInfos, dataList);
            });
            dataList = null;
            idsSet = null;
          }
          return true;
        }).catchError((onError) {
          return false;
        });
      }),
    ).then((value) {
      return !value.firstWhere((element) => element == false, orElse: () => false);
    }).catchError((onError) {
      return false;
    });
  }

  ///默认地图数据
  static List<TileInfo> defaultMapData({bool saveDb = false, bool toUpload = false}) {
    int tileBGColor = ColorHelper.mapTile.randomItem.value;
    List infoList = [
      _mapTileLocation(5, 2),
      _mapTileLocation(6, 2),
      _mapTileLocation(1, 3),
      _mapTileLocation(2, 3),
      _mapTileLocation(5, 3),
      _mapTileLocation(6, 3),
      _mapTileLocation(1, 4),
      _mapTileLocation(2, 4),
      _mapTileLocation(3, 4),
      _mapTileLocation(4, 4),
      _mapTileLocation(1, 5),
      _mapTileLocation(2, 5),
      _mapTileLocation(3, 5),
      _mapTileLocation(4, 5),
      _mapTileLocation(3, 6),
      _mapTileLocation(4, 6),
      _mapTileLocation(5, 6),
      _mapTileLocation(3, 7),
    ]
        .map(
          (e) => TileInfo(
            uploaded: !toUpload,
            bgColor: tileBGColor,
            tileMapX: e.x,
            tileMapY: e.y,
            viewID: Random().nextInt(ImageHelper.mapTileViews.length),
            id: Uuid.generateUuidV4WithoutDashes(),
          ),
        )
        ?.toList();
    if (saveDb) {
      CustomDatabase.share.batch((batch) {
        batch.insertAll(CustomDatabase.share.tileInfos, infoList);
      });
    }

    return infoList;
  }
}

class _mapTileLocation {
  final int x;
  final int y;
  _mapTileLocation(this.x, this.y);
}
