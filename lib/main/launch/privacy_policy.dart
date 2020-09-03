import 'package:cityCloud/main/launch/advertising.dart';
import 'package:cityCloud/router/router.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:cityCloud/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umeng_sdk/umeng_sdk.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MethodChannel methodChannel = MethodChannel('custom_push');
    methodChannel.setMethodCallHandler((call) async{
      print(call.method);
      return true;
    });

    // EventChannel eventChannel = EventChannel('custom_push_event');
    // eventChannel.receiveBroadcastStream().listen((event) {
    //   print('event_channel');
    //   print(event.toString());
    // });
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
                  Spacer(),
                  SizedBox(
                    width: 164,
                    height: 43,
                    child: FlatButton(
                      onPressed: () {
                        // UmengSdk.onEvent('openApp', {'key':'hello'});
                        // UmengSdk.onEvent('hello', {'key':'hello'});
                        // UmengSdk.onPageStart('helloworld');
                        methodChannel.invokeMethod('hello method');
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      color: ColorHelper.ColorE3,
                      child: Text(
                        '不同意',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 164,
                    height: 43,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(context, Router.routeForPage(page: AdvertisingPage()));
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
                      color: Colors.red,
                      child: Text(
                        '同意',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
