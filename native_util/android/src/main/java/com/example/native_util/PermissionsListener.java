package com.example.native_util;

import io.flutter.Log;
import io.flutter.plugin.common.PluginRegistry;

public class PermissionsListener implements PluginRegistry.RequestPermissionsResultListener {
    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        Log.i("asd","-----");
        return false;
    }
}
