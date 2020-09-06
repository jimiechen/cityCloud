package com.example.cityCloud;

import android.os.Bundle;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import android.util.Log;

//import com.umeng.commonsdk.UMConfigure;
//import com.umeng.message.IUmengRegisterCallback;
//import com.umeng.message.PushAgent;

//import org.android.agoo.huawei.HuaWeiRegister;
//import org.android.agoo.mezu.MeizuRegister;
//import org.android.agoo.oppo.OppoRegister;
//import org.android.agoo.vivo.VivoRegister;
//import org.android.agoo.xiaomi.MiPushRegistar;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import umeng_push.UmengPushPlugin;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        UmengPushPlugin.instance.initUmengSDK(this);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        UmengPushPlugin.registerWith(flutterEngine);
        super.configureFlutterEngine(flutterEngine);
    }
}
