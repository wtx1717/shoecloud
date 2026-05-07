/// 监听 NFC 标签触发的深链，并跳转到跑鞋详情。
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/features/shoes/data/shoe_repository.dart';

class DeepLinkNfcManager {
  DeepLinkNfcManager(this._repository);

  final ShoeRepository _repository;
  final AppLinks _links = AppLinks();

  StreamSubscription<Uri>? _subscription;
  String? _lastShoeId;
  DateTime? _lastAt;

  Future<void> init() async {
    final initial = await _links.getInitialLink();
    if (initial != null) {
      await _handle(initial);
    }

    _subscription ??= _links.uriLinkStream.listen((uri) {
      _handle(uri);
    });
  }

  Future<void> _handle(Uri uri) async {
    if (uri.scheme != 'shoecloud' || uri.host != 'bind') {
      return;
    }

    final shoeId = uri.pathSegments.isEmpty ? '' : uri.pathSegments.last;
    final now = DateTime.now();
    if (_lastShoeId == shoeId &&
        _lastAt != null &&
        now.difference(_lastAt!).inMilliseconds < 1000) {
      return;
    }

    _lastShoeId = shoeId;
    _lastAt = now;

    final shoe = await _repository.fetchSingleShoeById(shoeId);
    if (shoe == null) {
      return;
    }

    Get.toNamed(
      AppRoutes.shoeDetail,
      arguments: {'shoe': shoe, 'autoSync': true},
    );
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
