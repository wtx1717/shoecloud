/// 持久化轻量级会话数据，如 token 和 userId。
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoecloud/core/constants/app_constants.dart';

class SessionStorage {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  String _token = '';
  String _userId = '';

  String get token => _token;
  String get userId => _userId;
  bool get hasSession => _token.isNotEmpty && _userId.isNotEmpty;

  Future<void> init() async {
    final prefs = await _prefs;
    _token = prefs.getString(AppConstants.tokenStorageKey) ?? '';
    _userId = prefs.getString(AppConstants.userIdStorageKey) ?? '';
  }

  Future<void> saveSession({
    required String token,
    required String userId,
  }) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.tokenStorageKey, token);
    await prefs.setString(AppConstants.userIdStorageKey, userId);
    _token = token;
    _userId = userId;
  }

  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.remove(AppConstants.tokenStorageKey);
    await prefs.remove(AppConstants.userIdStorageKey);
    _token = '';
    _userId = '';
  }
}
