import 'dart:async';

import 'package:flutter/services.dart';
import 'package:native_util/UpdateUtil/UpdateUtil.dart';
import 'dart:io';

class NativeUtil {
  static const MethodChannel _channel = const MethodChannel('native_util');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<File> download(String url,
      {Function(int, int) downloadProgress}) async {
    return await UpdateUtil.downloadApk(
      url,
      downloadProgress: downloadProgress,
    );
  }

  static Future installApk(String url, String appId,
      {String filePath, Function(int, int) downloadProgress}) async {
    UpdateUtil.installApk(url, appId,
        filePath: filePath, downloadProgress: downloadProgress);
  }
}
