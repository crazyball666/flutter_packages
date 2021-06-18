library ef_update_util;

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ef_update_util/src/android_update_util.dart';
import 'package:ef_update_util/src/ios_update_util.dart';

abstract class EFUpdateUtil {
  factory EFUpdateUtil() {
    if (Platform.isAndroid) {
      return AndroidUpdateUtil();
    } else if (Platform.isIOS) {
      return IOSUpdateUtil();
    } else {
      return null;
    }
  }

  Future update({
    String androidUrl,
    String iosUrl,
    String filePath,
    Function(int current, int total) downloadProgress,
    CancelToken cancelToken,
  });
}
