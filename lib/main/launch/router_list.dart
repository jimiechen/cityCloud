import 'package:cityCloud/router/general_router_manager.dart';
import 'package:cityCloud/widgets/default_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouterListPage extends StatefulWidget {
  @override
  _RouterListPageState createState() => _RouterListPageState();
}

class ItemModel {
  final String name;
  final GeneralRouterParamater info;

  ItemModel({this.name, this.info});
}

class _RouterListPageState extends State<RouterListPage> {
  bool _showPuzzleCaptcha = false;
  final List<ItemModel> routerList = [
    ItemModel(
      name: '查看本地数据库记录',
      info: GeneralRouterParamater(routerType: GeneralRouterType.LookDatabase),
    ),
    ItemModel(
      name: '查看日志',
      info: GeneralRouterParamater(routerType: GeneralRouterType.Log),
    ),
    ItemModel(
      name: 'MobileIMSDK 测试',
      info: GeneralRouterParamater(routerType: GeneralRouterType.MobileIMSDK),
    ),
    ItemModel(
      name: '通用设置',
      info: GeneralRouterParamater(),
    ),
    ItemModel(
      name: '跳转webview',
      info: GeneralRouterParamater(
        routerType: GeneralRouterType.Webview,
        routerParamater: {
          'title': 'webview测试',
          'url': 'https://www.baidu.com',
        },
      ),
    ),
    ItemModel(
      name: '跳转flutter页面',
      info: GeneralRouterParamater(routerType: GeneralRouterType.Flutter, routerParamater: {
        'pageType': GeneralRouterFlutterPageType.WeiboDetail.index,
        'pageParamater': {
          "weiboId": "207",
          "categoryId": "2",
          "content": "四年前的今天，Mamba out \\n#科比退役四周年:1# ​​​​",
          "vediourl": "",
          "tail": "iPhone客户端",
          "createtime": 1586966528000,
          "zanStatus": 0,
          "zhuanfaNum": 86234,
          "likeNum": 54726,
          "commentNum": 12592,
          "userInfo": {"id": 66, "nick": "湖帮", "headurl": "http://212.64.95.5:8080/hrlweibo/file/user66.jpg", "decs": "知名体育博主 体育视频自媒体", "ismember": 0, "isvertify": 1},
          "picurl": ["https://wx2.sinaimg.cn/mw690/006UBP0wly1gdsk7ymezsj30u011fqe2.jpg"],
          "zfContent": null,
          "zfNick": null,
          "zfUserId": null,
          "zfPicurl": [],
          "zfWeiBoId": null,
          "zfVedioUrl": null,
          "containZf": false
        },
      }),
    ),
    ItemModel(
      name: '跳转原生页面',
      info: GeneralRouterParamater(),
    ),
    ItemModel(
      name: '广告弹框',
      info: GeneralRouterParamater(routerType: GeneralRouterType.PopupAd),
    ),
    ItemModel(
        name: '进入闪屏广告',
        info: GeneralRouterParamater(
          routerType: GeneralRouterType.SplashAd,
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleText: '通用路由',
        actions: [
          CupertinoSwitch(
            value: _showPuzzleCaptcha,
            onChanged: (result) {
              setState(() {
                _showPuzzleCaptcha = result;
              });
            },
          )
        ],
      ),
      body:
          // WebView(
          //     initialUrl: 'https://www.baidu.com',
          //     //JS执行模式 是否允许JS执行
          //     javascriptMode: JavascriptMode.unrestricted),
          ListView.separated(
              itemBuilder: (_, index) {
                ItemModel info = routerList[index];
                return Container(
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      info.info.showPuzzleCheck = _showPuzzleCaptcha;
                      GeneralRouterManager.responseToRouterParamater(info.info);
                    },
                    child: ListTile(
                      title: Text(info.name),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => Divider(
                    height: 1,
                  ),
              itemCount: routerList.length),
    );
  }
}
