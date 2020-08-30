part of 'home_page_bloc.dart';

@immutable
abstract class HomePageEvent {}

///上传小人信息
class HomePageEventUploadPersonSpriteInfo extends HomePageEvent {
  final PersonModel model;

  HomePageEventUploadPersonSpriteInfo({this.model}) : assert(model != null);
}

///上传小车消息
class HomePageEventUploadCarInfo extends HomePageEvent {
  final CarInfo model;

  HomePageEventUploadCarInfo({this.model}) : assert(model != null);
}

///上传地图消息
class HomePageEventUploadMapTileInfo extends HomePageEvent {
  final TileInfo model;

  HomePageEventUploadMapTileInfo({this.model}) : assert(model != null);
}

///获取服务端的游戏数据，地图，小车，小人
class HomePageEventGetGameData extends HomePageEvent {}
