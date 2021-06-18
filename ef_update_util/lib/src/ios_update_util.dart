import 'package:dio/src/cancel_token.dart';
import 'package:ef_update_util/ef_update_util.dart';
import 'package:url_launcher/url_launcher.dart';

class IOSUpdateUtil implements EFUpdateUtil {
  @override
  Future update({
    String androidUrl,
    String iosUrl,
    String filePath,
    Function(int current, int total) downloadProgress,
    CancelToken cancelToken,
  }) async {
    await launch(iosUrl, forceSafariVC: false);
  }
}
