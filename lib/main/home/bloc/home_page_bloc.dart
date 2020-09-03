import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cityCloud/const/const.dart';
import 'package:cityCloud/dart_class/extension/Iterable_extension.dart';
import 'package:cityCloud/dart_class/mixn/bloc_mixin.dart';
import 'package:cityCloud/expanded/database/database.dart';
import 'package:cityCloud/expanded/network_api/model/common_server_data_model.dart';
import 'package:cityCloud/expanded/network_api/network_api.dart';
import 'package:cityCloud/main/game/car/model/car_info.dart';
import 'package:cityCloud/main/game/map_tile/model/tile_info.dart';
import 'package:cityCloud/main/game/person/model/person_model.dart';
import 'package:cityCloud/util/util.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:moor/moor.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> with BlocAddStateMixin {
  HomePageBloc() : super(HomePageInitial());

  @override
  Stream<HomePageState> mapEventToState(
    HomePageEvent event,
  ) async* {
    if (event is HomePageEventUploadPersonSpriteInfo) {
      uploadPersonSpriteInfo(event.model);
    } else if (event is HomePageEventUploadCarInfo) {
      uploadCarInfo(event.model);
    } else if (event is HomePageEventUploadMapTileInfo) {
      uploadMapTileInfo(event.model);
    } else if (event is HomePageEventGetGameData) {
      getGameData(
        personData: (personList) {
          addState(HomePageStatePersonData(personList));
        },
        carData: (carList) {
          addState(HomePageStateCarData(carList));
        },
        mapTileData: (tileList) {
          addState(HomePageStateMapTileData(tileList));
        },
      );
    }
  }

  void getGameData({
    ValueChanged<List<PersonModel>> personData,
    ValueChanged<List<CarInfo>> carData,
    ValueChanged<List<TileInfo>> mapTileData,
  }) {
    NetworkDio.get<List<CommonServerDataModel>, CommonServerDataModel>(
      modelFromJson: (json) => CommonServerDataModel.fromJson(json),
      pathForData: ['data', 'list'],
      url: API_QUERY_OBJECT,
      body: {
        'data_type': NetworkDataType.person,
      },
    ).then((value) {
      Iterable<CommonServerDataModel> tmpList = value?.data?.where((element) => element.json is Map);
      personData?.call(
        tmpList
            ?.map((e) {
              e.json['uploaded'] = true;
              return PersonModel.fromJson(e.json);
            })
            ?.where((element) => PersonModels.isAllValueValidated(element))
            ?.toList(),
      );
    });
    NetworkDio.get<List<CommonServerDataModel>, CommonServerDataModel>(
      modelFromJson: (json) => CommonServerDataModel.fromJson(json),
      pathForData: ['data', 'list'],
      url: API_QUERY_OBJECT,
      body: {
        'data_type': NetworkDataType.car,
      },
    ).then((value) {
      Iterable<CommonServerDataModel> tmpList = value?.data?.where((element) => element.json is Map);
      carData?.call(
        tmpList
            ?.map((e) {
              e.json['uploaded'] = true;
              return CarInfo.fromJson(e.json);
            })
            ?.where((element) => CarInfos.isAllValueValidated(element))
            ?.toList(),
      );
    });
    NetworkDio.get<List<CommonServerDataModel>, CommonServerDataModel>(
      modelFromJson: (json) => CommonServerDataModel.fromJson(json),
      pathForData: ['data', 'list'],
      url: API_QUERY_OBJECT,
      body: {
        'data_type': NetworkDataType.map,
      },
    ).then((value) {
      Iterable<CommonServerDataModel> tmpList = value?.data?.where((element) => element.json is Map);
      mapTileData?.call(
        tmpList
            ?.map((e) {
              e.json['uploaded'] = true;
              return TileInfo.fromJson(e.json);
            })
            ?.where((element) => TileInfos.isAllValueValidated(element))
            ?.toList(),
      );
    });
  }

  void uploadPersonSpriteInfo(PersonModel model) {
    if (model == null) return;
    NetworkDio.post(
      url: API_CREATE_OBJECT,
      body: {
        'json': model.toJson(),
        'uid': 'cc',
        'data_type': NetworkDataType.person,
        'data_format': 'json',
        'source': Util.deviceStrType,
        'create_time': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      },
    ).then((value) {
      (CustomDatabase.share.update(CustomDatabase.share.personModels)
            ..where(
              (event) => event.id.equals(model.id),
            ))
          .write(
        PersonModelsCompanion(
          uploaded: Value(true),
        ),
      );
    });
  }

  void uploadCarInfo(CarInfo model) {
    if (model == null) return;
    NetworkDio.post(
      url: API_CREATE_OBJECT,
      body: {
        'json': model.toJson(),
        'uid': 'cc',
        'data_type': NetworkDataType.car,
        'data_format': 'json',
        'source': Util.deviceStrType,
        'create_time': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      },
    ).then((value) {
      (CustomDatabase.share.update(CustomDatabase.share.carInfos)
            ..where(
              (event) => event.id.equals(model.id),
            ))
          .write(
        CarInfosCompanion(
          uploaded: Value(true),
        ),
      );
    });
  }

  void uploadMapTileInfo(TileInfo model) {
    if (model == null) return;
    NetworkDio.post(
      url: API_CREATE_OBJECT,
      body: {
        'json': model.toJson(),
        'uid': 'cc',
        'data_type': NetworkDataType.map,
        'data_format': 'json',
        'source': Util.deviceStrType,
        'create_time': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      },
    ).then((value) {
      (CustomDatabase.share.update(CustomDatabase.share.tileInfos)
            ..where(
              (event) => event.id.equals(model.id),
            ))
          .write(TileInfosCompanion(uploaded: Value(true)));
    });
  }
}
