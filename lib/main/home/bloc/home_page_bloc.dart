import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cityCloud/const/const.dart';
import 'package:cityCloud/dart_class/mixn/bloc_mixin.dart';
import 'package:cityCloud/expanded/database/database.dart';
import 'package:cityCloud/expanded/network_api/model/common_server_data_model.dart';
import 'package:cityCloud/expanded/network_api/network_api.dart';
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
      getGameData();
    }
  }

  void getGameData({
    ValueChanged<List<PersonModel>> personData,
    ValueChanged<List<CarInfo>> carData,
    ValueChanged<List<TileInfo>> mapTileData,
  }) {
    NetworkDio.get<List<CommonServerDataModel>,CommonServerDataModel>(
      modelFromJson: (json)=>CommonServerDataModel.fromJson(json),
      pathForData: ['data','list'],
      url: API_QUERY_OBJECT,
      body: {
        'data_type': NetworkDataType.person,
      },
    ).then((value) {
      print(value.toString());
    });
    NetworkDio.get<List<CommonServerDataModel>,CommonServerDataModel>(
      modelFromJson: (json)=>CommonServerDataModel.fromJson(json),
      pathForData: ['data','list'],
      url: API_QUERY_OBJECT,
      body: {
        'data_type': NetworkDataType.car,
      },
    ).then((value) {
      print(value.toString());
    });
    NetworkDio.get<List<CommonServerDataModel>,CommonServerDataModel>(
      modelFromJson: (json)=>CommonServerDataModel.fromJson(json),
      pathForData: ['data','list'],
      url: API_QUERY_OBJECT,
      body: {
        'data_type': NetworkDataType.map,
      },
    ).then((value) {
      print(value.toString());
    });
  }

  void uploadPersonSpriteInfo(PersonModel model) {
    if (model == null) return;
    NetworkDio.post(
      url: API_CREATE_OBJECT,
      body: {
        'json': model.toJson(),
        'id': model.id,
        'data_type': NetworkDataType.person,
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
        'id': model.id,
        'data_type': NetworkDataType.car,
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
        'id': model.id,
        'data_type': NetworkDataType.map,
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
