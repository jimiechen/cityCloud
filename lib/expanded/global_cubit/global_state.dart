part of 'global_cubit.dart';

@immutable
abstract class GlobalCubitState {}

class GlobalInitial extends GlobalCubitState {}

///点击小人
class GlobalTapOnPersionSprite extends GlobalCubitState {
  final PersonModel personModel;

  GlobalTapOnPersionSprite(this.personModel);
}

//信封提示
class GlobalTapOnPersionSpriteMessageRemider extends GlobalCubitState {
  final PersonModel personModel;

  GlobalTapOnPersionSpriteMessageRemider(this.personModel);
}

//数字提示
class GlobalTapOnPersionSpriteNumberRemider extends GlobalCubitState {
  final PersonModel personModel;

  GlobalTapOnPersionSpriteNumberRemider(this.personModel);
}

class GlobalCubitStateAddPerson extends GlobalCubitState {}

class GlobalCubitStateAddCar extends GlobalCubitState {}
