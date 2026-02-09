import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:shoecloud/api/shoeInfo.dart';
import 'package:shoecloud/viewmodels/shoeInfo.dart';
import 'package:shoecloud/viewmodels/userInfo.dart';

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
  void _handleDeepLink(BuildContext context, Uri uri) async {
    if (uri.scheme == 'shoecloud' && uri.host == 'bind') {
      // 获取路径中的 shoeId (bind/123)
      final shoeId = uri.pathSegments.last;

      // 获取 Query 参数中的 userId (?userId=456)
      final userId = uri.queryParameters['userId'];

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
      try {
        // 关键步骤：把 NFC 的 ID 变成 API 需要的 ShoeItem 格式
        // 这里的 detailUrl 路径必须和你服务器上存放 JSON 的规则一致
        final tempItem = ShoeItem(
          shoeId: shoeId,
          shoeName: "",
          detailUrl: "/user_$userId/shoes/shoe_$shoeId/shoe_$shoeId.json",
        );

        // 3. 调用你刚才发给我的那个批量接口，只传这一双鞋进去
        final List<ShoeInfo> result = await getShoeInfoAPI([tempItem]);

        if (result.isNotEmpty) {
          final targetShoe = result.first;

          // 4. 执行跳转，传入详情页现在需要的 Map 结构
          if (context.mounted) {
            Navigator.pushNamed(
              context,
              "/shoeInfo_User",
              arguments: {"shoeInfo": targetShoe}, // 确保 Key 是 'shoeInfo'
            );
          }
        } else {
          debugPrint("未找到 ID 为 $shoeId 的鞋子详情");
        }
      } catch (e) {
        debugPrint("NFC 跳转流程出错: $e");
      }
    }
  }

  /// 销毁监听
  void dispose() {
    _linkSubscription?.cancel();
  }
}
