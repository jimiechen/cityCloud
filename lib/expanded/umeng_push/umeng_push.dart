import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:platform/platform.dart';

typedef Future<dynamic> EventHandler(Map<String, dynamic> event);
const String DefaultAliasType = 'DefaultAliasType';

class UmengPush {
  final String flutterLog = "| UMENG_PUSH | Flutter | ";
  factory UmengPush() => _instance;

  final MethodChannel _channel;
  final Platform _platform;

  @visibleForTesting
  UmengPush.private(MethodChannel channel, Platform platform)
      : _channel = channel,
        _platform = platform;

  static final UmengPush _instance = new UmengPush.private(const MethodChannel('umeng_push'), const LocalPlatform());

  EventHandler _onReceiveNotification;
  EventHandler _onOpenNotification;
  EventHandler _onReceiveMessage;
  EventHandler _onReceiveNotificationAuthorization;

  ///
  /// 初始化 JPush 必须先初始化才能执行其他操作(比如接收事件传递)
  ///
  void addEventHandler({
    EventHandler onReceiveNotification,
    EventHandler onOpenNotification,
    EventHandler onReceiveMessage,
    EventHandler onReceiveNotificationAuthorization,
  }) {
    print(flutterLog + "addEventHandler:");

    _onReceiveNotification = onReceiveNotification;
    _onOpenNotification = onOpenNotification;
    _onReceiveMessage = onReceiveMessage;
    _onReceiveNotificationAuthorization = onReceiveNotificationAuthorization;
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<Null> _handleMethod(MethodCall call) async {
    print(flutterLog + "_handleMethod:");

    switch (call.method) {
      case "onReceiveNotification":
        return _onReceiveNotification(call.arguments.cast<String, dynamic>());
      case "onOpenNotification":
        return _onOpenNotification(call.arguments.cast<String, dynamic>());
      case "onReceiveMessage":
        return _onReceiveMessage(call.arguments.cast<String, dynamic>());
      case "onReceiveNotificationAuthorization":
        return _onReceiveNotificationAuthorization(call.arguments.cast<String, dynamic>());
      default:
        throw new UnsupportedError("Unrecognized Event");
    }
  }

  ///
  /// iOS Only
  /// 申请推送权限，注意这个方法只会向用户弹出一次推送权限请求（如果用户不同意，之后只能用户到设置页面里面勾选相应权限），需要开发者选择合适的时机调用。
  ///
  void applyPushAuthority([NotificationSettingsIOS iosSettings = const NotificationSettingsIOS()]) {
    print(flutterLog + "applyPushAuthority:");

    if (!_platform.isIOS) {
      return;
    }

    _channel.invokeMethod('applyPushAuthority', iosSettings.toMap());
  }

  ///
  /// 设置 Tag （会覆盖之前设置的 tags）
  ///
  /// @param {Array} params = [String]
  /// @param {Function} success = ({"tags":[String]}) => {  }
  /// @param {Function} fail = ({"errorCode":int}) => {  }
  ///
  // Future<Map<dynamic, dynamic>> setTags(List<String> tags) async {
  //   print(flutterLog + "setTags:");

  //   final Map<dynamic, dynamic> result =
  //       await _channel.invokeMethod('setTags', tags);
  //   return result;
  // }

  ///
  /// 清空所有 tags。
  ///
  /// @param {Function} success = ({"result":true,"tags":[String]}) => {  }
  /// @param {Function} fail = ({"result":false,}) => {  }
  ///
  Future<Map<dynamic, dynamic>> cleanTags() async {
    print(flutterLog + "cleanTags:");

    final Map<dynamic, dynamic> result = await _channel.invokeMethod('cleanTags');
    return result;
  }

  ///
  /// 在原有 tags 的基础上添加 tags
  ///
  /// @param {Array} tags = [String]
  /// @param {Function} success = ({"result":true,"tags":[String]}) => {  }
  /// @param {Function} fail = ({"result":false,}) => {  }
  ///

  Future<Map<dynamic, dynamic>> addTags(List<String> tags) async {
    print(flutterLog + "addTags:");

    final Map<dynamic, dynamic> result = await _channel.invokeMethod('addTags', tags);
    return result;
  }

  ///
  /// 删除指定的 tags
  ///
  /// @param {Array} tags = [String]
  /// @param {Function} success = ({"result":true,"tags":[String]}) => {  }
  /// @param {Function} fail = ({"result":false,}) => {  }
  ///
  Future<Map<dynamic, dynamic>> deleteTags(List<String> tags) async {
    print(flutterLog + "deleteTags:");

    final Map<dynamic, dynamic> result = await _channel.invokeMethod('deleteTags', tags);
    return result;
  }

  ///
  /// 获取所有当前绑定的 tags
  ///
  /// @param {Function} success = ({"result":true,"tags":[String]}) => {  }
  /// @param {Function} fail = ({"result":false,}) => {  }
  ///
  Future<Map<dynamic, dynamic>> getAllTags() async {
    print(flutterLog + "getAllTags:");

    final Map<dynamic, dynamic> result = await _channel.invokeMethod('getAllTags');
    return result;
  }

  ///
  /// 重置 alias.
  ///
  /// @param {String} alias
  ///
  /// @param {Function} success = ({"result":true,"alias":String}) => {  }
  /// @param {Function} fail = ({"result":false,"alias":String}) => {  }
  ///
  Future<Map<dynamic, dynamic>> setAlias({String alias, String aliasType = DefaultAliasType}) async {
    print(flutterLog + "setAlias:");

    final Map<dynamic, dynamic> result = await _channel.invokeMethod('setAlias', {'alias': alias, 'aliasType': aliasType});
    return result;
  }

  ///
  /// 删除原有 alias
  ///
  /// @param {Function} success = ({"result":true,"alias":String}) => {  }
  /// @param {Function} fail = ({"result":false,"alias":String}) => {  }
  ///
  Future<Map<dynamic, dynamic>> deleteAlias({String alias, String aliasType = DefaultAliasType}) async {
    print(flutterLog + "deleteAlias:");

    final Map<dynamic, dynamic> result = await _channel.invokeMethod('deleteAlias', {'alias': alias, 'aliasType': aliasType});
    return result;
  }

  ///
  /// 设置应用 Badge（小红点）
  ///
  /// @param {Int} badge
  ///
  /// 注意：如果是 Android 手机，目前仅支持华为手机
  ///
  Future setBadge(int badge) async {
    print(flutterLog + "setBadge:");

    await _channel.invokeMethod('setBadge', {"badge": badge});
  }

  ///
  /// 停止接收推送，调用该方法后应用将不再受到推送，如果想要重新收到推送可以调用 resumePush。
  ///
  Future stopPush() async {
    print(flutterLog + "stopPush:");

    await _channel.invokeMethod('stopPush');
  }

  ///
  /// 恢复推送功能。
  ///
  Future resumePush() async {
    print(flutterLog + "resumePush:");

    await _channel.invokeMethod('resumePush');
  }

  ///
  /// 清空通知栏上的所有通知。
  ///
  Future clearAllNotifications() async {
    print(flutterLog + "clearAllNotifications:");

    await _channel.invokeMethod('clearAllNotifications');
  }

  ///
  /// 清空通知栏上某个通知
  /// @param notificationId 通知 id，即：LocalNotification id
  ///
  void clearNotification({@required int notificationId}) {
    print(flutterLog + "clearNotification:");
    _channel.invokeListMethod("clearNotification", notificationId);
  }

  ///
  /// 获取 RegistrationId, JPush 可以通过制定 RegistrationId 来进行推送。
  ///
  /// @param {Function} callback = (String) => {}
  ///
  Future<String> getRegistrationID() async {
    print(flutterLog + "getRegistrationID:");

    final String rid = await _channel.invokeMethod('getRegistrationID');
    return rid;
  }

  ///
  /// 发送本地通知到调度器，指定时间出发该通知。
  /// @param {Notification} notification
  ///
  Future<String> sendLocalNotification(LocalNotification notification) async {
    print(flutterLog + "sendLocalNotification:");

    await _channel.invokeMethod('sendLocalNotification', notification.toMap());

    return notification.toMap().toString();
  }

  // /// 调用此 API 检测通知授权状态是否打开
  // Future<bool> isNotificationEnabled() async {
  //   final Map<dynamic, dynamic> result = await _channel.invokeMethod('isNotificationEnabled');
  //   bool isEnabled = result["isEnabled"];
  //   return isEnabled;
  // }
}

class NotificationSettingsIOS {
  final bool sound;
  final bool alert;
  final bool badge;

