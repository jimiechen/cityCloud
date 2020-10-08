class UserInfo {
  static UserInfo share = UserInfo._();
  UserInfo._();
  factory UserInfo() => share;

  String get uid => 'cc'  ;
  ///如果是账号第一次登陆，一定要同步数据
  bool gameDataSyncServer = false;
}
