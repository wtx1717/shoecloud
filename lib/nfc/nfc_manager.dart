import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:shoecloud/api/shoeInfo.dart';
import 'package:shoecloud/viewmodels/shoeInfo.dart';
import 'package:shoecloud/viewmodels/userInfo.dart';

class NfcManager {
  static final NfcManager _instance = NfcManager._internal();
  factory NfcManager() => _instance;
  NfcManager._internal();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  String? _lastProcessedId;
  DateTime? _lastProcessTime;

  void init(BuildContext context) {
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) _handleDeepLink(context, uri);
    });

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(context, uri);
    });
  }

  void _handleDeepLink(BuildContext context, Uri uri) async {
    if (uri.scheme == 'shoecloud' && uri.host == 'bind') {
      final shoeId = uri.pathSegments.last;
      final userId = uri.queryParameters['userId'];

      // 防抖：1秒内重复触发无效
      final now = DateTime.now();
      if (_lastProcessedId == shoeId &&
          _lastProcessTime != null &&
          now.difference(_lastProcessTime!).inMilliseconds < 1000) {
        return;
      }

      _lastProcessedId = shoeId;
      _lastProcessTime = now;

      try {
        final tempItem = ShoeItem(
          shoeId: shoeId,
          shoeName: "",
          detailUrl: "/user_$userId/shoes/shoe_$shoeId/shoe_$shoeId.json",
        );

        final List<ShoeInfo> result = await getShoeInfoAPI([tempItem]);

        if (result.isNotEmpty && context.mounted) {
          final targetShoe = result.first;

          // --- 关键修改：携带 fromNfc 标志跳转 ---
          Navigator.pushNamed(
            context,
            "/shoeInfo_User",
            arguments: {
              "shoeInfo": targetShoe,
              "fromNfc": true, // 告诉详情页：自动执行同步
            },
          );
        }
      } catch (e) {
        debugPrint("NFC 跳转流程出错: $e");
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
