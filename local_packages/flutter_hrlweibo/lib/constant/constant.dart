import 'package:event_bus/event_bus.dart';

class Constant {
   static const baseUrl ='http://api.citycloud.caiquant.com/';
  // static const baseUrl = 'http://212.64.95.5:8080/hrlweibo/';

  static const String ASSETS_IMG = 'packages/$PackageName/assets/images/';

  static const bool ISDEBUG = true;

  static const String SP_USER = 'sp_user';

  static const String SP_KEYBOARD_HEGIHT = 'sp_keyboard_hegiht'; //软键盘高度

  static const int PAGE_SIZE = 10;

  static const PackageName = 'flutter_hrlweibo';

  static final EventBus eventBus = new EventBus();
}
