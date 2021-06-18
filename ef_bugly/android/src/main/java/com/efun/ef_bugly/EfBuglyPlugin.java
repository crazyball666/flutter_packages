package com.efun.ef_bugly;

import android.content.Context;

import com.tencent.bugly.Bugly;
import com.tencent.bugly.crashreport.CrashReport;

import java.util.Map;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * EfBuglyPlugin
 */
public class EfBuglyPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context appContext;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        appContext = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ef_bugly");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "startBugly": {
                if (call.hasArgument("appId")) {
                    new BuglyUtil(appContext).startBugly(call.<String>argument("appId"));
                }
                result.success(null);
                break;
            }
            case "setData": {
                String key = call.argument("key");
                String value = call.argument("value");
                new BuglyUtil(appContext).setData(key, value);
                result.success(null);
                break;
            }
            case "reportException": {
                int category = call.argument("category");
                String name = call.argument("name");
                String reason = call.argument("reason");
                String callStack = call.argument("callStack");
                Map<String, String> extraInfo = call.argument("extraInfo");
                new BuglyUtil(appContext).reportException(category, name, reason, callStack, extraInfo);
                result.success(null);
                break;
            }
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}

class BuglyUtil {
    private final Context context;

    BuglyUtil(Context appContext) {
        this.context = appContext;
    }

    void startBugly(String appId) {
        Bugly.init(this.context, appId, true);
    }

    void setData(String key, String value) {
        CrashReport.putUserData(this.context, key, value);
    }

    void reportException(int category, String name, String reason, String callStack, Map<String, String> extraInfo) {
        CrashReport.postException(category, name, reason, callStack, extraInfo);
    }
}