import 'package:cityCloud/const/config.dart';
import 'package:cityCloud/main/game/helper/game_data_downloader.dart';
import 'package:cityCloud/router/general_router_manager.dart';
import 'package:cityCloud/user_info/user_info.dart';
import 'package:cityCloud/util/image_helper.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
// import 'package:umeng_sdk/umeng_sdk.dart';
import 'package:pangolin/pangolin.dart' as Pangolin;

class LifeCycle with WidgetsBindingObserver {
  /*
   * app的生命周期回调，如进入后台或者从后台进入前台
   */
  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        // JpushManager().resume();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // JpushManager().stop();
        break;
    }
  }

  ///App 初始化
  static initApp(BuildContext context) async {
    GeneralRouterManager.init(context);

    ///初始化友盟统计
    // UmengSdk.initCommon(UMENG_APP_KEY, UMENG_APP_KEY, UMENG_CHANNEL).then((value) {
    //   UmengSdk.onEvent('openApp', {});
    //   // UmengSdk.onPageStart('hello');
    // });

    Pangolin.registerPangolin(
        appId: PangolinAppID, useTextureView: true, appName: PangolinAppName, allowShowNotify: true, allowShowPageWhenScreenLock: true, debug: true, supportMultiProcess: true);

    ///初始化的时候加载游戏初始数据，如果是正式开发移到登陆后加载
    GameDataDownloader.getGameData().then((value) {
      UserInfo().gameDataSyncServer = value;
    });

    ///预加载图片
    Flame.images.loadAll([...ImageHelper.mapTileViews]);
  }

  ///请求相关权限，会弹出权限确认框
  static askForPermission() {
    Future(() async {
      // await Permission.camera.request().then((value) {});
      // await Permission.contacts.request().then((value) {});
      // if (Platform.isAndroid) {
      //   await Permission.locationWhenInUse.request().then((value) {});
      // } else {
      //   LocationManager().init();
      // }
      // JpushManager().init();
    });
  }

/*
 * 登录，可以按实际需要添加参数
 */
  static loginIn() {}
/*
 * 退出登录，可以按实际需要添加参数
 */
  static loginOut() {}
}
