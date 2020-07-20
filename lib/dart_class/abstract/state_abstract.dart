import '../mixn/dispose_listenable.dart';
import 'package:flutter/material.dart';

abstract class StateDisposeNotificationsAbstract<T extends StatefulWidget> extends State<T> with DisposeListenable {
  @override
  void dispose() {
    notifyListeners();
    disposeDisposeListenable();
    super.dispose();
  }
}
