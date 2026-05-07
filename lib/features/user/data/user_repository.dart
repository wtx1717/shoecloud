/// 处理用户资料的获取与更新请求。
import 'package:shoecloud/core/constants/app_constants.dart';
import 'package:shoecloud/core/network/api_client.dart';
import 'package:shoecloud/features/user/models/user_profile.dart';

class UserRepository {
  UserRepository(this._client);

  final ApiClient _client;

  Future<UserProfile?> fetchUserProfile(String infoUrl) async {
    final response = await _client.get(ApiPaths.userInfo + infoUrl);
    if (response is Map<String, dynamic>) {
      return UserProfile.fromJson(response);
    }
    return null;
  }

  Future<bool> updateUserInfo({
    required String userId,
    required Map<String, dynamic> updateFields,
  }) async {
    final response = await _client.post(
      ApiPaths.updateUserInfo,
      params: {'userId': userId, ...updateFields},
    );
    return response != null;
  }
}
