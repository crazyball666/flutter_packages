import 'dart:async';

import 'package:flutter/services.dart';

class EfBugly {
  static const MethodChannel _channel = const MethodChannel('ef_bugly');

  /// 开启bugly
  static Future startBugly(String appId) async {
    await _channel.invokeMethod('startBugly', {
      "appId": appId,
    });
  }

  /// 设置关键数据，随崩溃信息上报
  static Future setData(String key, String value) async {
    await _channel.invokeMethod('setData', {
      "key": key,
      "value": value,
    });
  }

  /// 上报自定义异常
  static Future reportException({
    int category,
    String name,
    String reason,
    String callStack,
    Map<String,String> extraInfo,
    bool terminateApp,
  }) async {
    await _channel.invokeMethod('reportException', {
      "category": category,
      "name": name,
      "reason": reason,
      "callStack": callStack,
      "extraInfo": extraInfo,
      "terminateApp": terminateApp,
    });
  }
}
