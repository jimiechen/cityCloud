import 'package:cityCloud/const/config.dart';
import 'package:cityCloud/expanded/puzzle_captcha/captcha/block_puzzle_captcha.dart';
import 'package:cityCloud/main/launch/database_data_show.dart';
import 'package:cityCloud/router/router.dart';
import 'package:cityCloud/util/util.dart';
import 'package:cityCloud/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hrlweibo/flutter_hrlweibo.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pangolin/pangolin.dart' as Pangolin;

enum GeneralRouterType {
  LookDatabase, //查看数据库记录
  Log, //查看日志
  GeneralSetting, //通用设置
  // PuzzleCaptcha, //拼图验证码
  Webview, //跳转webview
  Flutter, //跳到flutter页面
  Native, //跳转原生页面
  PopupAd, //弹框广告
  SplashAd, //闪屏广告
}

///用于通用路由跳转的flutter页面区分
enum GeneralRouterFlutterPageType {
  WeiboDetail, //微博详情页
}

class GeneralRouterParamater {
  GeneralRouterType routerType; //页面类型
  bool showPuzzleCheck; //是否显示拼图验证
  dynamic routerParamater; //页面参数
  GeneralRouterParamater({
    @required this.routerType,
    this.routerParamater,
    this.showPuzzleCheck = false,
  });
}

class GeneralRouterManager {
  BuildContext _context;
  GeneralRouterManager._();
  static GeneralRouterManager share = GeneralRouterManager._();
  static void init(BuildContext context) {
    share._context = context;
  }

  static BuildContext get buildContext => share._context;

  static Future<bool> puzzleCaptcha() {
    Completer<bool> completer = Completer<bool>();
    showDialog<Null>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlockPuzzleCaptchaPage(
          onSuccess: (v) {
            completer.complete(true);
          },
          onFail: () {
            completer.complete(false);
          },
        );
      },
    );
    return completer.future;
  }

  static void responseToRouterParamater(GeneralRouterParamater paramater) async {
    ///判断是否需要弹出拼图验证
    if (paramater?.showPuzzleCheck == true) {
      bool result = await puzzleCaptcha();
      if (result == false) return;
    }
    switch (paramater?.routerType) {
      case GeneralRouterType.LookDatabase:
        _gotoLookDatabase();
        break;
      case GeneralRouterType.Log:
        // TODO: Handle this case.
        break;
      case GeneralRouterType.GeneralSetting:
        // TODO: Handle this case.
        break;
      // case GeneralRouterType.PuzzleCaptcha:
      //   break;
      case GeneralRouterType.Webview:
        if (paramater.routerParamater is Map) {
          _gotoWebview(paramater.routerParamater);
        }
        break;
      case GeneralRouterType.Flutter:
        if (paramater.routerParamater is Map) {
          _gotoFlutterPage(paramater.routerParamater);
        }
        break;
      case GeneralRouterType.Native:
        // TODO: Handle this case.
        break;
      case GeneralRouterType.PopupAd:
        Pangolin.loadInterstitialAd(mCodeId: PangolinInterstitialAd, expressViewWidth: 300, expressViewHeight: 300);
        break;
      case GeneralRouterType.SplashAd:
        Pangolin.loadSplashAd(mCodeId: PangolinSplashAdCodeID, debug: false).then((value) {}).whenComplete(() {
          print('conplete');
        });
        break;
    }
  }

  static void _gotoLookDatabase() {
    Navigator.push(buildContext, RouterManager.routeForPage(page: DatabaseDataShowPage()));
  }

  static void _gotoWebview(Map data) {
    String title = data['title'];
    String url = data['url'];
    Navigator.push(
      buildContext,
      RouterManager.routeForPage(
        page: Scaffold(
          appBar: DefaultAppBar(
            titleText: title,
          ),
          body: WebView(
              initialUrl: url,
              //JS执行模式 是否允许JS执行
              javascriptMode: JavascriptMode.unrestricted),
        ),
      ),
    );
  }

  static void _gotoFlutterPage(Map data) {
    int pageTypeIndex = Util.mapValueForPath(data, ['pageType']);
    Map json = Util.mapValueForPath(data, ['pageParamater']);
    if (pageTypeIndex is int && pageTypeIndex >= 0 && pageTypeIndex < GeneralRouterFlutterPageType.values.length) {
      GeneralRouterFlutterPageType type = GeneralRouterFlutterPageType.values[pageTypeIndex];
      switch (type) {
        case GeneralRouterFlutterPageType.WeiboDetail:
          if (json is Map) {
            Navigator.push(
              buildContext,
              RouterManager.routeForPage(
                page: WeiBoDetailPage(
                  mModel: WeiBoModel.fromJson(json),
                ),
              ),
            );
          }
          break;
      }
    }
  }
}
