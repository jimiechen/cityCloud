package umeng_push;

import androidx.annotation.NonNull;

import android.app.Activity;
import android.app.Notification;
import android.content.Context;
import android.os.Handler;
import android.util.Log;
import android.widget.Toast;

import com.google.gson.Gson;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.message.IUmengCallback;
import com.umeng.message.IUmengRegisterCallback;
import com.umeng.message.MsgConstant;
import com.umeng.message.PushAgent;
import com.umeng.message.UTrack;
import com.umeng.message.UmengMessageHandler;
import com.umeng.message.UmengNotificationClickHandler;
import com.umeng.message.common.inter.ITagManager;
import com.umeng.message.entity.UMessage;
import com.umeng.message.tag.TagManager;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class UmengPushPlugin implements MethodChannel.MethodCallHandler {
    private static String TAG = "| UMeng | Flutter | Android | ";
    public static UmengPushPlugin instance;
    private final PushAgent pushAgent;
    private  MethodChannel channel;
    private Activity uiActivity;

    public void registerWith(@NonNull FlutterEngine flutterEngine,@NonNull Activity activity) {
        uiActivity = activity;
         channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "umeng_push");
        channel.setMethodCallHandler(this);
    }

    private UmengPushPlugin(PushAgent uPushAgent) {
        this.pushAgent = uPushAgent;
        setupMessageHandler();
        setupNotificationOnClickHandler();
        instance = this;
    }

    public static void initUmengSDK(Context context){
        // 在此处调用基础组件包提供的初始化函数 相应信息可在应用管理 -> 应用信息 中找到 http://message.umeng.com/list/apps
// 参数一：当前上下文context；
// 参数二：应用申请的Appkey（需替换）；
// 参数三：渠道名称；
// 参数四：设备类型，必须参数，传参数为UMConfigure.DEVICE_TYPE_PHONE则表示手机；传参数为UMConfigure.DEVICE_TYPE_BOX则表示盒子；默认为手机；
// 参数五：Push推送业务的secret 填充Umeng Message Secret对应信息（需替换）
        // UMConfigure.init(context, "5f59808acf77fa286ea11dce", "Umeng", UMConfigure.DEVICE_TYPE_PHONE, "b569836638386b32bdede4644bd1ec21");
        UMConfigure.init(context, "5f253e41d309322154740f7b", "Umeng", UMConfigure.DEVICE_TYPE_PHONE, "0d11d95882b42b19d4a131f28c6965e6");
        UMConfigure.setLogEnabled(true);
//获取消息推送代理示例
        PushAgent uPushAgent = PushAgent.getInstance(context);
//注册推送服务，每次调用register方法都会回调该接口
        uPushAgent.register(new IUmengRegisterCallback() {

            @Override
            public void onSuccess(String deviceToken) {
                //注册成功会返回deviceToken deviceToken是推送消息的唯一标志
                Log.i(TAG,"注册成功：deviceToken：-------->  " + deviceToken);
            }

            @Override
            public void onFailure(String s, String s1) {
                Log.e(TAG,"注册失败：-------->  " + "s:" + s + ",s1:" + s1);
            }
        });
        UmengPushPlugin umengPushPlugin = new UmengPushPlugin(uPushAgent);
//        pushAgent.setNotificationPlaySound(MsgConstant.NOTIFICATION_PLAY_SERVER); //服务端控制声音
//        pushAgent.setNotificationPlayLights(MsgConstant.NOTIFICATION_PLAY_SDK_ENABLE);//客户端允许呼吸灯点亮
//        pushAgent.setNotificationPlayVibrate(MsgConstant.NOTIFICATION_PLAY_SDK_ENABLE);//客户端禁止振动
        // PushAgent.getInstance(context).onAppStart();

        /**
         * 初始化厂商通道
         */
        //小米通道
//        MiPushRegistar.register(this, "填写您在小米后台APP对应的xiaomi id", "填写您在小米后台APP对应的xiaomi key");
//        //华为通道，注意华为通道的初始化参数在minifest中配置
//        HuaWeiRegister.register(this);
//        //魅族通道
//        MeizuRegister.register(this, "填写您在魅族后台APP对应的app id", "填写您在魅族后台APP对应的app key");
//        //OPPO通道
//        OppoRegister.register(this, "填写您在OPPO后台APP对应的app key", "填写您在魅族后台APP对应的app secret");
//        //VIVO 通道，注意VIVO通道的初始化参数在minifest中配置
//        VivoRegister.register(this);
    }

    private void setupNotificationOnClickHandler(){
        UmengNotificationClickHandler notificationClickHandler = new UmengNotificationClickHandler() {
            @Override
            public void handleMessage(Context context, UMessage uMessage) {
                super.handleMessage(context, uMessage);
                sendMessage("onOpenNotification",uMessage.getRaw());
            }
        };
        pushAgent.setNotificationClickHandler(notificationClickHandler);
    }

    private  void setupMessageHandler(){
        UmengMessageHandler messageHandler = new UmengMessageHandler() {

            @Override
            public Notification getNotification(Context context, UMessage msg) {
                sendMessage("onReceiveNotification",msg.getRaw());
                return super.getNotification(context, msg);
            }
            @Override
            public void dealWithCustomMessage(final Context context, final UMessage msg) {
                sendMessage("onReceiveMessage",msg.getRaw());
            }
        };
        pushAgent.setMessageHandler(messageHandler);
    }

    void sendMessage(@NonNull String method, JSONObject jsonObject){

        uiActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                //此时已在主线程中，更新UI
                try{
                    Map<String, Object> data = new Gson().fromJson(jsonObject.toString(), HashMap.class);;
                    channel.invokeMethod(method,data);
                }catch (Throwable error){
                    Log.i(TAG,error.toString());
                }
            }
        });
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Log.i(TAG,call.method);
        uiActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (call.method.equals("getPlatformVersion")) {
                    result.success("Android " + android.os.Build.VERSION.RELEASE);
//        } else if (call.method.equals("setTags")) {
//            setTags(call, result);
                } else if (call.method.equals("cleanTags")) {
                    cleanTags(call, result);
                } else if (call.method.equals("addTags")) {
                    addTags(call, result);
                } else if (call.method.equals("deleteTags")) {
                    deleteTags(call, result);
                } else if (call.method.equals("getAllTags")) {
                    getAllTags(call, result);
                } else if (call.method.equals("setAlias")) {
                    setAlias(call, result);
                } else if (call.method.equals("deleteAlias")) {
                    deleteAlias(call, result);;
                } else if (call.method.equals("stopPush")) {
                    stopPush(call, result);
                } else if (call.method.equals("resumePush")) {
                    resumePush(call, result);
//        } else if (call.method.equals("clearAllNotifications")) {
//            clearAllNotifications(call, result);
//        } else if (call.method.equals("clearNotification")) {
//            clearNotification(call,result);
//        } else if (call.method.equals("getLaunchAppNotification")) {
//            getLaunchAppNotification(call, result);
                } else if (call.method.equals("getRegistrationID")) {
                    getRegistrationID(call, result);
//        } else if (call.method.equals("sendLocalNotification")) {
//            sendLocalNotification(call, result);
//        } else if (call.method.equals("setBadge")) {
//            setBadge(call, result);
                } else {
                    result.notImplemented();
                }
            }
        });
    }


    void resultCallback(@NonNull MethodChannel.Result result,Object value) {
        uiActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                result.success(value);
            }
        });
    }


