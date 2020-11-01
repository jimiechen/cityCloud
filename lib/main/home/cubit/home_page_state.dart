part of 'home_page_cubit.dart';

@immutable
abstract class HomePageCubitState {}

class HomePageCubitInitial extends HomePageCubitState {}

/*显示和隐藏上拉页面相关state*/
class HomePageCubitShowMenu extends HomePageCubitState {}
class HomePageCubitHideMenu extends HomePageCubitState {}

/*状态页三个按钮点击事件*/
class HomePageCubitTapOnTaskCenter extends HomePageCubitState {}
class HomePageCubitTapOnMessageCenter extends HomePageCubitState {}
class HomePageCubitTapOnFriendDynamic extends HomePageCubitState {}

/*上拉菜单底部按钮点击事件*/
class HomePageCubitTapOnUserCenter extends HomePageCubitState {}
class HomePageCubitTapOnAddDynamic extends HomePageCubitState {}
class HomePageCubitTapOnMessageList extends HomePageCubitState {}

class HomePageCubitStopGame extends HomePageCubitState {}
class HomePageCubitStartGame extends HomePageCubitState {}