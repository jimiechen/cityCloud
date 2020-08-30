class GameDataStatus {
  bool dbLoadedPerson = false;  ///是否已经完成数据库加载小人数据
  bool networkGotPerson = false;  ///是否已经完成网络请求小人数据

  bool dbLoadedCar = false;
  bool networkGotCar = false;

  bool dbLoadedMapTile = false;
  bool networkGotMapTile = false;
}