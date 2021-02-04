import 'dart:async';
import 'package:flutter/material.dart';

class ToastUtil {
  static List<GlobalKey<_ToastState>> _keyList = [];

  static int maxToastNum = 0;

  static showToast(
    BuildContext context, {
    Icon icon,
    String text,
    Color color = Colors.yellow,
    TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
    Duration toastDuration = const Duration(seconds: 2),
    Duration animateDuration = const Duration(milliseconds: 250),
    double initialDistance = 60,
    double translateDistance = 30,
    EdgeInsets padding = const EdgeInsets.all(8),
    double borderRadius = 10,
    BoxConstraints constraints = const BoxConstraints(maxWidth: 300),
    double interval = 20,
  }) {
    var key = GlobalKey<_ToastState>();
    _Toast toast = _Toast(
      key: key,
      icon: icon,
      text: text,
      color: color,
      textStyle: textStyle,
      toastDuration: toastDuration,
      animateDuration: animateDuration,
      initialDistance: initialDistance,
      translateDistance: translateDistance,
      padding: padding,
      borderRadius: borderRadius,
      constraints: constraints,
      interval: interval,
    );
    OverlayEntry entry = OverlayEntry(builder: (context) => toast);
    toast.didShow = (_ToastState state, double y) {
      _keyList.forEach((key) {
        key.currentState.moveDown(y);
      });
      _keyList.add(key);
      if (maxToastNum > 0 && _keyList.length > maxToastNum) {
        _keyList.sublist(0, _keyList.length - maxToastNum).forEach((key) {
          key.currentState.setRemove();
        });
      }
    };
    toast.didDismiss = (_ToastState state, double y) {
      _keyList.remove(key);
      entry.remove();
    };
    Overlay.of(context).insert(entry);
  }

  static showSuccessToast(BuildContext context, String text) {
    showToast(
      context,
      icon: Icon(
        Icons.check,
        color: Colors.white,
        size: 24,
      ),
      text: text,
      color: Color(0xFF00CC76),
    );
  }

  static showErrorToast(BuildContext context, String text) {
    showToast(
      context,
      icon: Icon(
        Icons.error,
        color: Colors.white,
        size: 24,
      ),
      text: text,
      color: Colors.redAccent,
    );
  }
}

class _Toast extends StatefulWidget {
  final Key key;
  final Icon icon;
  final String text;
  final Color color;
  final TextStyle textStyle;
  final Duration toastDuration; // 显示时间
  final Duration animateDuration; // 动画时间
  final double initialDistance; // 初始距离
  final double translateDistance; // 动画偏移距离
  final EdgeInsets padding; // 内边距
  final double borderRadius; // 圆角
  final BoxConstraints constraints; // 大小约束
  final double interval; // 间隔距离
  Function(_ToastState state, double height) didShow;
  Function(_ToastState state, double height) didDismiss;

  _Toast({
    this.key,
    this.icon,
    this.text,
    this.color = Colors.black,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 16),
    this.toastDuration = const Duration(seconds: 2),
    this.animateDuration = const Duration(milliseconds: 300),
    this.initialDistance = 60,
    this.translateDistance = 30,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = 10,
    this.constraints = const BoxConstraints(maxWidth: 300),
    this.interval = 20,
    this.didShow,
    this.didDismiss,
  });

  @override
  State<StatefulWidget> createState() => _ToastState();
}

class _ToastState extends State<_Toast> {
  int _status = 0; //0初始化 1显示过渡中 2显示中 3消失过渡中 4消失完成
  double _opacity = 0;
  double _translateY = 0;
  Timer _timer;
  GlobalKey _key = GlobalKey();
  bool _shouldRemove = false;

  void moveDown(double y) {
    setState(() {
      _translateY += y + widget.interval;
    });
  }

  void setRemove() {
    _shouldRemove = true;
    _remove();
  }

  void _remove() {
    if (_status == 2) {
      _destroyTimer();
      setState(() {
        _status = 3;
        _opacity = 0;
        _translateY += widget.translateDistance;
      });
    }
  }

  void _animatedEnd() {
    if (_status == 1) {
      _status = 2;
      if (_shouldRemove) {
        setRemove();
      } else {
        _timer = Timer(widget.toastDuration, () {
          setRemove();
        });
      }
    } else if (_status == 3) {
      _status = 4;
      if (widget.didDismiss != null) {
        widget.didDismiss(this, _key.currentContext.size.height);
      }
    }
  }

  void _startAnimate() {
    if (_status == 0) {
      widget.didShow(this, _key.currentContext.size.height);
      setState(() {
        _status = 1;
        _opacity = 1;
        _translateY += widget.translateDistance;
      });
    }
  }

  void _destroyTimer() {
    if (_timer != null) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _startAnimate();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _destroyTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: widget.initialDistance - widget.translateDistance,
      bottom: null,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              key: _key,
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: widget.animateDuration,
                transform: Matrix4.translationValues(0, _translateY, 0),
                onEnd: _animatedEnd,
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: widget.animateDuration,
                  child: Container(
                    constraints: widget.constraints,
                    padding: widget.padding,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      color: widget.color,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: widget.icon,
                          padding: widget.icon != null
                              ? EdgeInsets.only(right: 8)
                              : null,
                        ),
                        Flexible(
                          child: Text(
                            widget.text ?? "",
                            softWrap: true,
                            overflow: TextOverflow.clip,
                            style: widget.textStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
