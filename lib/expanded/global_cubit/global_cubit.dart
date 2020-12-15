import 'package:bloc/bloc.dart';
import 'package:cityCloud/expanded/database/database.dart';
import 'package:meta/meta.dart';

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalCubitState> {
  static final GlobalCubit _singleton = GlobalCubit._();
  GlobalCubit._() : super(GlobalInitial());
  factory GlobalCubit() => _singleton;

  void add(GlobalCubitState state) => super.emit(state);
}
