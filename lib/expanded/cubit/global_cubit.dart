import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  static final GlobalCubit _singleton = GlobalCubit._();
  GlobalCubit._() : super(GlobalInitial());
  factory GlobalCubit() => _singleton;

  void add(GlobalState state) => super.emit(state);
}
