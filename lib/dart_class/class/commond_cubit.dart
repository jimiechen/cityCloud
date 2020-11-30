import 'package:bloc/bloc.dart';

class CommondCubit<T> extends Cubit<T>{
  CommondCubit(state) : super(state);
  void addState(T state) {
    emit(state);
  }
}