import 'package:cityCloud/expanded/umeng_push/umeng_push.dart';
import 'package:cityCloud/main/home/home_page.dart';
import 'package:cityCloud/main/launch/advertising.dart';
import 'package:cityCloud/main/launch/upush_test.dart';
import 'package:cityCloud/router/router.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:cityCloud/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:pangolin/pangolin.dart' as Pangolin;

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        leading: SizedBox(),
        titleText: '隐私政策',
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Text(
                '这里是隐私政策,这里是隐私政策,这里是隐私政策,这里是隐私政策,这里是隐私政策,这里是隐私政策,',
              ),
            ],
          ),
          Positioned(
            bottom: 36 + MediaQuery.of(context).padding.bottom,
            left: 0,
            right: 0,
            child: Container(
              height: 44,
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(context, Router.routeForPage(page: UPushTestPage()));
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      color: ColorHelper.ColorE3,
                      child: Text(
                        '友盟推送测试',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      color: ColorHelper.ColorE3,
                      child: Text(
                        '不同意',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            Router.routeForPage(
                              page: HomePage(),
                            ),
                          );
                        // Navigator.push(context, Router.routeForPage(page: AdvertisingPage()));
                        Pangolin.loadSplashAd(mCodeId: "887359684", debug: false).then((value) {
                          
                        }).whenComplete((){
                          print('conplete');
                        });
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
                      color: Colors.red,
                      child: Text(
                        '同意',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
