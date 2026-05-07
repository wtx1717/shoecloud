/// 组合仓储能力，提供跑鞋相关业务动作。
import 'package:shoecloud/features/session/presentation/controllers/app_session_controller.dart';
import 'package:shoecloud/features/shoes/data/shoe_repository.dart';
import 'package:shoecloud/features/shoes/models/shoe.dart';
import 'package:shoecloud/features/shoes/models/shoe_catalog_item.dart';

class ShoeService {
  ShoeService(this._repository, this._sessionController);

  final ShoeRepository _repository;
  final AppSessionController _sessionController;

  Future<List<ShoeCatalogItem>> loadCatalog() {
    return _repository.fetchCatalog();
  }

  Future<Shoe?> reloadShoe(String shoeId) {
    return _repository.fetchSingleShoeById(shoeId);
  }

  Future<bool> addFromCatalog({
    required ShoeCatalogItem item,
    required String nickname,
    required double size,
    required double purchasePrice,
  }) async {
    final userId = _sessionController.userId;
    if (userId.isEmpty) {
      return false;
    }

    final shoeId = ShoeRepository.generateShoeId();
    final detail = {
      'code': '1',
      'msg': 'success',
      'result': {
        'shoe_id': shoeId,
        'shoe_name': item.name,
        'brand': item.brand,
        'nickname': nickname,
        'size': size,
        'purchase_price': purchasePrice,
        'retail_price': item.releasePrice,
        'release_year': item.releaseYear,
        'category': item.category,
        'description': item.description,
        'imagesUrl': item.imagesUrl,
        'features': item.features,
        'is_retired': false,
        'bind_time': DateTime.now().toString().split('.').first,
      },
    };

    final success = await _repository.addShoe(
      userId: userId,
      shoeName: item.name,
      shoeId: shoeId,
      fullDetail: detail,
    );

    if (success) {
      await _sessionController.refreshUserProfile();
    }

    return success;
  }

  Future<bool> updateShoe({
    required Shoe shoe,
    required String nickname,
    required double size,
    required double purchasePrice,
    required bool isRetired,
  }) async {
    final success = await _repository.updateShoe(
      userId: _sessionController.userId,
      shoeId: shoe.shoeId,
      newInfo: {
        'nickname': nickname,
        'size': size,
        'purchase_price': purchasePrice,
        'is_retired': isRetired,
      },
    );

    if (success) {
      await _sessionController.refreshUserProfile();
    }

    return success;
  }

  Future<bool> deleteShoe(Shoe shoe) async {
    final success = await _repository.deleteShoe(
      userId: _sessionController.userId,
      shoeId: shoe.shoeId,
    );

    if (success) {
      await _sessionController.refreshUserProfile();
    }

    return success;
  }

  Future<Map<String, dynamic>?> checkPendingActivities(String userId) {
    return _repository.checkPendingActivities(userId);
  }

  Future<Map<String, dynamic>?> syncActivity({
    required String userId,
    required String shoeId,
    required String fileName,
  }) {
    return _repository.moveSingleActivity(
      userId: userId,
      shoeId: shoeId,
      fileName: fileName,
    );
  }
}