  const NotificationSettingsIOS({
    this.sound = true,
    this.alert = true,
    this.badge = true,
  });

  Map<String, dynamic> toMap() {
    return <String, bool>{'sound': sound, 'alert': alert, 'badge': badge};
  }
}

/// @property {number} [buildId] - 通知样式：1 为基础样式，2 为自定义样式（需先调用 `setStyleCustom` 设置自定义样式）
/// @property {number} [id] - 通知 id, 可用于取消通知
/// @property {string} [title] - 通知标题
/// @property {string} [content] - 通知内容
/// @property {object} [extra] - extra 字段
/// @property {number} [fireTime] - 通知触发时间（毫秒）
/// // iOS Only
/// @property {number} [badge] - 本地推送触发后应用角标值
/// // iOS Only
/// @property {string} [soundName] - 指定推送的音频文件
/// // iOS 10+ Only
/// @property {string} [subtitle] - 子标题
class LocalNotification {
  final int buildId; //?
  final int id;
  final String title;
  final String content;
  final Map<String, String> extra; //?
  final DateTime fireTime;
  final int badge; //?
  final String soundName; //?
  final String subtitle; //?

  const LocalNotification(
      {@required this.id, @required this.title, @required this.content, @required this.fireTime, this.buildId, this.extra, this.badge = 0, this.soundName, this.subtitle})
      : assert(id != null),
        assert(title != null),
        assert(content != null),
        assert(fireTime != null);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'fireTime': fireTime.millisecondsSinceEpoch,
      'buildId': buildId,
      'extra': extra,
      'badge': badge,
      'soundName': soundName,
      'subtitle': subtitle
    }..removeWhere((key, value) => value == null);
  }
}
