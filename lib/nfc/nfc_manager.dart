import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class NfcManager {
  // 单例模式
  static final NfcManager _instance = NfcManager._internal();
  factory NfcManager() => _instance;
  NfcManager._internal();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  // 防抖变量
  String? _lastProcessedId;
  DateTime? _lastProcessTime;

  /// 初始化监听
  void init(BuildContext context) {
    // 1. 处理从“完全关闭”状态被唤醒
    _appLinks.getInitialLink().then((uri) {
      // ignore: use_build_context_synchronously
      if (uri != null) _handleDeepLink(context, uri);
    });

    // 2. 处理后台唤醒
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      // ignore: use_build_context_synchronously
      _handleDeepLink(context, uri);
    });
  }

  /// 核心跳转逻辑
  void _handleDeepLink(BuildContext context, Uri uri) {
    if (uri.scheme == 'shoecloud' && uri.host == 'bind') {
      final shoeId = uri.pathSegments.last;

      // 防抖逻辑
      final now = DateTime.now();
      if (_lastProcessedId == shoeId &&
          _lastProcessTime != null &&
          now.difference(_lastProcessTime!).inMilliseconds < 1000) {
        return;
      }

      _lastProcessedId = shoeId;
      _lastProcessTime = now;

      // 执行跳转
      // 注意：由于是异步触发，跳转前最好检查 context 是否还在
      if (Navigator.canPop(context) || true) {
        Navigator.pushNamed(context, "/shoeInfo_User", arguments: shoeId);
      }
    }
  }

  /// 销毁监听
  void dispose() {
    _linkSubscription?.cancel();
  }
}
