package com.cc.cityCloud;

import android.os.Bundle;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import android.util.Log;

import com.umeng.commonsdk.UMConfigure;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import umeng_push.UmengPushPlugin;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        UmengPushPlugin.instance.registerWith(flutterEngine,this);
        super.configureFlutterEngine(flutterEngine);
    }
}
