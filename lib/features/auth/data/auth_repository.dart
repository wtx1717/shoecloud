/// 处理登录数据访问，并隔离底层传输细节。
import 'package:shoecloud/core/constants/app_constants.dart';
import 'package:shoecloud/core/network/api_client.dart';
import 'package:shoecloud/features/session/models/user_login.dart';

class AuthRepository {
  AuthRepository(this._client);

  final ApiClient _client;

  Future<UserLogin?> login({
    required String account,
    required String password,
  }) async {
    final response = await _client.post(
      ApiPaths.login,
      params: {'account': account, 'password': password},
    );

    if (response is! List) {
      return null;
    }

    try {
      final match = response.firstWhere(
        (item) =>
            item['account'].toString() == account &&
            item['password'].toString() == password,
      );
      return UserLogin.fromJson(match as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
