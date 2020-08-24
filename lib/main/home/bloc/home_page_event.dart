part of 'home_page_bloc.dart';

@immutable
abstract class HomePageEvent {}

///上传小人信息
class HomePageEventUploadPersonSpriteInfo extends HomePageEvent {
  final PersonModel model;

  HomePageEventUploadPersonSpriteInfo({this.model}):assert(model != null);
}
