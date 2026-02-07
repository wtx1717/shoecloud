class userLogin {
  String userId;
  String account;
  String password; // 匹配你的静态 JSON 校验
  String token;
  userLogin({
    required this.userId,
    required this.account,
    required this.password,
    required this.token,
  });

  // 扩展一个工厂函数，符合你的命名习惯 formJSON
  factory userLogin.formJSON(Map<String, dynamic> json) {
    return userLogin(
      userId: json["userId"]?.toString() ?? "",
      account: json["account"] ?? "",
      password: json["password"] ?? "",
      token: json["token"] ?? "",
    );
  }
}