//    public void setTags(MethodCall call, MethodChannel.Result result) {
//        Log.d(TAG,"setTags：");
//
//        List<String> tagList = call.arguments();
//        Set<String> tags = new HashSet<>(tagList);
//
//    }

    public void cleanTags(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG,"cleanTags:");
        pushAgent.getTagManager().getTags(new TagManager.TagListCallBack() {
            @Override
            public void onMessage(boolean b, List<String> list) {
               uiActivity.runOnUiThread(new Runnable() {
                   @Override
                   public void run() {
                       pushAgent.getTagManager().deleteTags(new TagManager.TCallBack() {
                           @Override
                           public void onMessage(boolean b, ITagManager.Result tagResult) {
                               Map<String,Object> map = new HashMap<>();
                               map.put("result",b);
                               map.put("tags",list.toArray(new String[0]));
                               resultCallback(result,map);
                           }
                       }, list.toArray(new String[0]));
                   }
               });
            }
        });
    }

    public void addTags(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG,"addTags: " + call.arguments);

        List<String>tagList = call.arguments();
        Set<String> tags = new HashSet<>(tagList);
        String[] tagArray = tags.toArray(new String[0]);
        pushAgent.getTagManager().addTags(new TagManager.TCallBack() {
            @Override
            public void onMessage(boolean b, ITagManager.Result addTagsResult) {
                Map<String,Object> map = new HashMap<>();
                map.put("result",b);
                map.put("tags",tags.toArray(new String[0]));
                resultCallback(result,map);
            }
        },tagArray);
    }

    public void deleteTags(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG,"deleteTags： " + call.arguments);

        List<String>tagList = call.arguments();
        Set<String> tags = new HashSet<>(tagList);
        pushAgent.getTagManager().deleteTags(new TagManager.TCallBack() {
            @Override
            public void onMessage(boolean b, ITagManager.Result deleteResult) {
                Map<String,Object> map = new HashMap<>();
                map.put("result",b);
                map.put("tags",tags.toArray(new String[0]));
                resultCallback(result,map);
            }
        }, tags.toArray(new String[0]));
    }

    public void getAllTags(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG,"getAllTags： ");
        pushAgent.getTagManager().getTags(new TagManager.TagListCallBack() {
            @Override
            public void onMessage(boolean b, List<String> list) {
                Map<String,Object> map = new HashMap<>();
                map.put("result",b);
                map.put("tags",list);
                resultCallback(result,map);
            }
        });
    }

    public void setAlias(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG,"setAlias: " + call.arguments);
        HashMap<String, Object> map = call.arguments();
        String alias = (String) map.get("alias");
        String aliasType = (String) map.get("aliasType");
        pushAgent.setAlias(alias,aliasType, new UTrack.ICallBack() {
            @Override
            public void onMessage(boolean b, String s) {
                Map<String,Object> map = new HashMap<>();
                map.put("result",b);
                map.put("alias",s);
                resultCallback(result,map);
            }
        });
    }

    public void deleteAlias(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG,"deleteAlias:");

        HashMap<String, Object> map = call.arguments();
        String alias = (String) map.get("alias");
        String aliasType = (String) map.get("aliasType");
        pushAgent.deleteAlias(alias,aliasType, new UTrack.ICallBack() {
            @Override
            public void onMessage(boolean b, String s) {
                Map<String,Object> map = new HashMap<>();
                map.put("result",b);
                map.put("alias",s);
                resultCallback(result,map);
            }
        });
    }

    public void stopPush(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG,"stopPush:");

        pushAgent.disable(new IUmengCallback() {

            @Override
            public void onSuccess() {
                resultCallback(result,true);
            }

            @Override
            public void onFailure(String s, String s1) {
                resultCallback(result,false);
            }

        });
    }

    public void resumePush(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG,"resumePush:");

        pushAgent.enable(new IUmengCallback() {

            @Override
            public void onSuccess() {
                resultCallback(result,true);
            }

            @Override
            public void onFailure(String s, String s1) {
                resultCallback(result,false);
            }

        });
    }

