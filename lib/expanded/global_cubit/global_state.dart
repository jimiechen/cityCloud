part of 'global_cubit.dart';

@immutable
abstract class GlobalCubitState {}

class GlobalInitial extends GlobalCubitState {}

///点击小人头顶提示
class GlobalTapOnPersionSpriteRemider extends GlobalCubitState {}

class GlobalCubitStateAddPerson extends GlobalCubitState {}
class GlobalCubitStateAddCar extends GlobalCubitState {}