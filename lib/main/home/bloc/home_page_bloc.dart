import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cityCloud/const/const.dart';
import 'package:cityCloud/expanded/network_api/network_api.dart';
import 'package:cityCloud/main/game/person/model/person_model.dart';
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
        'data_type': NetworkDataType.PersonSprite.index,
        'create_time': DateTime.now().millisecondsSinceEpoch,
      },
    ).then((value) {
      print(value);
    });
  }
}
