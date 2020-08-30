import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cityCloud/const/const.dart';
import 'package:cityCloud/expanded/database/database.dart';
import 'package:cityCloud/expanded/network_api/network_api.dart';
import 'package:cityCloud/util/util.dart';
import 'package:meta/meta.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial());

  @override
  Stream<HomePageState> mapEventToState(
    HomePageEvent event,
  ) async* {
    if (event is HomePageEventUploadPersonSpriteInfo) {
      uploadPersonSpriteInfo(event.model);
    }
  }

  void uploadPersonSpriteInfo(PersonModel model) {
    if (model == null) return;
    NetworkDio.post(
      url: API_CREATE_OBJECT,
      body: {
        'json': model.toJson(),
        'id': model.id,
        'data_type': NetworkDataType.person,
        'source':Util.deviceStrType,
        'create_time': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      },
    ).then((value) {
      print(value);
    });
  }
}
