import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageCubitState> {
  HomePageCubit() : super(HomePageCubitInitial());
  void add(HomePageCubitState state) => emit(state);
}
