import 'package:cityCloud/const/const.dart';
import 'package:cityCloud/expanded/network_api/network_api.dart';
import 'package:cityCloud/expanded/umeng_push/umeng_push.dart';
import 'package:cityCloud/util/util.dart';
import 'package:cityCloud/widgets/default_app_bar.dart';
import 'package:cityCloud/widgets/toast.dart';
import 'package:flutter/material.dart';

class UPushTestPage extends StatefulWidget {
  @override
  _UPushTestPageState createState() => _UPushTestPageState();
}

class _UPushTestPageState extends State<UPushTestPage> {
  String _deviceToken = '';
  String _messageTitle = '以下是消息内容：';
  Map<String, dynamic> _message = {};
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _typeTextEditingController = TextEditingController(text: DefaultAliasType);
  @override
  void initState() {
    super.initState();
    UmengPush().getRegistrationID().then((value) {
      if (value is String) {
        print('deviceToken: $value');
        setState(() {
          _deviceToken = value;
        });
        uploadDeviceToken(value);
      }
    });
    UmengPush().addEventHandler(
      onReceiveNotification: (json) async {
        _messageTitle = '推送（notification）：';
        _message = json;
        setState(() {});
      },
      onReceiveMessage: (json) async {
        _messageTitle = '自定义消息（message）：';
        _message = json;
        setState(() {});
      },
      onOpenNotification: (json) async {
        _messageTitle = '点击通知栏打开（notification）：';
        _message = json;
        setState(() {});
      },
    );
  }

  void uploadDeviceToken(String deviceToken) {
    NetworkDio.post(
      url: API_CREATE_OBJECT,
      body: {
        'data': deviceToken,
        'uid': 'cc',
        'data_type': NetworkDataType.umengToken,
        'data_format': NetworkDataFormat.string,
        'source': Util.deviceStrType,
        'create_time': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      },
    ).then((value) {
      CustomToast.showShort('上传友盟token成功');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleText: '友盟推送测试',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '以下是DeviceToken:',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
          Text(_deviceToken),
          SizedBox(
            height: 12,
          ),
          Text(
            _messageTitle,
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
          Text(_message.toString()),
          Spacer(),
          Container(
            height: 66,
            padding: const EdgeInsets.all(8),
            color: Colors.yellow,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('alias:'),
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                  ),
                ),
                Text('aliasType:'),
                Expanded(
                  child: TextField(
                    controller: _typeTextEditingController,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            color: Colors.lightBlue,
            child: Row(
              children: [
                Expanded(
                  child: FlatButton(
                    child: Text('设置alias'),
                    onPressed: () {
                      UmengPush().setAlias(alias: _textEditingController.text, aliasType: _typeTextEditingController.text).then((value) => print(value));
                    },
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    child: Text('删除alias'),
                    onPressed: () {
                      UmengPush().deleteAlias(alias: _textEditingController.text, aliasType: _typeTextEditingController.text).then((value) => print(value));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
