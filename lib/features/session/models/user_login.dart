/// 定义会话状态使用的轻量登录模型。
class UserLogin {
  UserLogin({
    required this.userId,
    required this.account,
    required this.password,
    required this.userName,
    required this.token,
  });

  final String userId;
  final String account;
  final String password;
  final String userName;
  final String token;

  bool get isLoggedIn => userId.isNotEmpty && token.isNotEmpty;

  factory UserLogin.empty() {
    return UserLogin(
      userId: '',
      account: '',
      password: '',
      userName: '',
      token: '',
    );
  }

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      userId: json['userId']?.toString() ?? '',
      account: json['account']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
    );
  }
}
