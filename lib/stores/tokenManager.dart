import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  Future<SharedPreferences> _getInstance() {
    return SharedPreferences.getInstance();
  }

  String _token = '';
  String _userId = ''; // 这里存的就是用户唯一的 ID，比如 "example"

  // 修改初始化：从磁盘把 ID 读出来
  Future<void> init() async {
    final prefs = await _getInstance();
    _token = prefs.getString("token_key") ?? "";
    _userId = prefs.getString("user_id_key") ?? ""; // 这里的 user_id_key 只是个标签名
  }

  // 把用户的唯一 ID 存入磁盘
  Future<void> setUserId(String id) async {
    final prefs = await _getInstance();
    await prefs.setString(
      "user_id_key",
      id,
    ); // 把 "example" 存进 "user_id_key" 这个抽屉里
    _userId = id; // 更新内存中的 ID
  }

  // 获取 ID
  String getUserId() {
    return _userId;
  }

  // 设置token (保持原样)
  Future<void> setToken(String val) async {
    final prefs = await _getInstance();
    prefs.setString("token_key", val);
    _token = val;
  }

  String getToken() {
    return _token;
  }

  // 清理函数：退出登录时一起删掉
  Future<void> removeLoginInfo() async {
    final prefs = await _getInstance();
    await prefs.remove("token_key");
    await prefs.remove("user_id_key");
    _token = '';
    _userId = '';
  }
}

final tokenManager = TokenManager();
