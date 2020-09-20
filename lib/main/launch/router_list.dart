import 'package:cityCloud/router/router.dart';
import 'package:cityCloud/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hrlweibo/flutter_hrlweibo.dart';

class RouterListPage extends StatefulWidget {
  @override
  _RouterListPageState createState() => _RouterListPageState();
}

class _RouterListPageState extends State<RouterListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(titleText: '通用路由'),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouterManager.routeForPage(
                    page: WeiBoDetailPage(
                      mModel: WeiBoModel.fromJson({"weiboId":"207","categoryId":"2","content":"四年前的今天，Mamba out \\n#科比退役四周年:1# ​​​​","vediourl":"","tail":"iPhone客户端","createtime":1586966528000,"zanStatus":0,"zhuanfaNum":86234,"likeNum":54726,"commentNum":12592,"userInfo":{"id":66,"nick":"湖帮","headurl":"http://212.64.95.5:8080/hrlweibo/file/user66.jpg","decs":"知名体育博主 体育视频自媒体","ismember":0,"isvertify":1},"picurl":["https://wx2.sinaimg.cn/mw690/006UBP0wly1gdsk7ymezsj30u011fqe2.jpg"],"zfContent":null,"zfNick":null,"zfUserId":null,"zfPicurl":[],"zfWeiBoId":null,"zfVedioUrl":null,"containZf":false}),
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text('微博详情页面'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
