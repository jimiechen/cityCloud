part of 'home_page_bloc.dart';

@immutable
abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class HomePageStatePersonData extends HomePageState {
  final List<PersonModel> list;

  HomePageStatePersonData(this.list) : assert(list != null);
}

class HomePageStateCarData extends HomePageState {
  final List<CarInfo> list;

  HomePageStateCarData(this.list) : assert(list != null);
}

class HomePageStateMapTileData extends HomePageState {
  final List<TileInfo> list;

  HomePageStateMapTileData(this.list) : assert(list != null);
}
