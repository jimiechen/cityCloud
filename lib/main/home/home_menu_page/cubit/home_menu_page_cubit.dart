import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_menu_page_state.dart';

class HomeMenuPageCubit extends Cubit<HomeMenuPageState> {
  HomeMenuPageCubit() : super(HomeMenuPageInitial());
}
