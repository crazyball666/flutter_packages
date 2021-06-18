import 'package:ef_screen_util/screen_util.dart';

extension SizeExtension on num {
  ///[ScreenUtil.setWidth]
  double get w => EFScreenUtil().setWidth(this);

  ///[ScreenUtil.setHeight]
  double get h => EFScreenUtil().setHeight(this);

  ///[ScreenUtil.radius]
  double get r => EFScreenUtil().radius(this);

  ///[ScreenUtil.setSp]
  double get sp => EFScreenUtil().setSp(this);

  ///[ScreenUtil.setSp]
  double get ssp => EFScreenUtil().setSp(this, allowFontScalingSelf: true);

  ///[ScreenUtil.setSp]
  double get nsp => EFScreenUtil().setSp(this, allowFontScalingSelf: false);

  ///屏幕宽度的倍数
  ///Multiple of screen width
  double get sw => EFScreenUtil().screenWidth * this;

  ///屏幕高度的倍数
  ///Multiple of screen height
  double get sh => EFScreenUtil().screenHeight * this;
}