//    public void clearAllNotifications(MethodCall call, MethodChannel.Result result) {
//        Log.d(TAG,"clearAllNotifications: ");
//
//    }
//    public void clearNotification(MethodCall call, MethodChannel.Result result) {
//        Log.d(TAG,"clearNotification: ");
//        Object id = call.arguments;
////        if (id != null) {
////            JPushInterface.clearNotificationById(registrar.context(),(int)id);
////        }
//    }
//
//    public void getLaunchAppNotification(MethodCall call, MethodChannel.Result result) {
//        Log.d(TAG,"");
//
//
//    }

    public void getRegistrationID(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG,"getRegistrationID: ");
        //实际上就是友盟的token
        String registrationID = pushAgent.getRegistrationId();
        result.success(registrationID);
    }


//    public void sendLocalNotification(MethodCall call, MethodChannel.Result result) {
//        Log.d(TAG,"sendLocalNotification: " + call.arguments);
//
//        try {
//            HashMap<String, Object> map = call.arguments();
//
//            JPushLocalNotification ln = new JPushLocalNotification();
//            ln.setBuilderId((Integer)map.get("buildId"));
//            ln.setNotificationId((Integer)map.get("id"));
//            ln.setTitle((String) map.get("title"));
//            ln.setContent((String) map.get("content"));
//            HashMap<String, Object> extra = (HashMap<String, Object>)map.get("extra");
//
//            if (extra != null) {
//                JSONObject json = new JSONObject(extra);
//                ln.setExtras(json.toString());
//            }
//
//            long date = (long) map.get("fireTime");
//            ln.setBroadcastTime(date);
//
//            JPushInterface.addLocalNotification(registrar.context(), ln);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }

//    public void setBadge(MethodCall call, MethodChannel.Result result) {
//        Log.d(TAG,"setBadge: " + call.arguments);

//        HashMap<String, Object> map = call.arguments();
//        Object numObject = map.get("badge");
//        if (numObject != null) {
//            int num = (int)numObject;
//            JPushInterface.setBadgeNumber(registrar.context(),num);
//            result.success(true);
//        }
//    }
}
