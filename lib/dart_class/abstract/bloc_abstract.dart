import 'package:bloc/bloc.dart';
import '../mixn/dispose_listenable.dart';

abstract class BlocCloseNotificationsAbstract<E, T> extends Bloc<E, T> with DisposeListenable {
  BlocCloseNotificationsAbstract(T initialState) : super(initialState);

  @override
  Future<void> close() {
    notifyListeners();
    disposeDisposeListenable();
    return super.close();
  }
}
