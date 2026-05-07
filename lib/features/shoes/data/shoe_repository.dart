/// 封装跑鞋、预置鞋库与活动相关的数据访问。
import 'dart:math';

import 'package:shoecloud/core/constants/app_constants.dart';
import 'package:shoecloud/core/network/api_client.dart';
import 'package:shoecloud/features/activities/models/shoe_activity.dart';
import 'package:shoecloud/features/shoes/models/shoe.dart';
import 'package:shoecloud/features/shoes/models/shoe_catalog_item.dart';
import 'package:shoecloud/features/user/models/user_profile.dart';

class ShoeRepository {
  ShoeRepository(this._client);

  final ApiClient _client;

  Future<List<ShoeCatalogItem>> fetchCatalog() async {
    final response = await _client.get(ApiPaths.addShoeCatalog);
    if (response is! List) {
      return const [];
    }

    return response
        .map((item) => ShoeCatalogItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Shoe>> fetchShoes(List<UserShoeReference> references) async {
    if (references.isEmpty) {
      return const [];
    }

    final timestamp = '?t=${DateTime.now().millisecondsSinceEpoch}';
    final requests = references.map(
      (item) => _client.get(ApiPaths.userInfo + item.detailUrl + timestamp),
    );
    final responses = await Future.wait(requests);

    return responses
        .whereType<Map<String, dynamic>>()
        .map(Shoe.fromJson)
        .toList();
  }

  Future<Shoe?> fetchSingleShoeById(String shoeId) async {
    final timestamp = '?t=${DateTime.now().millisecondsSinceEpoch}';
    final path =
        '${ApiPaths.userInfo}/user_example/shoes/shoe_$shoeId/shoe_$shoeId.json$timestamp';
    final response = await _client.get(path);
    if (response is Map<String, dynamic>) {
      return Shoe.fromJson(response);
    }
    return null;
  }

  Future<bool> addShoe({
    required String userId,
    required String shoeName,
    required String shoeId,
    required Map<String, dynamic> fullDetail,
  }) async {
    final response = await _client.post(
      ApiPaths.addNewShoe,
      params: {
        'userId': userId,
        'newEntry': {
          'shoeId': shoeId,
          'shoeName': shoeName,
          'detailUrl': buildDetailUrl(userId: userId, shoeId: shoeId),
        },
        'fullDetail': fullDetail,
      },
    );
    return response != null;
  }

  Future<bool> updateShoe({
    required String userId,
    required String shoeId,
    required Map<String, dynamic> newInfo,
  }) async {
    final response = await _client.post(
      ApiPaths.updateShoeDetail,
      params: {
        'user_id': userId,
        'shoe_id': shoeId,
        'new_info': newInfo,
      },
    );
    return response != null;
  }

  Future<bool> deleteShoe({
    required String userId,
    required String shoeId,
  }) async {
    final response = await _client.post(
      ApiPaths.deleteShoe,
      params: {'user_id': userId, 'shoe_id': shoeId},
    );
    return response != null;
  }

  Future<List<ShoeActivity>> fetchActivities(String url) async {
    if (url.isEmpty) {
      return const [];
    }

    final stamp = url.contains('?')
        ? '&t=${DateTime.now().millisecondsSinceEpoch}'
        : '?t=${DateTime.now().millisecondsSinceEpoch}';
    final response = await _client.get(url + stamp);
    if (response is! List) {
      return const [];
    }

    return response
        .map((item) => ShoeActivity.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>?> fetchActivityDetail(String jsonUrl) async {
    if (jsonUrl.isEmpty) {
      return null;
    }

    final stamp = jsonUrl.contains('?')
        ? '&t=${DateTime.now().millisecondsSinceEpoch}'
        : '?t=${DateTime.now().millisecondsSinceEpoch}';
    final response = await _client.get(jsonUrl + stamp);
    return response is Map<String, dynamic> ? response : null;
  }

  Future<Map<String, dynamic>?> checkPendingActivities(String userId) async {
    final response = await _client.post(
      ApiPaths.checkPendingActivities,
      params: {'userId': userId},
    );
    return response is Map<String, dynamic> ? response : null;
  }

  Future<Map<String, dynamic>?> moveSingleActivity({
    required String userId,
    required String shoeId,
    required String fileName,
  }) async {
    final response = await _client.post(
      ApiPaths.moveSingleActivity,
      params: {'userId': userId, 'shoeId': shoeId, 'fileName': fileName},
    );
    return response is Map<String, dynamic> ? response : null;
  }

  Future<bool> deleteSyncedActivity({
    required String userId,
    required String shoeId,
    required String activityId,
  }) async {
    final response = await _client.post(
      ApiPaths.deleteSyncedActivity,
      params: {
        'userId': userId,
        'shoeId': shoeId,
        'activityId': activityId,
      },
    );
    return response != null;
  }

  static String generateShoeId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = Random().nextInt(900) + 100;
    return '$timestamp$random';
  }

  static String buildDetailUrl({
    required String userId,
    required String shoeId,
  }) {
    return '/user_$userId/shoes/shoe_$shoeId/shoe_$shoeId.json';
  }
}
