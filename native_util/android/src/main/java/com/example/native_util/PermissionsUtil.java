package com.example.native_util;

import android.app.Activity;
import android.content.pm.PackageManager;

import java.util.ArrayList;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

public class PermissionsUtil {
    // 请求权限
    public static void requestPermissions(Activity activity, String[] permissions) {
        ArrayList<String> newPermissions = new ArrayList<>();
        for (String permission : permissions) {
            if (ContextCompat.checkSelfPermission(activity.getApplicationContext(), permission) != PackageManager.PERMISSION_GRANTED) {
                newPermissions.add(permission);
            }
        }
        if (newPermissions.size() > 0) {
            ActivityCompat.requestPermissions(activity, newPermissions.toArray(new String[0]), 0);
        }
    }
}

