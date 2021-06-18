import 'dart:io';
import 'package:ef_update_util/ef_update_util.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';

class AndroidUpdateUtil implements EFUpdateUtil {
  /// 申请储存权限
  Future applyForPermission() async {
    PermissionStatus status = await Permission.storage.request();
    print(status == PermissionStatus.granted);
    if (!status.isGranted) {
      throw Exception("storage permission is not be granted");
    }
  }

  /// 下载apk
  Future<File> downloadApk(
    String url, {
    String filePath,
    Function(int, int) downloadProgress,
    CancelToken cancelToken,
  }) async {
    // 申请权限
    await applyForPermission();

    // 文件路径
    Directory storageDir = await getExternalStorageDirectory();
    if (filePath == null || filePath.isEmpty) {
      filePath = "temp.apk";
    }
    filePath = "${storageDir.path}/$filePath";


    // 删除旧文件
    File file = new File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
    }

    // 发起下载请求
    await Dio().download(
      url,
      file.path,
      onReceiveProgress: downloadProgress,
      cancelToken: cancelToken,
    );

    return file;
  }

  /// 安装apk
  Future installApk(
    String url, {
    String filePath,
    Function(int current, int total) downloadProgress,
    CancelToken cancelToken,
  }) async {
    File _apkFile = await downloadApk(
      url,
      filePath: filePath,
      downloadProgress: downloadProgress,
      cancelToken: cancelToken,
    );
    String _apkFilePath = _apkFile.path;
    if (_apkFilePath.isEmpty) {
      throw Exception("download error");
    }
    PackageInfo info = await PackageInfo.fromPlatform();
    await InstallPlugin.installApk(_apkFilePath, info.packageName);
  }

  @override
  Future update({
    String androidUrl,
    String iosUrl,
    String filePath,
    Function(int current, int total) downloadProgress,
    CancelToken cancelToken,
  }) async {
    await installApk(
      androidUrl,
      filePath: filePath,
      downloadProgress: downloadProgress,
      cancelToken: cancelToken,
    );
  }
}
