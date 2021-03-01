import 'dart:io';

import 'package:dio/dio.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';

class UpdateUtil {
  /// 下载apk
  static Future<File> downloadApk(
    String url, {
    String filePath,
    Function(int, int) downloadProgress,
  }) async {
    if (filePath == null || filePath.isEmpty) {
      Directory storageDir = await getExternalStorageDirectory();
      filePath = "${storageDir.path}/app.apk";
    }

    /// 创建存储文件
    File file = new File(filePath);
    if(file.existsSync()){
      return file;
    }
    if (!file.existsSync()) {
      file.createSync();
    }
    try {
      /// 发起下载请求
      Response response = await Dio().get(url,
          onReceiveProgress: downloadProgress,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
          ));
      file.writeAsBytesSync(response.data);
    } catch (e) {
      print(e);
    }
    return file;
  }

  /// 安装apk
  static Future installApk(
    String url,
    String appId, {
    String filePath,
    Function(int, int) downloadProgress,
  }) async {
    File _apkFile = await downloadApk(
      url,
      filePath: filePath,
      downloadProgress: downloadProgress,
    );
    String _apkFilePath = _apkFile.path;
    if (_apkFilePath.isEmpty) {
      throw Exception("文件不存在");
    }
    InstallPlugin.installApk(_apkFilePath, appId);
  }
}
